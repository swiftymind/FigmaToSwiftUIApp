//
//  FigmaToSwiftUIAppApp.swift
//  FigmaToSwiftUIApp
//
//  Created by kanagasabapathy on 24.05.25.
//

import SwiftUI
import Models
import ViewModels

@main
struct FigmaToSwiftUIAppApp: App {
    // Replace with your actual TMDb API key
    private let movieService = MovieService(apiKey: "YOUR_API_KEY")
    private let movieListViewModel: MovieListViewModel

    init() {
        movieListViewModel = MovieListViewModel(movieService: movieService)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: movieListViewModel)
        }
    }
}
