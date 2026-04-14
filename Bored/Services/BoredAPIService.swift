import Foundation
import OSLog

// Defining a protocol makes it easier to mock this service later if you write unit tests.
protocol BoredAPIServiceProtocol {
    func fetchActivity(with filters: FilterSettings) async throws -> Activity
}

struct BoredAPIService: BoredAPIServiceProtocol {
    private let baseURL = "https://bored-api.appbrewery.com/random"
    
    func fetchActivity(with filters: FilterSettings) async throws -> Activity {
        // 1. Construct URL safely
        guard var components = URLComponents(string: baseURL) else {
            Logger.network.error("Failed to initialize URLComponents with base URL.")
            throw APIError.invalidURL
        }
        
        guard let url = components.url else {
            Logger.network.error("Failed to construct final URL from components.")
            throw APIError.invalidURL
        }
        
        Logger.network.info("Fetching activity from: \(url.absoluteString)")
        
        // 2. Perform Async Network Request
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            Logger.network.error("Network request failed: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
        
        // 3. Validate HTTP Response
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.network.error("Response was not an HTTPURLResponse.")
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 404 {
            Logger.network.notice("No activity found for given filters.")
            throw APIError.noActivityFound
        }
        
        if httpResponse.statusCode == 429 || httpResponse.statusCode == 502 || httpResponse.statusCode == 503 {
            Logger.network.warning("Server rate limit or overload detected. Status code: \(httpResponse.statusCode)")
            throw APIError.rateLimitExceeded
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            Logger.network.error("Bad HTTP status code received: \(httpResponse.statusCode)")
            throw APIError.invalidResponse
        }
        
        // 4. Decode JSON
        do {
            let decoder = JSONDecoder()
            
            if let errorResponse = try? decoder.decode([String: String].self, from: data), let apiErrorMessage = errorResponse["error"] {
                Logger.network.warning("API returned a hidden error: \(apiErrorMessage)")
                if apiErrorMessage.lowercased().contains("limit") {
                    throw APIError.rateLimitExceeded
                } else {
                    throw APIError.noActivityFound
                }
            }
            
            // If no hidden error, decode normally
            let activity = try decoder.decode(Activity.self, from: data)
            Logger.network.info("Successfully fetched activity: \(activity.name) (ID: \(activity.id))")
            return activity
        } catch let error as APIError {
            throw error // Pass our custom errors through
        } catch {
            Logger.network.error("Failed to decode JSON. Error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
        }
    }
}
