//
//  ConnonymApp.swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ConnonymApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            determineRootView()
                .environmentObject(authViewModel)
                .onAppear {
                    // Set the initial value of isLoggedIn based on Auth state
                    authViewModel.isLoggedIn = Auth.auth().currentUser != nil
                }
        }
    }

    @ViewBuilder
    func determineRootView() -> some View {
        if Auth.auth().currentUser != nil || authViewModel.isLoggedIn {
            // User is logged in, show ShuffleView or ContentView
            ContentView()
        } else {
            // User is not logged in, show LoginView
            loginView()
        }
    }
}
