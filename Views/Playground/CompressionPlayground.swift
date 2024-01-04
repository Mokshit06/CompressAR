
import SwiftUI

struct RoundedCircleStyle: ViewModifier {
    var isLeafNode: Bool
    
    func body(content: Content) -> some View {
        if isLeafNode {
            content
                .frame(width: 35, height: 35)
                .background(Circle().stroke())
                .background(Circle().fill(Color.primary.opacity(2)).colorInvert())
                .padding(10)

        } else {
            content
                .frame(width: 35, height:35)
                .background(Circle().stroke())
                .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                .padding(10)
        }
    }
}

func nodeRenderer(value: Huffman.Node) -> AnyView {
    if value.index == 32 {
        return AnyView(Image(systemName: "space").resizable().scaledToFit().foregroundColor(.primary).frame(width: 20, height: 20).padding(.top, 5).modifier(RoundedCircleStyle(isLeafNode: true)))
    } else{
        let isLeafNode = value.index < 256
        
        if isLeafNode {
            return AnyView(HStack {
                Text(String(UnicodeScalar(UInt8(value.index))))
                Divider()
                Text("\(value.count)")
            }.font(.caption2).foregroundColor(.primary).monospaced().modifier(RoundedCircleStyle(isLeafNode: true)))
        }
        
        return AnyView(Text("\(value.count)").foregroundColor(.primary).monospaced().modifier(RoundedCircleStyle(isLeafNode: false)).font(.caption2))
    }
}

struct BinaryTreeView: View {
    @EnvironmentObject var userState: UserState
    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    
    let huffman: Huffman
    
    init(text: String = "hello") {
        var huff = Huffman()
        
        let str = text;
        let data = str.data(using: .utf8)!
        let _compressed = huff.compressData(data: data as NSData)

        self.huffman = huff
    }
    
    var body: some View {
        VStack {

            Diagram(tree: huffman.tree, root: huffman.root, node: { value -> AnyView in
                nodeRenderer(value: value) }).padding(.bottom, 30)
            
            HStack{
                if !userState.completionProgress.contains(currentPage.id) {
                    Button {
                        /// currently opend page
                        let currentPage = BasicsCourse[userState.currentPage]
                        // Mark lesson as completed
                        userState.appendToCompletionProgress(id: currentPage.id)
                    } label: {
                        Text("Got it")
                            .padding(12)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(10)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .frame(width: 40, height: 40)
                        .padding(5)
                        .padding(.trailing, 4)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5), value: userState.completionProgress)
        }
    }
}


struct CompressionPlaygroundView: View {
    @EnvironmentObject var userState: UserState
   
    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                BinaryTreeView()
            }
            Spacer()
        }
        .animation(Animation.timingCurve(0.16, 0.9, 0.51, 1, duration: 0.3), value: userState.completionProgress)
    }
}
