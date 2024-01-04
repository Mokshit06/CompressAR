import SwiftUI

struct ARPlaygroundView : View {
    @State var text: String = ""
    @State var submitted = false
    
    var huffman = Huffman()
    
    var body: some View {
        if submitted {
            CustomARViewRepresentable(huffman: huffman)
        } else {
            Text("Visualise Huffman Trees with Augmented Reality").font(.title).bold().padding(.bottom, 30)
            
            VStack {
                Text("Tired of looking at the same old 2D renders of a Huffman tree? What if you could visualise them in 3D using Augmented Reality. Just type in some text to compress and see the magic happen!").font(.body).foregroundColor(.secondary).padding(.bottom, 20)
                
                TextField("Try entering \"World\"...", text: $text).textFieldStyle(.roundedBorder).font(.body).padding(.bottom, 20)
                
                
                Button {
                    huffman.compressData(data: text.data(using: .utf8)! as NSData)
                    submitted = true
                } label: {
                    Text("Visualise in AR").font(.headline)
                        .padding(12)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(10)
                }
                
                
                Image(systemName: "arkit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120, alignment: .center)
                    .foregroundColor(Color.accentColor.opacity(0.4))
                    .padding(.top, 50)
                
                
            }.padding(.horizontal, 40).frame(maxWidth: 900)
        }
    }
}
