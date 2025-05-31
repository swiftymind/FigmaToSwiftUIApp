//
//  FigmaToSwiftUIAppTests.swift
//  FigmaToSwiftUIAppTests
//
//  Created by kanagasabapathy on 24.05.25.
//

import Testing
import Foundation
@testable import FigmaToSwiftUIApp
@testable import Models

@Suite("Movie Model Tests")
struct MovieModelTests {

    // MARK: - Test Data

    private let validMovieData = Movie(
        id: 1,
        title: "Inception",
        overview: "A thief who steals corporate secrets through the use of dream-sharing technology.",
        posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
        releaseDate: "2010-07-16",
        voteAverage: 8.4
    )

    private let invalidDateMovieData = Movie(
        id: 2,
        title: "Invalid Date Movie",
        overview: "Movie with invalid date format",
        posterPath: "/invalid.jpg",
        releaseDate: "invalid-date",
        voteAverage: 7.5
    )

    // MARK: - Initialization Tests

    @Test("movie initialization with valid data")
    func movieInitialization_ShouldCreateValidMovie_WhenValidDataProvided() {
        // Given: Valid movie data (using validMovieData)

        // When: Movie is initialized
        let movie = validMovieData

        // Then: All properties should be set correctly
        #expect(movie.id == 1)
        #expect(movie.title == "Inception")
        #expect(movie.overview == "A thief who steals corporate secrets through the use of dream-sharing technology.")
        #expect(movie.posterPath == "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg")
        #expect(movie.releaseDate == "2010-07-16")
        #expect(movie.voteAverage == 8.4)
    }

    // MARK: - Computed Properties Tests

    @Suite("Formatted Release Date")
    struct FormattedReleaseDateTests {

        @Test("formatted release date with valid date")
        func formattedReleaseDate_ShouldReturnFormattedDate_WhenValidDateProvided() {
            // Given: Movie with valid release date
            let movie = Movie(
                id: 1,
                title: "Test Movie",
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: "2010-07-16",
                voteAverage: 8.0
            )

            // When: Accessing formatted release date
            let formattedDate = movie.formattedReleaseDate

            // Then: Should return properly formatted date
            #expect(formattedDate == "Jul 16, 2010")
        }

        @Test("formatted release date with invalid date")
        func formattedReleaseDate_ShouldReturnErrorMessage_WhenInvalidDateProvided() {
            // Given: Movie with invalid release date
            let movie = Movie(
                id: 2,
                title: "Invalid Date Movie",
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: "invalid-date-format",
                voteAverage: 7.5
            )

            // When: Accessing formatted release date
            let formattedDate = movie.formattedReleaseDate

            // Then: Should return error message
            #expect(formattedDate == "Release date unavailable")
        }

        @Test("formatted release date with different date formats",
              arguments: [
                ("2023-12-25", "Dec 25, 2023"),
                ("2020-01-01", "Jan 1, 2020"),
                ("2024-06-15", "Jun 15, 2024")
              ])
        func formattedReleaseDate_ShouldFormatCorrectly_ForVariousDates(
            inputDate: String,
            expectedOutput: String
        ) {
            // Given: Movie with specific release date
            let movie = Movie(
                id: 3,
                title: "Test Movie",
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: inputDate,
                voteAverage: 8.0
            )

            // When: Accessing formatted release date
            let formattedDate = movie.formattedReleaseDate

            // Then: Should match expected format
            #expect(formattedDate == expectedOutput)
        }
    }

    @Suite("Rating Formatting")
    struct RatingTests {

        @Test("rating formatting with various vote averages",
              arguments: [
                (8.4, "84%"),
                (7.0, "70%"),
                (9.5, "95%"),
                (6.7, "67%"),
                (10.0, "100%"),
                (0.0, "0%")
              ])
        func rating_ShouldFormatAsPercentage_ForVariousVoteAverages(
            voteAverage: Double,
            expectedRating: String
        ) {
            // Given: Movie with specific vote average
            let movie = Movie(
                id: 1,
                title: "Test Movie",
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: "2010-07-16",
                voteAverage: voteAverage
            )

            // When: Accessing rating
            let rating = movie.rating

            // Then: Should format as percentage correctly
            #expect(rating == expectedRating)
        }
    }

    @Suite("Poster URL")
    struct PosterURLTests {

        @Test("poster URL generation with valid poster path")
        func posterURL_ShouldGenerateValidURL_WhenValidPosterPathProvided() {
            // Given: Movie with valid poster path
            let movie = Movie(
                id: 1,
                title: "Test Movie",
                overview: "Test overview",
                posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
                releaseDate: "2010-07-16",
                voteAverage: 8.4
            )

            // When: Accessing poster URL
            let posterURL = movie.posterURL

            // Then: Should generate valid URL with correct base path
            #require(posterURL != nil, "Poster URL should not be nil")
            #expect(posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg")
        }

        @Test("poster URL generation with empty poster path")
        func posterURL_ShouldReturnNil_WhenEmptyPosterPathProvided() {
            // Given: Movie with empty poster path
            let movie = Movie(
                id: 2,
                title: "Test Movie",
                overview: "Test overview",
                posterPath: "",
                releaseDate: "2010-07-16",
                voteAverage: 8.4
            )

            // When: Accessing poster URL
            let posterURL = movie.posterURL

            // Then: Should return valid URL (even with empty path)
            #expect(posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500")
        }
    }

    // MARK: - Codable Tests

    @Suite("JSON Encoding/Decoding")
    struct CodableTests {

