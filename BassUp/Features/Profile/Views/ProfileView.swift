//
//  ProfileView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingPremium = false
    @State private var showingLanguageSettings = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Profile Header
                profileHeaderSection
                
                // Quick Stats
                quickStatsSection
                
                // Account Settings
                accountSettingsSection
                
                // App Settings
                appSettingsSection
                
                // Support & Info
                supportInfoSection
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
        .sheet(isPresented: $showingLanguageSettings) {
            LanguageSettingsView()
        }
    }
    
    // MARK: - View Sections
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // Profile Image
            if let user = authManager.currentUser {
                AsyncImage(url: user.photoURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color("PrimaryColor"))
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("PrimaryColor"), lineWidth: 3))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color("PrimaryColor"))
            }
            
            // User Info
            VStack(spacing: 4) {
                Text(authManager.currentUser?.displayName ?? "Bass Player")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(authManager.currentUser?.email ?? "user@example.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Premium Badge
            if appState.isPremium {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    
                    Text("Premium Member")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(12)
            }
            
            // Edit Profile Button
            Button("Edit Profile") {
                showingEditProfile = true
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickStatCard(
                    title: "Member Since",
                    value: formatDate(authManager.currentUser?.metadata.creationDate),
                    icon: "calendar",
                    color: .blue
                )
                
                QuickStatCard(
                    title: "Last Login",
                    value: formatDate(authManager.currentUser?.metadata.lastSignInDate),
                    icon: "clock",
                    color: .green
                )
            }
        }
    }
    
    private var accountSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                SettingsRow(
                    title: "Premium Subscription",
                    subtitle: appState.isPremium ? "Active" : "Upgrade for more features",
                    icon: "crown.fill",
                    iconColor: appState.isPremium ? .yellow : .gray
                ) {
                    showingPremium = true
                }
                
                SettingsRow(
                    title: "Change Password",
                    subtitle: "Update your password",
                    icon: "lock.fill",
                    iconColor: .blue
                ) {
                    // Handle password change
                }
                
                SettingsRow(
                    title: "Privacy Settings",
                    subtitle: "Manage your privacy",
                    icon: "hand.raised.fill",
                    iconColor: .green
                ) {
                    // Handle privacy settings
                }
                
                SettingsRow(
                    title: "Export Data",
                    subtitle: "Download your data",
                    icon: "square.and.arrow.down",
                    iconColor: .orange
                ) {
                    // Handle data export
                }
            }
        }
    }
    
    private var appSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("App Settings")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                SettingsRow(
                    title: "Settings",
                    subtitle: "Customize your experience",
                    icon: "gear",
                    iconColor: .gray
                ) {
                    showingSettings = true
                }
                
                SettingsRow(
                    title: "Language",
                    subtitle: languageManager.getCurrentLanguageName(),
                    icon: "globe",
                    iconColor: .blue
                ) {
                    showingLanguageSettings = true
                }
                
                SettingsRow(
                    title: "Notifications",
                    subtitle: appState.notificationsEnabled ? "On" : "Off",
                    icon: "bell.fill",
                    iconColor: appState.notificationsEnabled ? .green : .gray
                ) {
                    // Handle notifications toggle
                }
                
                SettingsRow(
                    title: "Practice Reminders",
                    subtitle: appState.practiceReminders ? "On" : "Off",
                    icon: "alarm.fill",
                    iconColor: appState.practiceReminders ? .blue : .gray
                ) {
                    // Handle practice reminders toggle
                }
                
                SettingsRow(
                    title: "Sound Effects",
                    subtitle: appState.soundEnabled ? "On" : "Off",
                    icon: "speaker.wave.2.fill",
                    iconColor: appState.soundEnabled ? .purple : .gray
                ) {
                    // Handle sound toggle
                }
            }
        }
    }
    
    private var supportInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Support & Info")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                SettingsRow(
                    title: "Help & Support",
                    subtitle: "Get help and contact us",
                    icon: "questionmark.circle.fill",
                    iconColor: .blue
                ) {
                    // Handle help and support
                }
                
                SettingsRow(
                    title: "Feedback",
                    subtitle: "Share your thoughts",
                    icon: "envelope.fill",
                    iconColor: .green
                ) {
                    // Handle feedback
                }
                
                SettingsRow(
                    title: "Rate App",
                    subtitle: "Rate us on the App Store",
                    icon: "star.fill",
                    iconColor: .yellow
                ) {
                    // Handle app rating
                }
                
                SettingsRow(
                    title: "About",
                    subtitle: "App version and info",
                    icon: "info.circle.fill",
                    iconColor: .gray
                ) {
                    // Handle about
                }
                
                SettingsRow(
                    title: "Terms of Service",
                    subtitle: "Read our terms",
                    icon: "doc.text.fill",
                    iconColor: .gray
                ) {
                    // Handle terms of service
                }
                
                SettingsRow(
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy",
                    icon: "hand.raised.fill",
                    iconColor: .gray
                ) {
                    // Handle privacy policy
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Placeholder Views

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Settings View")
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Edit Profile View")
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Premium View")
                .navigationTitle("Premium")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .environmentObject(AuthenticationManager())
                .environmentObject(AppState())
        }
    }
}
