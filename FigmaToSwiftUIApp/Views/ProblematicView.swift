//
//  ProblematicView.swift
//  FigmaToSwiftUIApp
//
//  Created for testing coderabbit.yaml configuration
//

import SwiftUI
import Foundation

// CRITICAL ISSUES: This class has several problems that should be caught by coderabbit.yaml

class ProblematicViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // CRITICAL: Hardcoded API key (should be flagged as CRITICAL SEVERITY)
    private let apiKey = "sk-1234567890abcdef1234567890abcdef"

    // HIGH SEVERITY: Synchronous network call on main thread
    func loadMovies() {
        isLoading = true

        // CRITICAL: Force unwrapping without proper guards
        let url = URL(string: "https://api.example.com/movies")!

        // HIGH SEVERITY: Synchronous network call
        let data = try! Data(contentsOf: url)
        let movies = try! JSONDecoder().decode([Movie].self, from: data)

        // CRITICAL: UI update not guaranteed to be on main thread
        self.movies = movies
        self.isLoading = false
    }

    // CRITICAL: Strong reference cycle risk
    func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.loadMovies() // Should use [weak self]
        }
    }
}

struct ProblematicView: View {
    @StateObject private var viewModel = ProblematicViewModel()

    var body: some View {
        VStack {
            // HIGH SEVERITY: Complex view body that should be extracted
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2.0)
                    .padding(.top, 50)

                // MEDIUM: Hardcoded string (should be localized)
                Text("Loading movies...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()

                // Simulating a complex view hierarchy
                VStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)

                            VStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 20)
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 15)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                // MEDIUM: Hardcoded string
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)

                // Missing accessibility labels
                Button("Retry") {
                    viewModel.loadMovies()
                }
                .buttonStyle(.borderedProminent)
            } else {
                // HIGH SEVERITY: Inefficient list rendering without lazy loading
                ScrollView {
                    VStack {
                        ForEach(viewModel.movies) { movie in
                            VStack(alignment: .leading) {
                                // CRITICAL: Force casting
                                let rating = Int(movie.voteAverage * 10) as! Int

                                Text(movie.title)
                                    .font(.headline)

                                Text(movie.overview)
                                    .font(.caption)
                                    .lineLimit(3)

                                HStack {
                                    // MEDIUM: Hardcoded string
                                    Text("Rating: \(rating)%")
                                    Spacer()
                                    Text(movie.releaseDate)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadMovies()
            viewModel.setupTimer()
        }
        // MEDIUM: Missing accessibility support
        // MEDIUM: No dark mode considerations
        // MEDIUM: No dynamic type support
    }
}

// CRITICAL: Missing error handling in network operations
extension ProblematicViewModel {
    // HIGH SEVERITY: Expensive operation in main thread
    func processLargeDataset() {
        let largeArray = Array(1...1_000_000)
        let processed = largeArray.map { $0 * $0 } // Should be on background queue
        print("Processed \(processed.count) items")
    }
}

#Preview {
    ProblematicView()
}