import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noActivityFound
    case rateLimitExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The app encountered an internal error with the server. Please try again later."
        case .networkError:
            return "Could not connect to the internet. Please check your connection and try again."
        case .invalidResponse:
            return "Received an unexpected response from the server. Please try again."
        case .decodingError:
            return "The app couldn't understand the server's response. The API might have changed."
        case .noActivityFound:
            return "No activity found matching those exact filters. Try loosening your requirements!"
        case .rateLimitExceeded:
            return "You've requested too many ideas! Please take a breather and try again in a few minutes."
        }
    }
}
