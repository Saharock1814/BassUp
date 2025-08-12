//
//  PracticeViewModel.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class PracticeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var allExercises: [ExerciseContent] = []
    @Published var recommendedExercises: [ExerciseContent] = []
    @Published var currentSession: PracticeSession?
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        loadSampleExercises()
    }
    
    // MARK: - Public Methods
    
    func loadExercises() async {
        isLoading = true
        error = nil
        
        do {
            // In a real app, this would fetch from Firestore
            // For now, we'll use sample data
            allExercises = createSampleExercises()
            recommendedExercises = getRecommendedExercises()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func startPracticeSession() async {
        // This would typically be handled by ProgressManager
        // For now, we'll create a mock session
        currentSession = PracticeSession(
            id: UUID().uuidString,
            userId: "mock_user",
            startTime: Date(),
            endTime: nil,
            duration: 0,
            exercises: [],
            accuracy: 0.0,
            tempo: 120,
            notes: nil
        )
    }
    
    func endCurrentSession() async {
        guard let session = currentSession else { return }
        
        // This would typically be handled by ProgressManager
        // For now, we'll just clear the current session
        currentSession = nil
    }
    
    func filterExercises(by difficulty: Difficulty?) {
        if let difficulty = difficulty {
            recommendedExercises = allExercises.filter { exercise in
                // Filter based on exercise difficulty
                return true // Placeholder
            }
        } else {
            recommendedExercises = getRecommendedExercises()
        }
    }
    
    func searchExercises(query: String) {
        if query.isEmpty {
            recommendedExercises = getRecommendedExercises()
        } else {
            recommendedExercises = allExercises.filter { exercise in
                exercise.title.localizedCaseInsensitiveContains(query) ||
                exercise.description.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadSampleExercises() {
        allExercises = createSampleExercises()
        recommendedExercises = getRecommendedExercises()
    }
    
    private func getRecommendedExercises() -> [ExerciseContent] {
        // Return exercises that need practice or are suitable for the user's level
        return Array(allExercises.prefix(5))
    }
    
    private func createSampleExercises() -> [ExerciseContent] {
        return [
            ExerciseContent(
                title: "Basic Finger Exercise",
                description: "Practice basic fingerstyle technique with simple patterns.",
                tablature: createSampleTablature(title: "Basic Finger Exercise"),
                tempo: 80,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.8
            ),
            
            ExerciseContent(
                title: "Slap and Pop Basics",
                description: "Learn the fundamental slap and pop technique.",
                tablature: createSampleTablature(title: "Slap and Pop"),
                tempo: 90,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.7
            ),
            
            ExerciseContent(
                title: "Major Scale Practice",
                description: "Practice major scales in different positions.",
                tablature: createSampleTablature(title: "Major Scale"),
                tempo: 100,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.8
            ),
            
            ExerciseContent(
                title: "Rhythm Exercise",
                description: "Improve your timing and rhythm with this exercise.",
                tablature: createSampleTablature(title: "Rhythm Exercise"),
                tempo: 120,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.9
            ),
            
            ExerciseContent(
                title: "Walking Bass Line",
                description: "Practice a classic walking bass line pattern.",
                tablature: createSampleTablature(title: "Walking Bass"),
                tempo: 110,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.8
            ),
            
            ExerciseContent(
                title: "Hammer-on and Pull-off",
                description: "Master the hammer-on and pull-off techniques.",
                tablature: createSampleTablature(title: "Hammer-on/Pull-off"),
                tempo: 85,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.7
            ),
            
            ExerciseContent(
                title: "Minor Scale Practice",
                description: "Practice minor scales in different keys.",
                tablature: createSampleTablature(title: "Minor Scale"),
                tempo: 95,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.8
            ),
            
            ExerciseContent(
                title: "Funk Groove",
                description: "Learn a classic funk bass groove.",
                tablature: createSampleTablature(title: "Funk Groove"),
                tempo: 105,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.8
            ),
            
            ExerciseContent(
                title: "Arpeggio Practice",
                description: "Practice chord arpeggios for better finger dexterity.",
                tablature: createSampleTablature(title: "Arpeggios"),
                tempo: 90,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.8
            ),
            
            ExerciseContent(
                title: "Speed Building",
                description: "Build speed and accuracy with this exercise.",
                tablature: createSampleTablature(title: "Speed Building"),
                tempo: 130,
                metronomeEnabled: true,
                recordingEnabled: true,
                targetAccuracy: 0.7
            )
        ]
    }
    
    private func createSampleTablature(title: String) -> Tablature {
        return Tablature(
            title: title,
            artist: nil,
            tempo: 120,
            timeSignature: Tablature.TimeSignature(beats: 4, beatValue: 4),
            measures: [
                Measure(notes: [
                    Note(string: 4, fret: 0, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 4, fret: 2, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 4, fret: 4, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 4, fret: 5, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger])
                ], duration: 4.0),
                Measure(notes: [
                    Note(string: 3, fret: 0, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 3, fret: 2, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 3, fret: 4, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 3, fret: 5, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger])
                ], duration: 4.0)
            ],
            tuning: ["E", "A", "D", "G"]
        )
    }
}
