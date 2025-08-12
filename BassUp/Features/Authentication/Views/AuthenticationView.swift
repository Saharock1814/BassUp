//
//  AuthenticationView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var showingForgotPassword = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                headerSection
                
                // Form
                formSection
                
                // Action Buttons
                actionButtonsSection
                
                // Additional Options
                additionalOptionsSection
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("PrimaryColor").opacity(0.1), Color.clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
            .alert("Error", isPresented: .constant(authManager.error != nil)) {
                Button("OK") {
                    authManager.error = nil
                }
            } message: {
                Text(authManager.error?.localizedDescription ?? "An error occurred")
            }
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // App Icon/Logo
            Image(systemName: "music.note.list")
                .font(.system(size: 80))
                .foregroundColor(Color("PrimaryColor"))
            
            VStack(spacing: 8) {
                Text(String.appName.localized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(String.appTagline.localized)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Text(isSignUp ? String.authCreateAccount.localized : String.authWelcomeBack.localized)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            if isSignUp {
                // Display Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text(String.authDisplayName.localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField(String.authDisplayNamePlaceholder.localized, text: $displayName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                }
            }
            
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text(String.authEmail.localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField(String.authEmailPlaceholder.localized, text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text(String.authPassword.localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                SecureField(String.authPasswordPlaceholder.localized, text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Primary Action Button
            Button(action: {
                Task {
                    if isSignUp {
                        await authManager.signUp(email: email, password: password, displayName: displayName)
                    } else {
                        await authManager.signIn(email: email, password: password)
                    }
                }
            }) {
                HStack {
                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    
                    Text(isSignUp ? String.authCreateAccountButton.localized : String.authSignIn.localized)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(authManager.isLoading || !isFormValid)
            .opacity(isFormValid ? 1.0 : 0.6)
            
            // Toggle Sign In/Sign Up
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isSignUp.toggle()
                    email = ""
                    password = ""
                    displayName = ""
                }
            }) {
                Text(isSignUp ? String.authAlreadyHaveAccount.localized : String.authDontHaveAccount.localized)
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryColor"))
            }
            .disabled(authManager.isLoading)
        }
    }
    
    private var additionalOptionsSection: some View {
        VStack(spacing: 16) {
            if !isSignUp {
                // Forgot Password
                Button(String.authForgotPassword.localized) {
                    showingForgotPassword = true
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .disabled(authManager.isLoading)
            }
            
            // Social Sign In (placeholder)
            VStack(spacing: 12) {
                Text(String.authOrContinueWith.localized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    SocialSignInButton(
                        title: "Apple",
                        icon: "applelogo",
                        color: .black
                    ) {
                        // Apple Sign In
                    }
                    
                    SocialSignInButton(
                        title: "Google",
                        icon: "globe",
                        color: .red
                    ) {
                        // Google Sign In
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && !password.isEmpty && !displayName.isEmpty && password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
}

// MARK: - Supporting Views

struct SocialSignInButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 60))
                        .foregroundColor(Color("PrimaryColor"))
                    
                    Text("Reset Password")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Enter your email address and we'll send you a link to reset your password.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                // Reset Button
                Button(action: {
                    Task {
                        await authManager.resetPassword(email: email)
                        dismiss()
                    }
                }) {
                    HStack {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text("Send Reset Link")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(authManager.isLoading || email.isEmpty)
                .opacity(email.isEmpty ? 0.6 : 1.0)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthenticationManager())
    }
}
