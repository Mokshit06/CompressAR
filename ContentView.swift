import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var userState: UserState
    var body: some View {
        NavigationView {
            PageNavigationView().environmentObject(userState)
        }
    }
}
