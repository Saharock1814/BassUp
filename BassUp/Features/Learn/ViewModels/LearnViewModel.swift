//
//  LearnViewModel.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class LearnViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var lessons: [Lesson] = []
    @Published var recommendedLesson: Lesson?
    @Published var filteredLessons: [Lesson] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        loadSampleLessons()
    }
    
    // MARK: - Public Methods
    
    func loadLessons() async {
        isLoading = true
        error = nil
        
        do {
            // In a real app, this would fetch from Firestore
            // For now, we'll use sample data
            lessons = createSampleLessons()
            filteredLessons = lessons
            recommendedLesson = getRecommendedLesson()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func filterLessons(by category: Lesson.LessonCategory?) {
        if let category = category {
            filteredLessons = lessons.filter { $0.category == category }
        } else {
            filteredLessons = lessons
        }
    }
    
    func filterLessons(by difficulty: Difficulty?) {
        if let difficulty = difficulty {
            filteredLessons = lessons.filter { $0.difficulty == difficulty }
        } else {
            filteredLessons = lessons
        }
    }
    
    func searchLessons(query: String) {
        if query.isEmpty {
            filteredLessons = lessons
        } else {
            filteredLessons = lessons.filter { lesson in
                lesson.title.localizedCaseInsensitiveContains(query) ||
                lesson.description.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func getRecommendedLesson() -> Lesson? {
        // Simple recommendation logic - return first incomplete lesson
        return lessons.first { !$0.isCompleted }
    }
    
    private func loadSampleLessons() {
        lessons = createSampleLessons()
        filteredLessons = lessons
        recommendedLesson = getRecommendedLesson()
    }
    
    private func createSampleLessons() -> [Lesson] {
        return [
            // Basics
            Lesson(
                id: "basics_1",
                title: "Introduction to Bass Guitar",
                description: "Learn the fundamentals of bass guitar playing, including proper posture, hand positioning, and basic techniques.",
                category: .basics,
                difficulty: .beginner,
                duration: 900, // 15 minutes
                content: [
                    .text(TextContent(
                        title: "Welcome to Bass Guitar",
                        content: "The bass guitar is the foundation of any band's rhythm section. In this lesson, you'll learn the basics of bass guitar playing.",
                        images: []
                    )),
                    .video(VideoContent(
                        title: "Proper Posture and Hand Position",
                        videoURL: "https://example.com/posture.mp4",
                        duration: 300,
                        description: "Learn the correct way to hold your bass and position your hands.",
                        thumbnailURL: nil
                    ))
                ],
                prerequisites: [],
                objectives: [
                    "Understand the role of bass guitar in music",
                    "Learn proper posture and hand positioning",
                    "Identify the parts of the bass guitar"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            Lesson(
                id: "basics_2",
                title: "Basic Finger Techniques",
                description: "Master the essential finger techniques for bass guitar including fingerstyle and pick playing.",
                category: .basics,
                difficulty: .beginner,
                duration: 1200, // 20 minutes
                content: [
                    .text(TextContent(
                        title: "Fingerstyle vs Pick",
                        content: "There are two main ways to play bass guitar: with your fingers or with a pick. Both have their advantages.",
                        images: []
                    )),
                    .exercise(ExerciseContent(
                        title: "Fingerstyle Exercise",
                        description: "Practice basic fingerstyle technique with simple exercises.",
                        tablature: createSampleTablature(),
                        tempo: 80,
                        metronomeEnabled: true,
                        recordingEnabled: true,
                        targetAccuracy: 0.8
                    ))
                ],
                prerequisites: ["basics_1"],
                objectives: [
                    "Learn proper fingerstyle technique",
                    "Practice basic finger exercises",
                    "Understand when to use fingerstyle vs pick"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            // Technique
            Lesson(
                id: "technique_1",
                title: "Slap and Pop Technique",
                description: "Learn the iconic slap and pop technique that defines funk and modern bass playing.",
                category: .technique,
                difficulty: .intermediate,
                duration: 1800, // 30 minutes
                content: [
                    .text(TextContent(
                        title: "Slap and Pop Basics",
                        content: "Slap and pop is a percussive technique that creates a distinctive sound used in funk, rock, and modern music.",
                        images: []
                    )),
                    .video(VideoContent(
                        title: "Slap Technique Demonstration",
                        videoURL: "https://example.com/slap.mp4",
                        duration: 600,
                        description: "Step-by-step guide to proper slap technique.",
                        thumbnailURL: nil
                    )),
                    .exercise(ExerciseContent(
                        title: "Basic Slap Exercise",
                        description: "Practice the basic slap technique with simple patterns.",
                        tablature: createSampleTablature(),
                        tempo: 90,
                        metronomeEnabled: true,
                        recordingEnabled: true,
                        targetAccuracy: 0.7
                    ))
                ],
                prerequisites: ["basics_2"],
                objectives: [
                    "Master the slap technique",
                    "Learn proper thumb positioning",
                    "Practice basic slap patterns"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            // Theory
            Lesson(
                id: "theory_1",
                title: "Music Theory Fundamentals",
                description: "Understand the basics of music theory including notes, scales, and chord construction.",
                category: .theory,
                difficulty: .beginner,
                duration: 1500, // 25 minutes
                content: [
                    .text(TextContent(
                        title: "Notes and the Musical Alphabet",
                        content: "Music is built on 12 notes that repeat in octaves. Understanding these notes is fundamental to bass playing.",
                        images: []
                    )),
                    .quiz(QuizContent(
                        title: "Note Recognition Quiz",
                        questions: [
                            QuizQuestion(
                                id: "q1",
                                question: "What note comes after A in the musical alphabet?",
                                type: .multipleChoice,
                                options: ["B", "C", "D", "E"],
                                correctAnswer: "B",
                                explanation: "The musical alphabet goes: A, B, C, D, E, F, G, then repeats."
                            )
                        ],
                        passingScore: 0.8
                    ))
                ],
                prerequisites: ["basics_1"],
                objectives: [
                    "Learn the 12 notes of music",
                    "Understand octaves and note relationships",
                    "Recognize notes on the bass fretboard"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            // Scales
            Lesson(
                id: "scales_1",
                title: "Major Scale Patterns",
                description: "Learn the major scale patterns and how to apply them to bass playing.",
                category: .scales,
                difficulty: .intermediate,
                duration: 2000, // 33 minutes
                content: [
                    .text(TextContent(
                        title: "The Major Scale",
                        content: "The major scale is the foundation of Western music. It consists of 7 notes with specific intervals between them.",
                        images: []
                    )),
                    .tablature(TablatureContent(
                        title: "C Major Scale",
                        tablature: createSampleTablature(),
                        description: "Practice the C major scale in first position.",
                        playAlongEnabled: true
                    )),
                    .exercise(ExerciseContent(
                        title: "Major Scale Exercise",
                        description: "Practice major scales in different keys and positions.",
                        tablature: createSampleTablature(),
                        tempo: 100,
                        metronomeEnabled: true,
                        recordingEnabled: true,
                        targetAccuracy: 0.8
                    ))
                ],
                prerequisites: ["theory_1"],
                objectives: [
                    "Learn major scale patterns",
                    "Practice scales in different keys",
                    "Apply scales to bass lines"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            // Chords
            Lesson(
                id: "chords_1",
                title: "Basic Chord Construction",
                description: "Understand how chords are built and how to play them on bass guitar.",
                category: .chords,
                difficulty: .intermediate,
                duration: 1600, // 27 minutes
                content: [
                    .text(TextContent(
                        title: "What are Chords?",
                        content: "Chords are groups of notes played together. On bass, we typically play the root note of chords.",
                        images: []
                    )),
                    .audio(AudioContent(
                        title: "Chord Progressions",
                        audioURL: "https://example.com/chords.mp3",
                        duration: 180,
                        description: "Listen to common chord progressions and how bass fits in.",
                        waveform: nil
                    ))
                ],
                prerequisites: ["theory_1"],
                objectives: [
                    "Understand chord construction",
                    "Learn common chord progressions",
                    "Practice playing chord roots"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            // Rhythm
            Lesson(
                id: "rhythm_1",
                title: "Rhythm and Timing",
                description: "Master rhythm and timing, the foundation of great bass playing.",
                category: .rhythm,
                difficulty: .beginner,
                duration: 1400, // 23 minutes
                content: [
                    .text(TextContent(
                        title: "The Importance of Rhythm",
                        content: "Bass guitar is primarily a rhythm instrument. Good timing is essential for any bass player.",
                        images: []
                    )),
                    .exercise(ExerciseContent(
                        title: "Timing Exercise",
                        description: "Practice playing with a metronome to improve your timing.",
                        tablature: createSampleTablature(),
                        tempo: 80,
                        metronomeEnabled: true,
                        recordingEnabled: true,
                        targetAccuracy: 0.9
                    ))
                ],
                prerequisites: ["basics_1"],
                objectives: [
                    "Develop solid rhythm and timing",
                    "Practice with metronome",
                    "Understand different time signatures"
                ],
                isCompleted: false,
                progress: 0.0
            ),
            
            // Songs
            Lesson(
                id: "songs_1",
                title: "Your First Song",
                description: "Learn to play your first complete song on bass guitar.",
                category: .songs,
                difficulty: .beginner,
                duration: 2400, // 40 minutes
                content: [
                    .text(TextContent(
                        title: "Song Structure",
                        content: "Most songs follow a basic structure with verses, choruses, and bridges.",
                        images: []
                    )),
                    .tablature(TablatureContent(
                        title: "Simple Bass Line",
                        tablature: createSampleTablature(),
                        description: "Learn a simple but effective bass line.",
                        playAlongEnabled: true
                    )),
                    .audio(AudioContent(
                        title: "Backing Track",
                        audioURL: "https://example.com/backing.mp3",
                        duration: 240,
                        description: "Play along with this backing track.",
                        waveform: nil
                    ))
                ],
                prerequisites: ["basics_2", "rhythm_1"],
                objectives: [
                    "Learn a complete song",
                    "Practice with backing track",
                    "Understand song structure"
                ],
                isCompleted: false,
                progress: 0.0
            )
        ]
    }
    
    private func createSampleTablature() -> Tablature {
        return Tablature(
            title: "Sample Exercise",
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