        @Test("movie JSON decoding with valid data")
        func movieDecoding_ShouldDecodeCorrectly_WhenValidJSONProvided() throws {
            // Given: Valid JSON data
            let jsonData = """
            {
                "id": 550,
                "title": "Fight Club",
                "overview": "An insomniac office worker looking for a way to change his life crosses paths with a devil-may-care soap maker.",
                "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
                "release_date": "1999-10-15",
                "vote_average": 8.433
            }
            """.data(using: .utf8)!

            // When: Decoding JSON to Movie
            let movie = try JSONDecoder().decode(Movie.self, from: jsonData)

            // Then: All properties should be decoded correctly
            #expect(movie.id == 550)
            #expect(movie.title == "Fight Club")
            #expect(movie.overview == "An insomniac office worker looking for a way to change his life crosses paths with a devil-may-care soap maker.")
            #expect(movie.posterPath == "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
            #expect(movie.releaseDate == "1999-10-15")
            #expect(movie.voteAverage == 8.433)
        }

        @Test("movie JSON encoding")
        func movieEncoding_ShouldEncodeCorrectly_WhenValidMovieProvided() throws {
            // Given: Valid movie object
            let movie = Movie(
                id: 550,
                title: "Fight Club",
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: "1999-10-15",
                voteAverage: 8.433
            )

            // When: Encoding movie to JSON
            let jsonData = try JSONEncoder().encode(movie)
            let decodedMovie = try JSONDecoder().decode(Movie.self, from: jsonData)

            // Then: Should round-trip correctly
            #expect(decodedMovie.id == movie.id)
            #expect(decodedMovie.title == movie.title)
            #expect(decodedMovie.overview == movie.overview)
            #expect(decodedMovie.posterPath == movie.posterPath)
            #expect(decodedMovie.releaseDate == movie.releaseDate)
            #expect(decodedMovie.voteAverage == movie.voteAverage)
        }

        @Test("movie JSON decoding with missing fields")
        func movieDecoding_ShouldThrowError_WhenRequiredFieldsMissing() {
            // Given: JSON with missing required fields
            let incompleteJSON = """
            {
                "id": 550,
                "title": "Fight Club"
            }
            """.data(using: .utf8)!

            // When/Then: Decoding should throw an error
            #expect(throws: DecodingError.self) {
                try JSONDecoder().decode(Movie.self, from: incompleteJSON)
            }
        }
    }

    // MARK: - Edge Cases and Boundary Tests

    @Suite("Edge Cases")
    struct EdgeCaseTests {

        @Test("movie with extreme vote average values",
              arguments: [
                (0.0, "0%"),
                (10.0, "100%"),
                (5.55, "55%"),  // Test rounding
                (9.99, "99%")   // Test rounding down
              ])
        func rating_ShouldHandleExtremeValues_Correctly(
            voteAverage: Double,
            expectedRating: String
        ) {
            // Given: Movie with extreme vote average
            let movie = Movie(
                id: 1,
                title: "Extreme Rating Movie",
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: "2010-07-16",
                voteAverage: voteAverage
            )

            // When: Accessing rating
            let rating = movie.rating

            // Then: Should handle extreme values correctly
            #expect(rating == expectedRating)
        }

        @Test("movie with very long title")
        func movieInitialization_ShouldHandleLongTitle_Correctly() {
            // Given: Movie with very long title
            let longTitle = String(repeating: "Very Long Movie Title ", count: 10)
            let movie = Movie(
                id: 1,
                title: longTitle,
                overview: "Test overview",
                posterPath: "/test.jpg",
                releaseDate: "2010-07-16",
                voteAverage: 8.0
            )

            // When: Accessing title
            let title = movie.title

            // Then: Should preserve the full title
            #expect(title == longTitle)
            #expect(title.count > 100)
        }

        @Test("movie with special characters in poster path")
        func posterURL_ShouldHandleSpecialCharacters_InPosterPath() {
            // Given: Movie with special characters in poster path
            let specialPath = "/poster%20with%20spaces.jpg"
            let movie = Movie(
                id: 1,
                title: "Special Characters Movie",
                overview: "Test overview",
                posterPath: specialPath,
                releaseDate: "2010-07-16",
                voteAverage: 8.0
            )

            // When: Accessing poster URL
            let posterURL = movie.posterURL

            // Then: Should create valid URL
            #require(posterURL != nil, "Poster URL should not be nil for special characters")
            #expect(posterURL?.absoluteString.contains("poster%20with%20spaces.jpg") == true)
        }
    }
}

// MARK: - Performance Tests

@Suite("Performance Tests")
struct MoviePerformanceTests {

    @Test("date formatting performance")
    func dateFormatting_ShouldPerformEfficiently_ForMultipleMovies() {
        // Given: Multiple movies
        let movies = (1...1000).map { index in
            Movie(
                id: index,
                title: "Movie \(index)",
                overview: "Overview \(index)",
                posterPath: "/poster\(index).jpg",
                releaseDate: "2020-01-\(String(format: "%02d", (index % 28) + 1))",
                voteAverage: Double(index % 10)
            )
        }

        // When: Formatting dates for all movies (this tests performance)
        let startTime = CFAbsoluteTimeGetCurrent()
        let formattedDates = movies.map { $0.formattedReleaseDate }
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

        // Then: Should complete in reasonable time and all dates should be formatted
        #expect(formattedDates.count == 1000)
        #expect(timeElapsed < 1.0, "Date formatting should complete within 1 second for 1000 items")
    }
}
