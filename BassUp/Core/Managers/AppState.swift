//
//  AppState.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isFirstLaunch = true
    @Published var currentTheme: AppTheme = .system
    @Published var soundEnabled = true
    @Published var hapticEnabled = true
    @Published var autoPlayEnabled = false
    @Published var metronomeEnabled = true
    @Published var recordingEnabled = true
    @Published var notificationsEnabled = true
    @Published var practiceReminders = true
    @Published var dailyGoal: TimeInterval = 1800 // 30 minutes
    @Published var weeklyGoal: TimeInterval = 12600 // 3.5 hours
    @Published var selectedTuning: BassTuning = .standard
    @Published var selectedDifficulty: Difficulty = .beginner
    @Published var showTablature = true
    @Published var showNotes = true
    @Published var showFingerings = true
    @Published var tempoRange: ClosedRange<Int> = 60...200
    @Published var defaultTempo = 120
    @Published var volumeLevel: Double = 0.8
    @Published var isPremium = false
    @Published var lastActiveDate: Date = Date()
    @Published var appVersion = "1.0.0"
    @Published var buildNumber = "1"
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        loadSettings()
        setupObservers()
        checkFirstLaunch()
    }
    
    // MARK: - Public Methods
    
    func saveSettings() {
        userDefaults.set(currentTheme.rawValue, forKey: "appTheme")
        userDefaults.set(soundEnabled, forKey: "soundEnabled")
        userDefaults.set(hapticEnabled, forKey: "hapticEnabled")
        userDefaults.set(autoPlayEnabled, forKey: "autoPlayEnabled")
        userDefaults.set(metronomeEnabled, forKey: "metronomeEnabled")
        userDefaults.set(recordingEnabled, forKey: "recordingEnabled")
        userDefaults.set(notificationsEnabled, forKey: "notificationsEnabled")
        userDefaults.set(practiceReminders, forKey: "practiceReminders")
        userDefaults.set(dailyGoal, forKey: "dailyGoal")
        userDefaults.set(weeklyGoal, forKey: "weeklyGoal")
        userDefaults.set(selectedTuning.rawValue, forKey: "selectedTuning")
        userDefaults.set(selectedDifficulty.rawValue, forKey: "selectedDifficulty")
        userDefaults.set(showTablature, forKey: "showTablature")
        userDefaults.set(showNotes, forKey: "showNotes")
        userDefaults.set(showFingerings, forKey: "showFingerings")
        userDefaults.set(defaultTempo, forKey: "defaultTempo")
        userDefaults.set(volumeLevel, forKey: "volumeLevel")
        userDefaults.set(isPremium, forKey: "isPremium")
        userDefaults.set(lastActiveDate, forKey: "lastActiveDate")
    }
    
    func resetToDefaults() {
        currentTheme = .system
        soundEnabled = true
        hapticEnabled = true
        autoPlayEnabled = false
        metronomeEnabled = true
        recordingEnabled = true
        notificationsEnabled = true
        practiceReminders = true
        dailyGoal = 1800
        weeklyGoal = 12600
        selectedTuning = .standard
        selectedDifficulty = .beginner
        showTablature = true
        showNotes = true
        showFingerings = true
        defaultTempo = 120
        volumeLevel = 0.8
        
        saveSettings()
    }
    
    func updateLastActiveDate() {
        lastActiveDate = Date()
        saveSettings()
    }
    
    func checkDailyGoal(_ practiceTime: TimeInterval) -> Bool {
        return practiceTime >= dailyGoal
    }
    
    func checkWeeklyGoal(_ practiceTime: TimeInterval) -> Bool {
        return practiceTime >= weeklyGoal
    }
    
    func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard hapticEnabled else { return }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func triggerNotificationHaptic() {
        guard hapticEnabled else { return }
        
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    // MARK: - Private Methods
    
    private func loadSettings() {
        if let themeRawValue = userDefaults.string(forKey: "appTheme"),
           let theme = AppTheme(rawValue: themeRawValue) {
            currentTheme = theme
        }
        
        soundEnabled = userDefaults.bool(forKey: "soundEnabled")
        hapticEnabled = userDefaults.bool(forKey: "hapticEnabled")
        autoPlayEnabled = userDefaults.bool(forKey: "autoPlayEnabled")
        metronomeEnabled = userDefaults.bool(forKey: "metronomeEnabled")
        recordingEnabled = userDefaults.bool(forKey: "recordingEnabled")
        notificationsEnabled = userDefaults.bool(forKey: "notificationsEnabled")
        practiceReminders = userDefaults.bool(forKey: "practiceReminders")
        dailyGoal = userDefaults.double(forKey: "dailyGoal")
        weeklyGoal = userDefaults.double(forKey: "weeklyGoal")
        
        if let tuningRawValue = userDefaults.string(forKey: "selectedTuning"),
           let tuning = BassTuning(rawValue: tuningRawValue) {
            selectedTuning = tuning
        }
        
        if let difficultyRawValue = userDefaults.string(forKey: "selectedDifficulty"),
           let difficulty = Difficulty(rawValue: difficultyRawValue) {
            selectedDifficulty = difficulty
        }
        
        showTablature = userDefaults.bool(forKey: "showTablature")
        showNotes = userDefaults.bool(forKey: "showNotes")
        showFingerings = userDefaults.bool(forKey: "showFingerings")
        defaultTempo = userDefaults.integer(forKey: "defaultTempo")
        volumeLevel = userDefaults.double(forKey: "volumeLevel")
        isPremium = userDefaults.bool(forKey: "isPremium")
        
        if let lastActive = userDefaults.object(forKey: "lastActiveDate") as? Date {
            lastActiveDate = lastActive
        }
        
        // Set default values if not previously set
        if dailyGoal == 0 { dailyGoal = 1800 }
        if weeklyGoal == 0 { weeklyGoal = 12600 }
        if defaultTempo == 0 { defaultTempo = 120 }
        if volumeLevel == 0 { volumeLevel = 0.8 }
    }
    
    private func setupObservers() {
        // Observe changes and save automatically
        $currentTheme
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $soundEnabled
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $hapticEnabled
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $autoPlayEnabled
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $metronomeEnabled
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $recordingEnabled
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $notificationsEnabled
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $practiceReminders
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $dailyGoal
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $weeklyGoal
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $selectedTuning
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $selectedDifficulty
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $showTablature
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $showNotes
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $showFingerings
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $defaultTempo
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $volumeLevel
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
        
        $isPremium
            .dropFirst()
            .sink { [weak self] _ in self?.saveSettings() }
            .store(in: &cancellables)
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = userDefaults.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            isFirstLaunch = true
            userDefaults.set(true, forKey: "hasLaunchedBefore")
        } else {
            isFirstLaunch = false
        }
    }
}

// MARK: - Supporting Types

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

enum BassTuning: String, CaseIterable {
    case standard = "EADG"
    case dropD = "DADG"
    case halfStepDown = "EbAbDbGb"
    case fullStepDown = "DGCF"
    case openG = "GDGD"
    case openD = "DADF#"
    
    var displayName: String {
        switch self {
        case .standard: return "Standard (E-A-D-G)"
        case .dropD: return "Drop D (D-A-D-G)"
        case .halfStepDown: return "Half Step Down (Eb-Ab-Db-Gb)"
        case .fullStepDown: return "Full Step Down (D-G-C-F)"
        case .openG: return "Open G (G-D-G-D)"
        case .openD: return "Open D (D-A-D-F#)"
        }
    }
    
    var strings: [String] {
        switch self {
        case .standard: return ["E", "A", "D", "G"]
        case .dropD: return ["D", "A", "D", "G"]
        case .halfStepDown: return ["Eb", "Ab", "Db", "Gb"]
        case .fullStepDown: return ["D", "G", "C", "F"]
        case .openG: return ["G", "D", "G", "D"]
        case .openD: return ["D", "A", "D", "F#"]
        }
    }
}
