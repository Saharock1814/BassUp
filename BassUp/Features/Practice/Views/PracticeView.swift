//
//  PracticeView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI
import AVFoundation

struct PracticeView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var viewModel = PracticeViewModel()
    @State private var showingExerciseDetail = false
    @State private var selectedExercise: ExerciseContent?
    @State private var isRecording = false
    @State private var showingMetronome = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header
                headerSection
                
                // Quick Start
                quickStartSection
                
                // Current Session
                if viewModel.currentSession != nil {
                    currentSessionSection
                }
                
                // Practice Tools
                practiceToolsSection
                
                // Recommended Exercises
                if !viewModel.recommendedExercises.isEmpty {
                    recommendedExercisesSection
                }
                
                // All Exercises
                allExercisesSection
                
                // Practice History
                if !progressManager.practiceSessions.isEmpty {
                    practiceHistorySection
                }
            }
            .padding()
        }
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadExercises()
        }
        .onAppear {
            Task {
                await viewModel.loadExercises()
            }
        }
        .sheet(isPresented: $showingExerciseDetail) {
            if let exercise = selectedExercise {
                ExerciseDetailView(exercise: exercise)
            }
        }
        .sheet(isPresented: $showingMetronome) {
            MetronomeView()
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Practice Time")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Improve your skills")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Practice stats
                if let progress = progressManager.userProgress {
                    VStack {
                        Text("\(Int(progress.totalPracticeTime / 3600))h")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("Total Practice")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color("PrimaryColor").opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Streak indicator
            if let progress = progressManager.userProgress, progress.streak > 0 {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    
                    Text("\(progress.streak) day streak")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Start")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                Button(action: {
                    Task {
                        await viewModel.startPracticeSession()
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
                        
                        Text("Start Practice")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingMetronome = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "timer")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Text("Metronome")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var currentSessionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Current Session")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("End Session") {
                    Task {
                        await viewModel.endCurrentSession()
                    }
                }
                .buttonStyle(.bordered)
            }
            
            if let session = viewModel.currentSession {
                VStack(spacing: 8) {
                    HStack {
                        Text("Duration: \(formatDuration(session.duration))")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("Accuracy: \(Int(session.accuracy * 100))%")
                            .font(.subheadline)
                    }
                    
                    ProgressView(value: session.duration / 3600) // Show progress towards 1 hour
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryColor")))
                        .frame(height: 4)
                }
                .padding()
                .background(Color("PrimaryColor").opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    private var practiceToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice Tools")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                PracticeToolCard(
                    title: "Metronome",
                    icon: "timer",
                    color: .blue,
                    description: "Keep time"
                ) {
                    showingMetronome = true
                }
                
                PracticeToolCard(
                    title: "Tuner",
                    icon: "tuningfork",
                    color: .green,
                    description: "Tune your bass"
                ) {
                    // Open tuner
                }
                
                PracticeToolCard(
                    title: "Recording",
                    icon: "mic.fill",
                    color: .red,
                    description: "Record yourself"
                ) {
                    isRecording.toggle()
                }
                
                PracticeToolCard(
                    title: "Backing Tracks",
                    icon: "music.note.list",
                    color: .purple,
                    description: "Play along"
                ) {
                    // Open backing tracks
                }
            }
        }
    }
    
    private var recommendedExercisesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.recommendedExercises, id: \.title) { exercise in
                        ExerciseCardView(exercise: exercise) {
                            selectedExercise = exercise
                            showingExerciseDetail = true
                        }
                        .frame(width: 280)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var allExercisesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All Exercises")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Filter") {
                    // Show filter options
                }
                .buttonStyle(.bordered)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.allExercises, id: \.title) { exercise in
                    ExerciseCardView(exercise: exercise) {
                        selectedExercise = exercise
                        showingExerciseDetail = true
                    }
                }
            }
        }
    }
    
    private var practiceHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Practice")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                ForEach(progressManager.practiceSessions.prefix(5), id: \.id) { session in
                    PracticeSessionCard(session: session)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Supporting Views

struct PracticeToolCard: View {
    let title: String
    let icon: String
    let color: Color
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExerciseCardView: View {
    let exercise: ExerciseContent
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(exercise.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                        
                        Text(exercise.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(exercise.tempo) BPM")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        
                        if exercise.metronomeEnabled {
                            Image(systemName: "timer")
                                .foregroundColor(.blue)
                        }
                        
                        if exercise.recordingEnabled {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                HStack {
                    Label("Target: \(Int(exercise.targetAccuracy * 100))%", systemImage: "target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Start")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PracticeSessionCard: View {
    let session: PracticeSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDate(session.startTime))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(Int(session.duration / 60)) minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(session.accuracy * 100))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(session.accuracy > 0.8 ? .green : .orange)
                
                Text("\(session.tempo) BPM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Preview

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PracticeView()
                .environmentObject(ProgressManager())
        }
    }
}
