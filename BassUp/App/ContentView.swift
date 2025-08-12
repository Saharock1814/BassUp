//
//  ContentView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = 0
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                mainTabView
            } else {
                AuthenticationView()
            }
        }
        .animation(.easeInOut, value: authManager.isAuthenticated)
    }
    
    // MARK: - Views
    
    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            // Learn Tab
            NavigationView {
                LearnView()
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text(String.tabLearn.localized)
            }
            .tag(0)
            
            // Practice Tab
            NavigationView {
                PracticeView()
            }
            .tabItem {
                Image(systemName: "music.note")
                Text(String.tabPractice.localized)
            }
            .tag(1)
            
            // Theory Tab
            NavigationView {
                TheoryView()
            }
            .tabItem {
                Image(systemName: "brain.head.profile")
                Text(String.tabTheory.localized)
            }
            .tag(2)
            
            // Progress Tab
            NavigationView {
                ProgressView()
            }
            .tabItem {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text(String.tabProgress.localized)
            }
            .tag(3)
            
            // Profile Tab
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text(String.tabProfile.localized)
            }
            .tag(4)
        }
        .accentColor(Color("PrimaryColor"))
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationManager())
            .environmentObject(ProgressManager())
    }
}
