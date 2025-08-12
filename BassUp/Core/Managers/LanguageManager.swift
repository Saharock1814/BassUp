//
//  LanguageManager.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import Combine

@MainActor
class LanguageManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentLanguage: Language = .english
    @Published var availableLanguages: [Language] = Language.allCases
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private let languageKey = "selected_language"
    
    // MARK: - Initialization
    
    init() {
        loadSavedLanguage()
    }
    
    // MARK: - Public Methods
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        saveLanguage()
        updateAppLanguage()
    }
    
    func getCurrentLanguageCode() -> String {
        return currentLanguage.languageCode
    }
    
    func getCurrentLanguageName() -> String {
        return currentLanguage.displayName
    }
    
    func getLocalizedString(for key: String) -> String {
        let languageCode = getCurrentLanguageCode()
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        
        if let path = path,
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }
        
        // Fallback to base localization
        return NSLocalizedString(key, comment: "")
    }
    
    // MARK: - Private Methods
    
    private func loadSavedLanguage() {
        if let savedLanguageCode = userDefaults.string(forKey: languageKey),
           let language = Language.allCases.first(where: { $0.languageCode == savedLanguageCode }) {
            currentLanguage = language
        } else {
            // Default to system language or English
            currentLanguage = getSystemLanguage()
        }
    }
    
    private func saveLanguage() {
        userDefaults.set(currentLanguage.languageCode, forKey: languageKey)
    }
    
    private func updateAppLanguage() {
        // Update the app's language setting
        UserDefaults.standard.set([currentLanguage.languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Post notification for language change
        NotificationCenter.default.post(name: .languageDidChange, object: currentLanguage)
    }
    
    private func getSystemLanguage() -> Language {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        
        if preferredLanguage.hasPrefix("ru") {
            return .russian
        } else {
            return .english
        }
    }
}

// MARK: - Language Enum

enum Language: String, CaseIterable {
    case english = "en"
    case russian = "ru"
    
    var languageCode: String {
        return rawValue
    }
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский"
        }
    }
    
    var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇺🇸"
        case .russian:
            return "🇷🇺"
        }
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let languageDidChange = Notification.Name("languageDidChange")
}
