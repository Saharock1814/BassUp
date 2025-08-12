//
//  LearningModels.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Lesson Models

struct Lesson: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: LessonCategory
    let difficulty: Difficulty
    let duration: TimeInterval
    let content: [LessonContent]
    let prerequisites: [String] // Lesson IDs
    let objectives: [String]
    let isCompleted: Bool
    let progress: Double // 0.0 to 1.0
    
    enum LessonCategory: String, CaseIterable, Codable {
        case basics = "Basics"
        case technique = "Technique"
        case theory = "Theory"
        case scales = "Scales"
        case chords = "Chords"
        case rhythm = "Rhythm"
        case songs = "Songs"
        case advanced = "Advanced"
        
        var icon: String {
            switch self {
            case .basics: return "1.circle.fill"
            case .technique: return "hand.tap.fill"
            case .theory: return "brain.head.profile"
            case .scales: return "music.note.list"
            case .chords: return "music.note"
            case .rhythm: return "timer"
            case .songs: return "music.mic"
            case .advanced: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .basics: return .blue
            case .technique: return .green
            case .theory: return .purple
            case .scales: return .orange
            case .chords: return .red
            case .rhythm: return .yellow
            case .songs: return .pink
            case .advanced: return .indigo
            }
        }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .blue
        case .advanced: return .orange
        case .expert: return .red
        }
    }
}

// MARK: - Lesson Content

enum LessonContent: Codable {
    case text(TextContent)
    case video(VideoContent)
    case audio(AudioContent)
    case exercise(ExerciseContent)
    case quiz(QuizContent)
    case tablature(TablatureContent)
}

struct TextContent: Codable {
    let title: String
    let content: String
    let images: [String] // Image URLs
}

struct VideoContent: Codable {
    let title: String
    let videoURL: String
    let duration: TimeInterval
    let description: String
    let thumbnailURL: String?
}

struct AudioContent: Codable {
    let title: String
    let audioURL: String
    let duration: TimeInterval
    let description: String
    let waveform: [Float]? // Audio waveform data
}

struct ExerciseContent: Codable {
    let title: String
    let description: String
    let tablature: Tablature
    let tempo: Int // BPM
    let metronomeEnabled: Bool
    let recordingEnabled: Bool
    let targetAccuracy: Double // 0.0 to 1.0
}

struct QuizContent: Codable {
    let title: String
    let questions: [QuizQuestion]
    let passingScore: Double // 0.0 to 1.0
}

struct TablatureContent: Codable {
    let title: String
    let tablature: Tablature
    let description: String
    let playAlongEnabled: Bool
}

// MARK: - Tablature Models

struct Tablature: Codable {
    let title: String
    let artist: String?
    let tempo: Int
    let timeSignature: TimeSignature
    let measures: [Measure]
    let tuning: [String] // E.g., ["E", "A", "D", "G"]
    
    struct TimeSignature: Codable {
        let beats: Int
        let beatValue: Int
    }
}

struct Measure: Codable {
    let notes: [Note]
    let duration: Double // In beats
}

struct Note: Codable {
    let string: Int // 1-4 for bass
    let fret: Int
    let duration: Double // In beats
    let velocity: Double // 0.0 to 1.0
    let isRest: Bool
    let techniques: [PlayingTechnique]
    
    enum PlayingTechnique: String, CaseIterable, Codable {
        case finger = "Finger"
        case pick = "Pick"
        case slap = "Slap"
        case pop = "Pop"
        case hammerOn = "Hammer-on"
        case pullOff = "Pull-off"
        case slide = "Slide"
        case bend = "Bend"
        case vibrato = "Vibrato"
    }
}

// MARK: - Quiz Models

struct QuizQuestion: Codable {
    let id: String
    let question: String
    let type: QuestionType
    let options: [String]?
    let correctAnswer: String
    let explanation: String
    
    enum QuestionType: String, Codable {
        case multipleChoice = "multiple_choice"
        case trueFalse = "true_false"
        case fillInBlank = "fill_in_blank"
        case matching = "matching"
    }
}

// MARK: - Scale Models

struct Scale: Identifiable, Codable {
    let id: String
    let name: String
    let root: String
    let type: ScaleType
    let notes: [String]
    let tablature: Tablature
    let description: String
    let commonUses: [String]
    
    enum ScaleType: String, CaseIterable, Codable {
        case major = "Major"
        case minor = "Minor"
        case pentatonic = "Pentatonic"
        case blues = "Blues"
        case dorian = "Dorian"
        case mixolydian = "Mixolydian"
        case lydian = "Lydian"
        case phrygian = "Phrygian"
        case locrian = "Locrian"
        case harmonicMinor = "Harmonic Minor"
        case melodicMinor = "Melodic Minor"
    }
}

// MARK: - Chord Models

struct Chord: Identifiable, Codable {
    let id: String
    let name: String
    let root: String
    let type: ChordType
    let notes: [String]
    let tablature: Tablature
    let description: String
    let commonProgressions: [String]
    
    enum ChordType: String, CaseIterable, Codable {
        case major = "Major"
        case minor = "Minor"
        case dominant = "Dominant"
        case diminished = "Diminished"
        case augmented = "Augmented"
        case major7 = "Major 7"
        case minor7 = "Minor 7"
        case dominant7 = "Dominant 7"
        case diminished7 = "Diminished 7"
        case halfDiminished = "Half Diminished"
    }
}

// MARK: - Progress Models

struct UserProgress: Codable {
    let userId: String
    let completedLessons: [String] // Lesson IDs
    let currentLesson: String?
    let totalPracticeTime: TimeInterval
    let accuracy: Double // Overall accuracy
    let streak: Int // Days in a row
    let achievements: [Achievement]
    let level: Int
    let experience: Int
}

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let unlockedDate: Date?
    let progress: Double // 0.0 to 1.0
}

// MARK: - Practice Session Models

struct PracticeSession: Codable {
    let id: String
    let userId: String
    let startTime: Date
    let endTime: Date?
    let duration: TimeInterval
    let exercises: [PracticeExercise]
    let accuracy: Double
    let tempo: Int
    let notes: String?
}

struct PracticeExercise: Codable {
    let exerciseId: String
    let duration: TimeInterval
    let accuracy: Double
    let tempo: Int
    let mistakes: [Mistake]
}

struct Mistake: Codable {
    let timestamp: Date
    let type: MistakeType
    let description: String
    let severity: MistakeSeverity
    
    enum MistakeType: String, Codable {
        case wrongNote = "Wrong Note"
        case wrongTiming = "Wrong Timing"
        case wrongTechnique = "Wrong Technique"
        case missedNote = "Missed Note"
        case extraNote = "Extra Note"
    }
    
    enum MistakeSeverity: String, Codable {
        case minor = "Minor"
        case moderate = "Moderate"
        case major = "Major"
    }
}

// MARK: - Music Theory Models

struct MusicTheory: Identifiable, Codable {
    let id: String
    let title: String
    let category: TheoryCategory
    let content: String
    let examples: [TheoryExample]
    let exercises: [String] // Exercise IDs
    
    enum TheoryCategory: String, CaseIterable, Codable {
        case notation = "Notation"
        case rhythm = "Rhythm"
        case harmony = "Harmony"
        case melody = "Melody"
        case form = "Form"
        case earTraining = "Ear Training"
    }
}

struct TheoryExample: Codable {
    let title: String
    let description: String
    let tablature: Tablature?
    let audioURL: String?
    let imageURL: String?
}
