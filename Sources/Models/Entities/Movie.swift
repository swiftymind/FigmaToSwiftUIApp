import Foundation

public struct Movie: Identifiable, Codable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String
    public let releaseDate: String
    public let voteAverage: Double

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    // MARK: - Public Init

    public init(id: Int, title: String, overview: String, posterPath: String, releaseDate: String, voteAverage: Double) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }

    // MARK: - Computed Properties

    /// Formatted release date in "MMM d, yyyy" format
    public var formattedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: releaseDate) else {
            return "Release date unavailable"
        }

        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    /// Formatted rating as a percentage
    public var rating: String {
        let percentage = Int(voteAverage * 10)
        return "\(percentage)%"
    }

    /// Full poster URL
    public var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}