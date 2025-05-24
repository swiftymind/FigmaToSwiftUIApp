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

    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 24) {
                        ForEach(viewModel.movies) { movie in
                            MovieCard(movie: movie)
                                .frame(height: 280)
                        }
                    }
                    .padding(.horizontal)
                }
                .refreshable {
                    viewModel.loadPopularMovies()
                }

                // Loading View
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.background.opacity(0.7))
                }

                // Error View
                if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("Try Again") {
                            viewModel.loadPopularMovies()
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
            .searchable(text: $viewModel.searchText, prompt: "Search movies...")
        }
        .onAppear {
            viewModel.loadPopularMovies()
        }
    }
}

#Preview {
    ContentView(viewModel: MovieListViewModel(movieService: MovieService(apiKey: "YOUR_API_KEY")))
}
