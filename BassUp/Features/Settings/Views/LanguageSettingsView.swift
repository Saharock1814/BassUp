//
//  LanguageSettingsView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI

struct LanguageSettingsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLanguage: Language
    
    // MARK: - Initialization
    
    init() {
        // Initialize with current language
        _selectedLanguage = State(initialValue: LanguageManager().currentLanguage)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Language List
                languageListSection
                
                Spacer()
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String.actionCancel.localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String.actionDone.localized) {
                        if selectedLanguage != languageManager.currentLanguage {
                            languageManager.setLanguage(selectedLanguage)
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .font(.system(size: 60))
                .foregroundColor(Color("PrimaryColor"))
            
            VStack(spacing: 8) {
                Text("Select Language")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Choose your preferred language for the app")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal)
    }
    
    private var languageListSection: some View {
        VStack(spacing: 0) {
            ForEach(Language.allCases, id: \.self) { language in
                LanguageRowView(
                    language: language,
                    isSelected: selectedLanguage == language
                ) {
                    selectedLanguage = language
                }
                
                if language != Language.allCases.last {
                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

// MARK: - Supporting Views

struct LanguageRowView: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Flag
                Text(language.flag)
                    .font(.title2)
                
                // Language Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.displayName)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(language.nativeName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("PrimaryColor"))
                } else {
                    Image(systemName: "circle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct LanguageSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSettingsView()
            .environmentObject(LanguageManager())
    }
}
