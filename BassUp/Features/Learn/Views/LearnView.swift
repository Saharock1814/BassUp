//
//  LearnView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI

struct LearnView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var viewModel = LearnViewModel()
    @State private var selectedCategory: Lesson.LessonCategory?
    @State private var showingLessonDetail = false
    @State private var selectedLesson: Lesson?
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header
                headerSection
                
                // Current Progress
                if let currentLesson = progressManager.currentLesson {
                    currentLessonSection(currentLesson)
                }
                
                // Recommended Lesson
                if let recommended = viewModel.recommendedLesson {
                    recommendedLessonSection(recommended)
                }
                
                // Categories
                categoriesSection
                
                // Recent Lessons
                if !progressManager.completedLessons.isEmpty {
                    recentLessonsSection
                }
                
                // All Lessons
                allLessonsSection
            }
            .padding()
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadLessons()
        }
        .onAppear {
            Task {
                await viewModel.loadLessons()
            }
        }
        .sheet(isPresented: $showingLessonDetail) {
            if let lesson = selectedLesson {
                LessonDetailView(lesson: lesson)
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(String.learnWelcomeBack.localized)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(String.learnContinueJourney.localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Level indicator
                if let progress = progressManager.userProgress {
                    VStack {
                        Text("Level \(progress.level)")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("XP: \(progress.experience)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color("PrimaryColor").opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Progress bar
            if let progress = progressManager.userProgress {
                ProgressView(value: Double(progress.experience % 100) / 100.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryColor")))
                    .frame(height: 8)
                
                Text("\(100 - (progress.experience % 100)) \(String.learnXpToNextLevel.localized)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func currentLessonSection(_ lesson: Lesson) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String.learnCurrentLesson.localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(String.learnContinue.localized) {
                    selectedLesson = lesson
                    showingLessonDetail = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            LessonCardView(lesson: lesson, showProgress: true)
        }
    }
    
    private func recommendedLessonSection(_ lesson: Lesson) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String.learnRecommended.localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(String.learnStart.localized) {
                    selectedLesson = lesson
                    showingLessonDetail = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            LessonCardView(lesson: lesson, showProgress: false)
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String.learnCategories.localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Lesson.LessonCategory.allCases, id: \.self) { category in
                    CategoryCardView(category: category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    private var recentLessonsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String.learnRecentLessons.localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(progressManager.completedLessons.prefix(5), id: \.id) { lesson in
                        LessonCardView(lesson: lesson, showProgress: false)
                            .frame(width: 280)
                            .onTapGesture {
                                selectedLesson = lesson
                                showingLessonDetail = true
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var allLessonsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String.learnAllLessons.localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(String.learnFilter.localized) {
                    // Show filter options
                }
                .buttonStyle(.bordered)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredLessons, id: \.id) { lesson in
                    LessonCardView(lesson: lesson, showProgress: false)
                        .onTapGesture {
                            selectedLesson = lesson
                            showingLessonDetail = true
                        }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct LessonCardView: View {
    let lesson: Lesson
    let showProgress: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(lesson.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Image(systemName: lesson.category.icon)
                            .foregroundColor(lesson.category.color)
                        
                        Text(lesson.category.rawValue)
                            .font(.caption)
                            .foregroundColor(lesson.category.color)
                    }
                    
                    Text(lesson.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(lesson.difficulty.color.opacity(0.2))
                        .foregroundColor(lesson.difficulty.color)
                        .cornerRadius(8)
                }
            }
            
            if showProgress {
                ProgressView(value: lesson.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryColor")))
                    .frame(height: 4)
                
                Text("\(Int(lesson.progress * 100))% Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(Int(lesson.duration / 60)) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if lesson.isCompleted {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CategoryCardView: View {
    let category: Lesson.LessonCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.title)
                    .foregroundColor(category.color)
                
                Text(category.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("\(0) lessons") // TODO: Add lesson count
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(category.color.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearnView()
                .environmentObject(ProgressManager())
        }
    }
}
