
import SwiftUI

struct HuffmanTreeView: View {
    @EnvironmentObject var userState: UserState
    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    @State var text: String = ""
    @State var huffman: Huffman? = nil
    @State var showingHUD = false
    @State var message: String? = nil
    @State var compressedSize: Int? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Create your own Huffman Tree").multilineTextAlignment(.center).font(.title2.bold()).padding(.bottom, 40)
                
                HStack {
                    Text("Enter some small text to compress (less than 15 characters):").foregroundColor(.secondary).font(.caption)
                    Spacer()    
                }
                HStack(alignment: .center, spacing: 10) {
                    TextField("Text to compress", text: $text).textFieldStyle(.roundedBorder).font(.caption).autocorrectionDisabled(true)
                    Button {
                        showingHUD = false
                        message = nil
                        if text.count > 15 {
                            withAnimation() {
                                message = "Please keep it less than 15 characters"
                                showingHUD = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + (2.5) ) {
                                withAnimation() {
                                    showingHUD = true
                                    message = nil
                                }
                            }
                        } else {
                            // submit handler
                            let h = Huffman()
                            let data = text.data(using: .utf8)
                            
                            if let data = data {
                                let compressedData = h.compressData(data: data as NSData)
                                compressedSize = compressedData.length
                                huffman = h
                            } else {
                                showingHUD = true
                                message = "Please make sure the text is English"
                            }
                        }
                    } label: {
                        Text("Compress")
                            .font(.subheadline)
                            .padding(7)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(5)
                            .transition(.scale.combined(with: .opacity))
                    }
                }.padding(.bottom, 50)
                
                if let huffman = huffman {
                    if let compressedSize = compressedSize {
                        Text("Compressed from \(text.count * 8) bits to \(compressedSize * 8) bits").monospacedDigit()
                    }
                    ScrollView(.horizontal) {
                        Diagram(tree: huffman.tree, root: huffman.root, node: { value -> AnyView in
                            nodeRenderer(value: value)
                        }).padding(.bottom, 30)
                    }
                } else {
                    Image(systemName: "scale.3d")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(Color.accentColor.opacity(0.3))
                        .padding(.bottom, 30)
                    
                    HStack{
                        Spacer()
                        Text("Try compressing some text!")
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                }
                
                HStack{
                    if !userState.completionProgress.contains(currentPage.id) {
                        Button {
                            
                            let currentPage = BasicsCourse[userState.currentPage]
                            userState.appendToCompletionProgress(id: currentPage.id)
                        } label: {
                            Text("Next lesson")
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
                .padding(.top, 30)
                .animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5), value: userState.completionProgress)
            }
            
            if showingHUD {
                HUD {
                    if let message = message {
                        HStack(spacing: 25) {
                            HStack{
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(message)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                }
                .zIndex(1)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }

        }
    }
}

struct HUD<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                Capsule()
                    .foregroundColor(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) :  Color(UIColor.systemBackground))
                    .shadow(color: Color(.black).opacity(0.15), radius: 10, x: 0, y: 4)
            )
            .padding(20)
    }
}


struct HuffmanPlaygroundView: View {
    @EnvironmentObject var userState: UserState
    
    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                HuffmanTreeView()
            }
            Spacer()
        }
        .animation(Animation.timingCurve(0.16, 0.9, 0.51, 1, duration: 0.3), value: userState.completionProgress)
    }
}
