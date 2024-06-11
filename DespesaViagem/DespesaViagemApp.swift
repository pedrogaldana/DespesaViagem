//
//  DespesaViagemApp.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
                
        FirebaseApp.configure()
        return true
    }
}

@main
struct DespesaViagemApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var travelViewModel = TravelViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(travelViewModel)
        }
    }
}
