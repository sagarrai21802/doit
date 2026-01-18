import SwiftUI

struct ContentView: View {
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        // Skip registration - go directly to HomeView
        HomeView()
        
        // Original login check (commented out for now):
        // if userManager.isLoggedIn {
        //     HomeView()
        // } else {
        //     SplashView()
        // }
    }
}
