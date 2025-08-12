//
//  ProgressManager.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ProgressManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var userProgress: UserProgress?
    @Published var currentLesson: Lesson?
    @Published var completedLessons: [Lesson] = []
    @Published var achievements: [Achievement] = []
    @Published var practiceSessions: [PracticeSession] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func loadUserProgress() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        error = nil
        
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            if let data = document.data() {
                userProgress = try Firestore.Decoder().decode(UserProgress.self, from: data)
                await loadCompletedLessons()
                await loadAchievements()
                await loadPracticeSessions()
            } else {
                // Create new user progress
                userProgress = UserProgress(
                    userId: userId,
                    completedLessons: [],
                    currentLesson: nil,
                    totalPracticeTime: 0,
                    accuracy: 0.0,
                    streak: 0,
                    achievements: [],
                    level: 1,
                    experience: 0
                )
                await saveUserProgress()
            }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func completeLesson(_ lesson: Lesson) async {
        guard var progress = userProgress else { return }
        
        // Add lesson to completed list
        if !progress.completedLessons.contains(lesson.id) {
            progress.completedLessons.append(lesson.id)
        }
        
        // Update current lesson
        progress.currentLesson = getNextLessonId(after: lesson.id)
        
        // Calculate experience and level
        let experienceGained = calculateExperience(for: lesson)
        progress.experience += experienceGained
        progress.level = calculateLevel(experience: progress.experience)
        
        // Update accuracy
        progress.accuracy = calculateOverallAccuracy()
        
        userProgress = progress
        await saveUserProgress()
        await checkAchievements()
    }
    
    func updateLessonProgress(_ lesson: Lesson, progress: Double) async {
        // Update lesson progress in local storage
        // This would typically be stored in UserDefaults or local database
        // For now, we'll just update the current lesson
        currentLesson = lesson
    }
    
    func startPracticeSession() async -> PracticeSession {
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("User not authenticated")
        }
        
        let session = PracticeSession(
            id: UUID().uuidString,
            userId: userId,
            startTime: Date(),
            endTime: nil,
            duration: 0,
            exercises: [],
            accuracy: 0.0,
            tempo: 120,
            notes: nil
        )
        
        practiceSessions.append(session)
        return session
    }
    
    func endPracticeSession(_ sessionId: String, exercises: [PracticeExercise], accuracy: Double, tempo: Int, notes: String?) async {
        guard let index = practiceSessions.firstIndex(where: { $0.id == sessionId }) else { return }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(practiceSessions[index].startTime)
        
        var updatedSession = practiceSessions[index]
        updatedSession.endTime = endTime
        updatedSession.duration = duration
        updatedSession.exercises = exercises
        updatedSession.accuracy = accuracy
        updatedSession.tempo = tempo
        updatedSession.notes = notes
        
        practiceSessions[index] = updatedSession
        
        // Update user progress
        await updatePracticeStats(session: updatedSession)
    }
    
    func unlockAchievement(_ achievement: Achievement) async {
        guard var progress = userProgress else { return }
        
        if !progress.achievements.contains(where: { $0.id == achievement.id }) {
            progress.achievements.append(achievement)
            userProgress = progress
            await saveUserProgress()
        }
    }
    
    func getRecommendedLesson() -> Lesson? {
        // Logic to determine the next best lesson based on progress
        // This would consider completed lessons, difficulty progression, etc.
        return nil // Placeholder
    }
    
    func getPracticeRecommendations() -> [Lesson] {
        // Return lessons that need more practice based on accuracy and recent practice
        return [] // Placeholder
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        // Listen for authentication changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user != nil {
                Task {
                    await self?.loadUserProgress()
                }
            } else {
                self?.userProgress = nil
                self?.completedLessons = []
                self?.achievements = []
                self?.practiceSessions = []
            }
        }
    }
    
    private func saveUserProgress() async {
        guard let progress = userProgress else { return }
        
        do {
            let data = try Firestore.Encoder().encode(progress)
            try await db.collection("users").document(progress.userId).setData(data)
        } catch {
            self.error = error
        }
    }
    
    private func loadCompletedLessons() async {
        guard let progress = userProgress else { return }
        
        // Load lesson data for completed lessons
        // This would typically fetch from a lessons collection
        completedLessons = [] // Placeholder
    }
    
    private func loadAchievements() async {
        guard let progress = userProgress else { return }
        
        // Load achievement data
        achievements = progress.achievements
    }
    
    private func loadPracticeSessions() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("practice_sessions")
                .whereField("userId", isEqualTo: userId)
                .order(by: "startTime", descending: true)
                .limit(to: 50)
                .getDocuments()
            
            practiceSessions = snapshot.documents.compactMap { document in
                try? Firestore.Decoder().decode(PracticeSession.self, from: document.data())
            }
        } catch {
            self.error = error
        }
    }
    
    private func getNextLessonId(after lessonId: String) -> String? {
        // Logic to determine the next lesson in the curriculum
        // This would be based on prerequisites and difficulty progression
        return nil // Placeholder
    }
    
    private func calculateExperience(for lesson: Lesson) -> Int {
        // Calculate experience points based on lesson difficulty and completion
        switch lesson.difficulty {
        case .beginner: return 10
        case .intermediate: return 25
        case .advanced: return 50
        case .expert: return 100
        }
    }
    
    private func calculateLevel(experience: Int) -> Int {
        // Calculate level based on total experience
        // Simple formula: level = sqrt(experience / 100) + 1
        return Int(sqrt(Double(experience) / 100.0)) + 1
    }
    
    private func calculateOverallAccuracy() -> Double {
        // Calculate overall accuracy from recent practice sessions
        let recentSessions = practiceSessions.prefix(10)
        guard !recentSessions.isEmpty else { return 0.0 }
        
        let totalAccuracy = recentSessions.reduce(0.0) { $0 + $1.accuracy }
        return totalAccuracy / Double(recentSessions.count)
    }
    
    private func updatePracticeStats(session: PracticeSession) async {
        guard var progress = userProgress else { return }
        
        // Update total practice time
        progress.totalPracticeTime += session.duration
        
        // Update streak if this is today's practice
        if Calendar.current.isDateInToday(session.startTime) {
            progress.streak += 1
        }
        
        // Update accuracy
        progress.accuracy = calculateOverallAccuracy()
        
        userProgress = progress
        await saveUserProgress()
    }
    
    private func checkAchievements() async {
        guard let progress = userProgress else { return }
        
        // Check for various achievement conditions
        let newAchievements = await checkAchievementConditions(progress: progress)
        
        for achievement in newAchievements {
            await unlockAchievement(achievement)
        }
    }
    
    private func checkAchievementConditions(progress: UserProgress) async -> [Achievement] {
        var newAchievements: [Achievement] = []
        
        // Check for completion achievements
        if progress.completedLessons.count >= 10 {
            let achievement = Achievement(
                id: "first_10_lessons",
                title: "Getting Started",
                description: "Complete your first 10 lessons",
                icon: "star.fill",
                isUnlocked: true,
                unlockedDate: Date(),
                progress: 1.0
            )
            newAchievements.append(achievement)
        }
        
        // Check for practice time achievements
        if progress.totalPracticeTime >= 3600 { // 1 hour
            let achievement = Achievement(
                id: "first_hour",
                title: "First Hour",
                description: "Practice for your first hour",
                icon: "clock.fill",
                isUnlocked: true,
                unlockedDate: Date(),
                progress: 1.0
            )
            newAchievements.append(achievement)
        }
        
        // Check for streak achievements
        if progress.streak >= 7 {
            let achievement = Achievement(
                id: "week_streak",
                title: "Week Warrior",
                description: "Practice for 7 days in a row",
                icon: "flame.fill",
                isUnlocked: true,
                unlockedDate: Date(),
                progress: 1.0
            )
            newAchievements.append(achievement)
        }
        
        return newAchievements
    }
}
