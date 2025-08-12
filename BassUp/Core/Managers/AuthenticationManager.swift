//
//  AuthenticationManager.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
class AuthenticationManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupAuthStateListener()
    }
    
    // MARK: - Public Methods
    
    func signIn(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            currentUser = result.user
            isAuthenticated = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String, displayName: String) async {
        isLoading = true
        error = nil
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
            
            currentUser = result.user
            isAuthenticated = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            self.error = error
        }
    }
    
    func resetPassword(email: String) async {
        isLoading = true
        error = nil
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func updateProfile(displayName: String?, photoURL: URL?) async {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        error = nil
        
        do {
            let changeRequest = user.createProfileChangeRequest()
            
            if let displayName = displayName {
                changeRequest.displayName = displayName
            }
            
            if let photoURL = photoURL {
                changeRequest.photoURL = photoURL
            }
            
            try await changeRequest.commitChanges()
            currentUser = user
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        error = nil
        
        do {
            try await user.delete()
            currentUser = nil
            isAuthenticated = false
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
}
