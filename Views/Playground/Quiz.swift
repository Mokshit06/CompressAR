
import SwiftUI

struct BinaryTreeViewInput: View {
    @EnvironmentObject var userState: UserState
    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    
    let huffman: Huffman
    @State var inputs: [Int: String] = [:]
    @State var showingAlert = false
    
    init() {
        var huff = Huffman()
        
        let str = "bbaddd";
        let data = str.data(using: .utf8)!
        let _compressed = huff.compressData(data: data as NSData)
        
        self.huffman = huff
    }
    
    var body: some View {
        VStack {
            Text("Fill the leaf nodes for the tree if the text was \"bbaddd\"") .multilineTextAlignment(.center).font(.title2.bold()).padding(.bottom, 40)
            
            Diagram(tree: huffman.tree, root: huffman.root, node: { value -> AnyView in
                if value.index == 32 {
                    return AnyView(Image(systemName: "space").resizable().scaledToFit().foregroundColor(.primary).frame(width: 20, height: 20).padding(.top, 5).modifier(RoundedCircleStyle(isLeafNode: true)))
                } else{
                    let isLeafNode = value.index < 256
                    
                    if isLeafNode {
                        return AnyView(TextField("", text: Binding(get: {inputs[value.index, default: ""]}, set: { inputs[value.index] = $0 })).disableAutocorrection(true).font(.caption2).padding(.leading, 9).foregroundColor(.primary).monospaced().modifier(RoundedCircleStyle(isLeafNode: true)))
                    }
                    
                    return AnyView(Text("\(value.count)").foregroundColor(.primary).monospaced().modifier(RoundedCircleStyle(isLeafNode: false)).font(.caption2))
                }
            }).padding(.bottom, 30)
            
            HStack{
                if !userState.completionProgress.contains(currentPage.id) {
                    Button {
                        if inputs[100] == "d" && ((inputs[97] == "b" && inputs[98] == "a") || (inputs[98] == "a" || inputs[97] == "b")) {
                            let currentPage = BasicsCourse[userState.currentPage]
                            // Mark lesson as completed
                            userState.appendToCompletionProgress(id: currentPage.id)
                        } else {
                            showingAlert = true
                        }
                    } label: {
                        Text("Check answer")
                            .padding(12)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(10)
                            .transition(.scale.combined(with: .opacity))
                    }.alert("Recheck the answer", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {}
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


struct QuizPlaygroundView: View {
    @EnvironmentObject var userState: UserState
    
    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                BinaryTreeViewInput()
            }
            Spacer()
        }
        .animation(Animation.timingCurve(0.16, 0.9, 0.51, 1, duration: 0.3), value: userState.completionProgress)
    }
}
