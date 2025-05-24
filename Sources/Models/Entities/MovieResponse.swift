import Foundation

public struct MovieResponse: Codable {
    public let page: Int
    public let totalPages: Int
    public let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }

    public init(page: Int, totalPages: Int, results: [Movie]) {
        self.page = page
        self.totalPages = totalPages
        self.results = results
    }
}