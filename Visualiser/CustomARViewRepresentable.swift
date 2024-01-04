import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    var huffman: Huffman
    
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView(huffman: huffman)
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
}
