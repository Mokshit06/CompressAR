import ARKit
import RealityKit
import SwiftUI

let BOX_WIDTH: Float = 0.1

func createMesh(color: UIColor) -> ModelEntity {
    let block = MeshResource.generateBox(size: [BOX_WIDTH, BOX_WIDTH,0.05], cornerRadius: 0.02)
    let material = SimpleMaterial(color: color, isMetallic: false)
    let entity = ModelEntity(mesh: block, materials: [material])

    return entity
}

func createTextEntity(_ string: String) -> ModelEntity {
    let text = MeshResource.generateText(
        string, extrusionDepth: 0.0001, font: .monospacedSystemFont(ofSize: 0.03, weight: .heavy), containerFrame: .zero,
        alignment: .center)
    let entity = ModelEntity(
        mesh: text, materials: [SimpleMaterial(color: UIColor.white, isMetallic: false)])

    entity.position = [Float(-0.05 * 0.75 * 0.7), Float(-0.025), Float(0.025)]
    
    return entity
}

func createFrequency(_ count: Int, center: Bool = false) -> ModelEntity {
    let text = MeshResource.generateText(
        "\(count)", extrusionDepth: 0.0001, font: .monospacedSystemFont(ofSize: 0.025, weight: center ? .heavy : .medium), containerFrame: .zero,
        alignment: .center)
//    
    let entity = ModelEntity(
        mesh: text, materials: [SimpleMaterial(color: UIColor(Color.white), isMetallic: false)])
    
    if center {
        entity.position = [Float(-0.05 * 0.3 * 0.7), Float(-0.01), Float(0.025)]
    } else {
        entity.position = [Float(0.05 * 0.5 * 0.7), Float(0.010), Float(0.025)]
    }
    
    return entity
}

func findSubtreeDepth(_ index: Int, _ tree: [Huffman.Node], depth: Int = 0) -> Int {
    let curNode = tree[index]
    
    var leftDepth = depth
    if curNode.right != -1 {
        leftDepth += 1
        leftDepth = findSubtreeDepth(curNode.right, tree, depth: leftDepth)
    }
    
    var rightDepth = depth
    if curNode.left != -1 {
        rightDepth += 1
        rightDepth = findSubtreeDepth(curNode.left, tree, depth: rightDepth)
    }
    
    let maxDepth = max(leftDepth, rightDepth)
    
    return maxDepth
}

func traverseTree(_ index: Int, _ tree: [Huffman.Node], _ model: ModelEntity, color: UIColor) {
    let curNode = tree[index]
    
    if curNode.index < 256 {
        let char = String(UnicodeScalar(UInt8(curNode.index)))
        let textEntity = createTextEntity(char)
        let freq = createFrequency(curNode.count)
    
        model.addChild(textEntity)
        model.addChild(freq)
    } else {
        let freq = createFrequency(curNode.count, center: true)
        model.addChild(freq)
//        model.model?.materials[0] = SimpleMaterial(color: .secondarySystemBackground, isMetallic: false)
    }
    
    if curNode.right != -1 || curNode.left != -1 {
        let depth = findSubtreeDepth(index, tree)
        let x = Float(depth) * 0.05 + 0.05
        let y = Float(-0.15)
        
        let vertical =  MeshResource.generatePlane(width: 0.15, depth: 0.01)
        let verticalEntity = ModelEntity(mesh: vertical, materials: [SimpleMaterial(color: .black, isMetallic: false)])
        verticalEntity.position = SIMD3<Float>(0,-0.15/2,0)
        verticalEntity.orientation = simd_quatf(angle: .pi/2, axis: [0,0,1]) * simd_quatf(angle: .pi/2, axis: [1,0,0])
        
        model.addChild(verticalEntity)
        
        let horizontal = MeshResource.generatePlane(width: x*2-BOX_WIDTH, depth: 0.01)
        let horizontalEntity = ModelEntity(mesh: horizontal, materials: [SimpleMaterial(color: .black, isMetallic: false)])
        horizontalEntity.position = SIMD3<Float>(0,-0.15,0)
        horizontalEntity.orientation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        
        model.addChild(horizontalEntity)
        
        if curNode.right != -1 {
            let block = createMesh(color: .darkGray)
            block.position.x = x
            block.position.y = y
            
            traverseTree(curNode.right, tree, block, color: .darkGray)
            model.addChild(block)
        }
        
        if curNode.left != -1 {
            let block = createMesh(color: .darkGray)
            block.position.x = -x
            block.position.y = y
            
            traverseTree(curNode.left, tree, block, color: .lightGray)
            model.addChild(block)
        }
    }
}

class CustomARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(huffman: Huffman) {
        self.init(frame: UIScreen.main.bounds)
        
        let root = createMesh(color: .systemPink)
        let depth = findSubtreeDepth(huffman.root, huffman.tree)
        
        root.position.y = Float(depth) * 0.15
        traverseTree(huffman.root, huffman.tree, root, color: .systemPurple)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(root)
        
        scene.addAnchor(anchor)
        
        environment.sceneUnderstanding.options.insert(.receivesLighting)
        environment.lighting.intensityExponent = 1.0
        renderOptions.insert(.disableHDR)
    }
}
