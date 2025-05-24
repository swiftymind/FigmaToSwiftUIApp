//
//  ContentView.swift
//  FigmaToSwiftUIApp
//
//  Created by kanagasabapathy on 24.05.25.
//

import SwiftUI
import Models
import ViewModels

struct ContentView: View {
    let viewModel: MovieListViewModel
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                ScrollView {
                    if !viewModel.movies.isEmpty {
                        LazyVGrid(columns: gridColumns, spacing: 24) {
                            ForEach(viewModel.movies) { movie in
                                MovieCard(movie: movie)
                                    .frame(height: 280)
                            }
                        }
                        .padding(.horizontal)
                        .animation(.spring(duration: 0.3), value: viewModel.movies)
                    } else if !viewModel.isLoading && viewModel.errorMessage == nil {
                        ContentUnavailableView(
                            "No Movies Found",
                            systemImage: "film",
                            description: Text("Try adjusting your search criteria")
                        )
                        .padding(.top, 40)
                    }
                }
                .refreshable {
                    await viewModel.loadPopularMovies()
                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView("Loading Movies...")
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.background.opacity(0.7))
                    }
                }

                // Error View
                if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label("Error", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Try Again") {
                            Task {
                                if viewModel.searchText.isEmpty {
                                    await viewModel.loadPopularMovies()
                                } else {
                                    await viewModel.performSearch()
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 8)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.background.opacity(0.7))
                }
            }
            .navigationTitle("Movies")
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search movies...",
                suggestions: {
                    if isSearching && !viewModel.searchText.isEmpty {
                        ProgressView()
                            .padding()
                    }
                }
            )
            .onChange(of: viewModel.searchText) { _, _ in
                isSearching = true
                // Search text changes are handled by the debounced publisher in ViewModel
            }
            .onChange(of: viewModel.movies) { _, _ in
                isSearching = false
            }
        }
        .task {
            await viewModel.loadPopularMovies()
        }
    }
}

#Preview {
    ContentView(viewModel: MovieListViewModel(movieService: MovieService(apiKey: "YOUR_API_KEY")))
}
