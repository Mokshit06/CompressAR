import SwiftUI

struct PagePlaygroundView: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        
        let playgroundViewtoDraw = BasicsCourse[userState.currentPage].playgroundView
        VStack{
            switch playgroundViewtoDraw {
            case .welcomePlaygroundView:
                WelcomePlaygroundView()
            case .compression:
                CompressionPlaygroundView()
            case .huffmanCoding:
                HuffmanPlaygroundView()
            case .quiz:
                QuizPlaygroundView()
            }
        }
        .padding(30)
        .padding(.top, 15)
    }
}
