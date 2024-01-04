import SwiftUI

func stringToBinaryString(_ myString: String) -> String {
    let characterArray = myString
    let asciiArray = characterArray.map({ String($0).unicodeScalars.first!.value })
    let binaryArray = asciiArray.map({ String($0, radix: 2) })
    
    let r = binaryArray.reduce("", { $0! + " " + $1 })
    
    return r.trimmingCharacters(in: .whitespacesAndNewlines)
}

let values = [
    ["A", "B", "C", "D", "E"],
    ["F", "G", "H", "I", "J"],
]

struct EightBitExampleView: View {
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 60) {
                
                ForEach(0..<2, id: \.self) { n in
                    VStack(alignment: .leading) {
                        ForEach(values[n], id: \.self) { c in
                            HStack(spacing: 15) {
                                Text(c).foregroundColor(.accentColor)
                                Text(stringToBinaryString(c)).foregroundColor(.primary)
                            }.monospaced().font(.callout)
                        }
                    }
                }
                
            }.padding(.horizontal, 20).padding(.vertical, 15).background(
                Color(uiColor: .secondarySystemBackground).brightness(0.04)
            ).cornerRadius(10)
            Spacer()
        }
    }
}

struct UnitsRight: View {
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Text("00000000") + Text("01010100").foregroundColor(.accentColor) + Text("00000000")
            }.monospaced().foregroundColor(.primary).font(.body).padding(.horizontal, 20)
                .padding(.vertical, 10).background(
                    Color(uiColor: .secondarySystemBackground).brightness(0.04)
                ).cornerRadius(10)
            
            Spacer()
        }
    }
}

struct HuffmanView : View {
    func rootHuffman() -> Huffman {
        let huffman = Huffman()
        let cmp = huffman.compressData(
                data:
                    "Hello world"
                    .data(using: .utf8)! as NSData)
    
        return huffman
    }
    
    var frequencyTableView: some View {
        let frequencyTable = rootHuffman().frequencyTable()
        
        return HStack {
            Spacer()
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 10) {
//                Spacer()
                ForEach(frequencyTable.sorted(by: { $0.count < $1.count }), id: \.self.byte) { item in
                    VStack(spacing: 3) {
                        Text("\(item.count)").foregroundColor(.primary).font(.body)
                        if item.byte == 32 {
                            Image(systemName: "space").resizable().scaledToFit().foregroundColor(.accentColor)
                                .frame(width: 12, height: 15)
                        } else {
                            Text(String(UnicodeScalar(UInt8(item.byte)))).foregroundColor(
                                .accentColor)
                        }
                    }.monospaced().font(.callout).padding(.vertical, 8).padding(.horizontal, 15)
                        .background(Color(uiColor: .secondarySystemBackground).brightness(0.04))
                }
//                Spacer()
            }.padding(10)
            Spacer()
            //                .background(Color(uiColor: .secondarySystemBackground)).cornerRadius(10)
        }
    }

    var bottomBranchesView: some View {
        let tree = Huffman()
        tree.compressData(data: "Lq".data(using: .utf8)! as NSData)
        
        return HStack {
            Spacer()
            Diagram(tree: tree.tree, root: tree.root, node: { node in 
                nodeRenderer(value: node)
            })
            Spacer()
        }
    }
    
    var moreBranchesView: some View {
        let tree = Huffman()
        tree.compressData(data: "qLb".data(using: .utf8)! as NSData)
        
        return HStack {
            Spacer()
            Diagram(tree: tree.tree, root: tree.root, node: { node in 
                nodeRenderer(value: node)
            })
            Spacer()
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                frequencyTableView
                
                AnyView(Text("Then take the bottom 2 nodes. These are going to be the bottom branches on your ") + Text("Huffman tree").italic() + Text(". Connect them together – one level up with the sum of their frequencies"))
                    .lineSpacing(3.5)
                    .font(.callout).padding(.top, 12)
                
                bottomBranchesView            
                
                Text("Now consider this to be a new node with frequency \"2\", put it back into the frequency list and take the new bottom 2 nodes and connect them")
                    .lineSpacing(3.5)
                    .font(.callout).padding(.top, 12)
                
                moreBranchesView
                
                Text("Keep doing this until you have no more characters left, and you will have a tree that looks something like the following")
                    .lineSpacing(3.5)
                    .font(.callout).padding(.top, 12)
                
                ScrollView(.horizontal) {
                    Diagram(tree: rootHuffman().tree, root: rootHuffman().root, node: { node in 
                        nodeRenderer(value: node)
                    })
                }
                
                Text("This huffman tree tells you how to convert your text into 1s and 0s. For each letter, each time you take a left in the tree write a 0, and each time you take left a 1")
                    .lineSpacing(3.5)
                    .font(.callout).padding(.top, 12)
                
                Text("Compressed Result")
                    .font(.headline.bold())
                    .lineSpacing(3.5).padding(.top, 12)
                
                (Text("With Huffman coding, we were able to compress this to just ") + Text("32 bits = 4 bytes").bold().italic())
                    .lineSpacing(3.5)
                    .font(.body).padding(.top, 12)
                
            }
        }
    }
}
