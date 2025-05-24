import Foundation

// Import local models
@_exported import struct Models.Movie
@_exported import struct Models.MovieResponse
@_exported import enum Models.MovieError

/// Service class responsible for fetching movie data from TMDb API
actor MovieService {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey: String
    private let urlSession: URLSession

    init(apiKey: String, urlSession: URLSession = .shared) {
        self.apiKey = apiKey
        self.urlSession = urlSession
    }

    /// Fetches popular movies from TMDb
    /// - Returns: Array of movies
    /// - Throws: MovieError
    func getPopularMovies() async throws -> [Movie] {
        let endpoint = "\(baseURL)/movie/popular"
        let response: MovieResponse = try await fetchData(from: endpoint)
        return response.results
    }

    /// Searches for movies based on the query
    /// - Parameter query: Search term
    /// - Returns: Array of matching movies
    /// - Throws: MovieError
    func searchMovies(query: String) async throws -> [Movie] {
        let endpoint = "\(baseURL)/search/movie"
        let queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        let response: MovieResponse = try await fetchData(from: endpoint, queryItems: queryItems)
        return response.results
    }

    // MARK: - Private Methods

    private func fetchData<T: Decodable>(from endpoint: String, queryItems: [URLQueryItem] = []) async throws -> T {
        var components = URLComponents(string: endpoint)
        var allQueryItems = queryItems
        allQueryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components?.queryItems = allQueryItems

        guard let url = components?.url else {
            throw MovieError.invalidURL
        }

        do {
            let (data, response) = try await urlSession.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw MovieError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw MovieError.serverError(httpResponse.statusCode)
            }

            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw MovieError.invalidData
            }
        } catch let error as MovieError {
            throw error
        } catch {
            throw MovieError.networkError(error)
        }
    }
}