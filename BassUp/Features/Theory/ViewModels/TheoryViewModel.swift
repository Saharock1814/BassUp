//
//  TheoryViewModel.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class TheoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var allTheory: [MusicTheory] = []
    @Published var filteredTheory: [MusicTheory] = []
    @Published var featuredTheory: MusicTheory?
    @Published var completedTopics = 0
    @Published var completionProgress: Double = 0.0
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        loadSampleTheory()
    }
    
    // MARK: - Public Methods
    
    func loadTheory() async {
        isLoading = true
        error = nil
        
        do {
            // In a real app, this would fetch from Firestore
            // For now, we'll use sample data
            allTheory = createSampleTheory()
            filteredTheory = allTheory
            featuredTheory = getFeaturedTheory()
            updateProgress()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func filterTheory(by category: MusicTheory.TheoryCategory?) {
        if let category = category {
            filteredTheory = allTheory.filter { $0.category == category }
        } else {
            filteredTheory = allTheory
        }
    }
    
    func searchTheory(query: String) {
        if query.isEmpty {
            filteredTheory = allTheory
        } else {
            filteredTheory = allTheory.filter { theory in
                theory.title.localizedCaseInsensitiveContains(query) ||
                theory.content.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func markTheoryAsCompleted(_ theoryId: String) {
        // In a real app, this would update the user's progress
        // For now, we'll just update the local state
        updateProgress()
    }
    
    // MARK: - Private Methods
    
    private func loadSampleTheory() {
        allTheory = createSampleTheory()
        filteredTheory = allTheory
        featuredTheory = getFeaturedTheory()
        updateProgress()
    }
    
    private func getFeaturedTheory() -> MusicTheory? {
        // Return a featured theory topic
        return allTheory.first
    }
    
    private func updateProgress() {
        // Calculate completion progress
        // In a real app, this would be based on user progress
        completedTopics = 2 // Placeholder
        completionProgress = Double(completedTopics) / Double(allTheory.count)
    }
    
    private func createSampleTheory() -> [MusicTheory] {
        return [
            MusicTheory(
                id: "notation_1",
                title: "Reading Bass Tablature",
                category: .notation,
                content: "Tablature (tab) is a form of musical notation that shows you where to place your fingers on the fretboard. It's especially useful for bass guitar as it shows the string and fret numbers clearly.",
                examples: [
                    TheoryExample(
                        title: "Basic Tab Example",
                        description: "A simple tab showing the E string open, then frets 2, 4, and 5.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/tab_example.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["tab_reading_1", "tab_reading_2"]
            ),
            
            MusicTheory(
                id: "rhythm_1",
                title: "Time Signatures and Beats",
                category: .rhythm,
                content: "Time signatures tell you how many beats are in each measure and what type of note gets one beat. The most common time signature is 4/4, which means 4 beats per measure with quarter notes getting one beat.",
                examples: [
                    TheoryExample(
                        title: "4/4 Time Signature",
                        description: "Practice playing in 4/4 time with a metronome.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/44_time.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["rhythm_1", "rhythm_2"]
            ),
            
            MusicTheory(
                id: "harmony_1",
                title: "Chord Construction",
                category: .harmony,
                content: "Chords are built by stacking notes in thirds. A major chord consists of a root note, major third, and perfect fifth. A minor chord has a root, minor third, and perfect fifth.",
                examples: [
                    TheoryExample(
                        title: "C Major Chord",
                        description: "The C major chord consists of C, E, and G notes.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/c_major.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["chord_construction_1", "chord_construction_2"]
            ),
            
            MusicTheory(
                id: "melody_1",
                title: "Scale Patterns",
                category: .melody,
                content: "Scales are sequences of notes that create the foundation for melodies. The major scale follows the pattern: whole, whole, half, whole, whole, whole, half steps.",
                examples: [
                    TheoryExample(
                        title: "C Major Scale",
                        description: "Practice the C major scale in first position.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/c_major_scale.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["scale_patterns_1", "scale_patterns_2"]
            ),
            
            MusicTheory(
                id: "form_1",
                title: "Song Structure",
                category: .form,
                content: "Most songs follow a basic structure with verses, choruses, and bridges. Understanding song form helps you anticipate chord changes and create better bass lines.",
                examples: [
                    TheoryExample(
                        title: "Verse-Chorus Form",
                        description: "A common song structure with verses and choruses.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/song_structure.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["song_form_1", "song_form_2"]
            ),
            
            MusicTheory(
                id: "ear_training_1",
                title: "Interval Recognition",
                category: .earTraining,
                content: "Interval recognition is the ability to identify the distance between two notes. This skill is essential for playing by ear and improvising.",
                examples: [
                    TheoryExample(
                        title: "Major Third Interval",
                        description: "Practice recognizing the major third interval (C to E).",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/major_third.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["interval_training_1", "interval_training_2"]
            ),
            
            MusicTheory(
                id: "notation_2",
                title: "Reading Standard Notation",
                category: .notation,
                content: "Standard notation uses a staff with five lines and four spaces. Each line and space represents a different note. Bass clef is commonly used for bass guitar.",
                examples: [
                    TheoryExample(
                        title: "Bass Clef Notes",
                        description: "Learn the notes on the bass clef staff.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/bass_clef.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["standard_notation_1", "standard_notation_2"]
            ),
            
            MusicTheory(
                id: "rhythm_2",
                title: "Syncopation",
                category: .rhythm,
                content: "Syncopation occurs when you emphasize weak beats or off-beats. It's a key element in funk, jazz, and many other styles of music.",
                examples: [
                    TheoryExample(
                        title: "Syncopated Bass Line",
                        description: "Practice a syncopated bass line with off-beat accents.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/syncopation.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["syncopation_1", "syncopation_2"]
            ),
            
            MusicTheory(
                id: "harmony_2",
                title: "Chord Progressions",
                category: .harmony,
                content: "Chord progressions are sequences of chords that create the harmonic foundation of a song. Common progressions include I-IV-V, ii-V-I, and I-V-vi-IV.",
                examples: [
                    TheoryExample(
                        title: "I-IV-V Progression",
                        description: "Practice the classic I-IV-V progression in C major.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/145_progression.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["chord_progressions_1", "chord_progressions_2"]
            ),
            
            MusicTheory(
                id: "melody_2",
                title: "Pentatonic Scales",
                category: .melody,
                content: "Pentatonic scales contain five notes and are widely used in many musical styles. The major pentatonic scale removes the 4th and 7th degrees from the major scale.",
                examples: [
                    TheoryExample(
                        title: "C Major Pentatonic",
                        description: "Practice the C major pentatonic scale.",
                        tablature: createSampleTablature(),
                        audioURL: "https://example.com/pentatonic.mp3",
                        imageURL: nil
                    )
                ],
                exercises: ["pentatonic_1", "pentatonic_2"]
            )
        ]
    }
    
    private func createSampleTablature() -> Tablature {
        return Tablature(
            title: "Sample Theory Exercise",
            artist: nil,
            tempo: 120,
            timeSignature: Tablature.TimeSignature(beats: 4, beatValue: 4),
            measures: [
                Measure(notes: [
                    Note(string: 4, fret: 0, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 4, fret: 2, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 4, fret: 4, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger]),
                    Note(string: 4, fret: 5, duration: 1.0, velocity: 0.8, isRest: false, techniques: [.finger])
                ], duration: 4.0)
            ],
            tuning: ["E", "A", "D", "G"]
        )
    }
}
