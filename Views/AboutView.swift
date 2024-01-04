import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                Spacer()
                Image(systemName: "signature")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(
                        Color.accentColor
                            .cornerRadius(15)
                    )
                Spacer()
            }
            
            VStack(spacing: 6){
                Text("About this app")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 7)
                Text("CompressAR")
                    .font(.title2).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            .padding(.bottom, 60)
            
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 35){
                    CalloutView(
                        systemName: "swift",
                        text: "This app was created as a submission for the Apple WWDC23 Swift Student Challenge by Mokshit Jain."
                    )
                    
                    CalloutView(
                        systemName: "person.crop.circle",
                        text: "I am a student, open source contributor and a full stack developer experienced in Typescript, Javascript and Rust. This is my first Swift project. You can read more about me on my [website](https://mokshitjain.co)"
                    )
                    
                    CalloutView(
                        systemName: "book.closed.fill",
                        text: "The idea for this is highly inspired by Tom Scott's video on \"How Computers Compress Text\" which you can watch [here](https://www.youtube.com/watch?v=JsTptu56GM8)"
                    )
                }
                .padding(.leading, 35)
                .padding(.trailing, 35)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
                    .padding(12)
                    .padding(.leading, 6)
                    .padding(.trailing, 6)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding(60)
    }
    
}

// MARK: Callout View
struct CalloutView: View {
    var systemName: String
    var text: String
    
    var body: some View {
        HStack(alignment: .top){
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.accentColor)
                .frame(width: 20, height: 20)
                .padding(10)
                .background(
                    Color.accentColor.opacity(0.1)
                        .cornerRadius(10)
                )
                .padding(.trailing, 20)
            Text(try! AttributedString(markdown: text))
                .font(.footnote)
                .lineSpacing(1.1)
        }
    }
}

// MARK: String extension: toMarkdown()
extension String {
    func toMarkdown() -> AttributedString {
        do {
            return try AttributedString(markdown: self)
        } catch {
            print("Error parsing Markdown for string \(self): \(error)")
            return AttributedString(self)
        }
    }
}
