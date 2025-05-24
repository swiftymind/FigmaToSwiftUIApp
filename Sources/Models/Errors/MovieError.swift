import Foundation

public enum MovieError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case serverError(Int)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from the server"
        case .invalidData:
            return "Invalid data received"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        }
    }
}