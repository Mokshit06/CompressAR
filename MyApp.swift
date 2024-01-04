import SwiftUI

@main
struct MyApp: App {
    @StateObject var userState = UserState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userState).accentColor(Color.pink)
        }
    }
}
