
import SwiftUI

struct WelcomePlaygroundView: View {
    @EnvironmentObject var userState: UserState

    var currentPage : Page {
        BasicsCourse[userState.currentPage]
    }
    
    var body: some View {
        VStack{
            Image(systemName: "scale.3d")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(Color.accentColor.opacity(0.3))
                .padding(.bottom, 50)

            HStack{
                Spacer()
                Text("This is the playground view where you will be soving the callenges.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
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
        .animation(Animation.timingCurve(0.16, 0.9, 0.51, 1, duration: 0.3), value: userState.completionProgress)
    }
}
