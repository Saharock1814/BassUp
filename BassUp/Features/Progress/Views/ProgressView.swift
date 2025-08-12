//
//  ProgressView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI
import Charts

struct ProgressView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var progressManager: ProgressManager
    @State private var selectedTimeframe: Timeframe = .week
    @State private var showingAchievementDetail = false
    @State private var selectedAchievement: Achievement?
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header
                headerSection
                
                // Stats Overview
                statsOverviewSection
                
                // Practice Chart
                practiceChartSection
                
                // Achievements
                achievementsSection
                
                // Recent Activity
                recentActivitySection
                
                // Goals
                goalsSection
            }
            .padding()
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await progressManager.loadUserProgress()
        }
        .sheet(isPresented: $showingAchievementDetail) {
            if let achievement = selectedAchievement {
                AchievementDetailView(achievement: achievement)
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Your Progress")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Track your learning journey")
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
                
                Text("\(100 - (progress.experience % 100)) XP to next level")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var statsOverviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                if let progress = progressManager.userProgress {
                    StatCard(
                        title: "Total Practice",
                        value: formatDuration(progress.totalPracticeTime),
                        icon: "clock.fill",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "Accuracy",
                        value: "\(Int(progress.accuracy * 100))%",
                        icon: "target",
                        color: .green
                    )
                    
                    StatCard(
                        title: "Streak",
                        value: "\(progress.streak) days",
                        icon: "flame.fill",
                        color: .orange
                    )
                    
                    StatCard(
                        title: "Lessons",
                        value: "\(progress.completedLessons.count)",
                        icon: "book.fill",
                        color: .purple
                    )
                }
            }
        }
    }
    
    private var practiceChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Practice Time")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.displayName).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            // Chart placeholder
            ChartPlaceholderView()
                .frame(height: 200)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(progressManager.achievements.count) unlocked")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if progressManager.achievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "trophy")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No achievements yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Complete lessons and practice regularly to unlock achievements!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    ForEach(progressManager.achievements, id: \.id) { achievement in
                        AchievementCard(achievement: achievement) {
                            selectedAchievement = achievement
                            showingAchievementDetail = true
                        }
                    }
                }
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.semibold)
            
            if progressManager.practiceSessions.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "music.note")
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                    
                    Text("No recent activity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(progressManager.practiceSessions.prefix(5), id: \.id) { session in
                        ActivityCard(session: session)
                    }
                }
            }
        }
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Goals")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 12) {
                GoalCard(
                    title: "Daily Practice",
                    description: "Practice for 30 minutes today",
                    progress: 0.6,
                    target: "30 min",
                    current: "18 min",
                    icon: "clock.fill",
                    color: .blue
                )
                
                GoalCard(
                    title: "Weekly Practice",
                    description: "Practice for 3.5 hours this week",
                    progress: 0.4,
                    target: "3.5h",
                    current: "1.4h",
                    icon: "calendar",
                    color: .green
                )
                
                GoalCard(
                    title: "Lesson Completion",
                    description: "Complete 5 lessons this month",
                    progress: 0.8,
                    target: "5",
                    current: "4",
                    icon: "book.fill",
                    color: .purple
                )
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

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(achievement.isUnlocked ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActivityCard: View {
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

struct GoalCard: View {
    let title: String
    let description: String
    let progress: Double
    let target: String
    let current: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(current) / \(target)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(height: 4)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ChartPlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("Practice Chart")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Supporting Types

enum Timeframe: String, CaseIterable {
    case week = "week"
    case month = "month"
    case year = "year"
    
    var displayName: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}

// MARK: - Preview

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProgressView()
                .environmentObject(ProgressManager())
        }
    }
}
