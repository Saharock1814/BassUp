//
//  BassUpApp.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI
import Firebase

@main
struct BassUpApp: App {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppState()
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var progressManager = ProgressManager()
    @StateObject private var languageManager = LanguageManager()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(authManager)
                .environmentObject(progressManager)
                .environmentObject(languageManager)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupApp() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure app appearance
        configureAppearance()
        
        // Load user progress
        Task {
            await progressManager.loadUserProgress()
        }
    }
    
    private func configureAppearance() {
        // Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(Color("PrimaryColor"))
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color("BackgroundColor"))
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
