//
//  TheoryView.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import SwiftUI

struct TheoryView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = TheoryViewModel()
    @State private var selectedCategory: MusicTheory.TheoryCategory?
    @State private var showingTheoryDetail = false
    @State private var selectedTheory: MusicTheory?
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header
                headerSection
                
                // Categories
                categoriesSection
                
                // Featured Theory
                if let featured = viewModel.featuredTheory {
                    featuredTheorySection(featured)
                }
                
                // All Theory Topics
                allTheorySection
            }
            .padding()
        }
        .navigationTitle("Music Theory")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadTheory()
        }
        .onAppear {
            Task {
                await viewModel.loadTheory()
            }
        }
        .sheet(isPresented: $showingTheoryDetail) {
            if let theory = selectedTheory {
                TheoryDetailView(theory: theory)
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Music Theory")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Master the fundamentals")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Progress indicator
                VStack {
                    Text("\(viewModel.completedTopics)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color("PrimaryColor").opacity(0.1))
                .cornerRadius(12)
            }
            
            // Progress bar
            ProgressView(value: viewModel.completionProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryColor")))
                .frame(height: 8)
            
            Text("\(Int(viewModel.completionProgress * 100))% Complete")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(MusicTheory.TheoryCategory.allCases, id: \.self) { category in
                    TheoryCategoryCard(category: category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    private func featuredTheorySection(_ theory: MusicTheory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to all theory
                }
                .buttonStyle(.bordered)
            }
            
            TheoryCardView(theory: theory) {
                selectedTheory = theory
                showingTheoryDetail = true
            }
        }
    }
    
    private var allTheorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All Topics")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Filter") {
                    // Show filter options
                }
                .buttonStyle(.bordered)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTheory, id: \.id) { theory in
                    TheoryCardView(theory: theory) {
                        selectedTheory = theory
                        showingTheoryDetail = true
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct TheoryCategoryCard: View {
    let category: MusicTheory.TheoryCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: categoryIcon)
                    .font(.title)
                    .foregroundColor(categoryColor)
                
                Text(category.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("\(0) topics") // TODO: Add topic count
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(categoryColor.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryIcon: String {
        switch category {
        case .notation: return "music.note"
        case .rhythm: return "timer"
        case .harmony: return "music.note.list"
        case .melody: return "waveform"
        case .form: return "square.stack.3d.up"
        case .earTraining: return "ear"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .notation: return .blue
        case .rhythm: return .green
        case .harmony: return .purple
        case .melody: return .orange
        case .form: return .red
        case .earTraining: return .pink
        }
    }
}

struct TheoryCardView: View {
    let theory: MusicTheory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(theory.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                        
                        Text(theory.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(theory.category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(categoryColor.opacity(0.2))
                            .foregroundColor(categoryColor)
                            .cornerRadius(8)
                        
                        if theory.examples.count > 0 {
                            Label("\(theory.examples.count) examples", systemImage: "music.note")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                HStack {
                    Label("\(theory.exercises.count) exercises", systemImage: "target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Learn")
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
    
    private var categoryColor: Color {
        switch theory.category {
        case .notation: return .blue
        case .rhythm: return .green
        case .harmony: return .purple
        case .melody: return .orange
        case .form: return .red
        case .earTraining: return .pink
        }
    }
}

// MARK: - Preview

struct TheoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TheoryView()
        }
    }
}
