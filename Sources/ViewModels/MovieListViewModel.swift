import Foundation
import Combine
import Models

@MainActor
public final class MovieListViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published public private(set) var movies: [Movie] = []
    @Published public private(set) var isLoading = false
    @Published public var searchText = ""
    @Published public private(set) var errorMessage: String?

    // MARK: - Private Properties

    private let movieService: MovieService
    private var searchCancellable: AnyCancellable?
    private let searchDebounceInterval: TimeInterval = 0.5

    // MARK: - Initialization

    public init(movieService: MovieService) {
        self.movieService = movieService
        setupSearchSubscription()
    }

    // MARK: - Public Methods

    /// Loads popular movies from the service
    public func loadPopularMovies() {
        Task {
            await fetchPopularMovies()
        }
    }

    /// Manually triggers a search with the current searchText
    public func performSearch() {
        guard !searchText.isEmpty else {
            Task {
                await fetchPopularMovies()
            }
            return
        }

        Task {
            await search(query: searchText)
        }
    }

    // MARK: - Private Methods

    private func setupSearchSubscription() {
        searchCancellable = $searchText
            .debounce(for: .seconds(searchDebounceInterval), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self else { return }

                Task {
                    if searchText.isEmpty {
                        await self.fetchPopularMovies()
                    } else {
                        await self.search(query: searchText)
                    }
                }
            }
    }

    private func fetchPopularMovies() async {
        await setLoading(true)
        do {
            let fetchedMovies = try await movieService.getPopularMovies()
            await updateMovies(fetchedMovies)
            await setError(nil)
        } catch {
            await handleError(error)
        }
        await setLoading(false)
    }

    private func search(query: String) async {
        await setLoading(true)
        do {
            let searchResults = try await movieService.searchMovies(query: query)
            await updateMovies(searchResults)
            await setError(nil)
        } catch {
            await handleError(error)
        }
        await setLoading(false)
    }

    private func setLoading(_ loading: Bool) {
        isLoading = loading
    }

    private func updateMovies(_ newMovies: [Movie]) {
        movies = newMovies
    }

    private func setError(_ message: String?) {
        errorMessage = message
    }

    private func handleError(_ error: Error) {
        if let movieError = error as? MovieError {
            setError(movieError.errorDescription)
        } else {
            setError(error.localizedDescription)
        }
    }
}