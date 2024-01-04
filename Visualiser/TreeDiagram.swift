import SwiftUI

class Unique<A>: Identifiable {
    let value: A
    init(_ value: A) { self.value = value }
}

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key:Value] { [:] }
    static func reduce(value: inout [Key:Value], nextValue: () -> [Key:Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

extension CGPoint: VectorArithmetic {
    public static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }
    
    public mutating func scale(by rhs: Double) {
        x *= CGFloat(rhs)
        y *= CGFloat(rhs)
    }
    
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public var magnitudeSquared: Double { return Double(x*x + y*y) }
}

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    var animatableData: AnimatablePair<CGPoint, CGPoint> {
        get { AnimatablePair(from, to) }
        set {
            from = newValue.first
            to = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: self.from)
            p.addLine(to: self.to)
        }
    }
}

struct Diagram<V: View>: View {
    let tree: [Huffman.Node]
    let root: Huffman.NodeIndex
    let node: (Huffman.Node) -> V
    @Environment(\.colorScheme) var colorScheme
    
    typealias Key = CollectDict<Huffman.NodeIndex, Anchor<CGPoint>>

    var body: some View {
        VStack(alignment: .center) {
            let n = tree[root]
            
            node(n).anchorPreference(key: Key.self, value: .center, transform: {
                [tree[root].index: $0]
            })
            HStack(alignment: .bottom, spacing: 0) {
                if n.left != -1 {
                    Diagram(tree: tree, root: n.left, node: node)
                }
                if n.right != -1 {
                    Diagram(tree: tree, root: n.right, node: node)
                }
            }
        }
        .backgroundPreferenceValue(Key.self, { (centers: [Huffman.NodeIndex: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                let n = tree[root]
                if n.left != -1 {
                    Line(from: proxy[centers[n.index]!], to: proxy[centers[n.left]!]).stroke(lineWidth: 2).foregroundColor(.accentColor).brightness(0.3)
                }
                if n.right != -1 {
                    Line(from: proxy[centers[n.index]!], to: proxy[centers[n.right]!]).stroke(lineWidth: 2).foregroundColor(.accentColor)
                }
            }
        })
    }
}
