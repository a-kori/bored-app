import Foundation
import OSLog

protocol BoredAPIServiceProtocol {
    func fetchActivity(with filters: FilterSettings) async throws -> Activity
}

struct BoredAPIService: BoredAPIServiceProtocol {
    private let baseURL = "https://bored-api.appbrewery.com/random"
    
    func fetchActivity(with filters: FilterSettings) async throws -> Activity {
        // 1. Build URL
        let url = try buildURL(with: filters)
        Logger.network.info("Fetching activity from: \(url.absoluteString)")
        
        // 2. Perform Request
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            Logger.network.error("Network request failed: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
        
        // 3. Validate & Decode
        try validate(response)
        return try decode(data)
    }
    
    // MARK: - Helper Functions
    
    private func buildURL(with filters: FilterSettings) throws -> URL {
        guard var components = URLComponents(string: baseURL) else {
            Logger.network.error("Failed to initialize URLComponents with base URL.")
            throw APIError.invalidURL
        }
        
        var queryItems: [URLQueryItem] = []
        if let type = filters.type {
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
        }
        if let participants = filters.participants {
            queryItems.append(URLQueryItem(name: "participants", value: String(participants)))
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            Logger.network.error("Failed to construct final URL from components.")
            throw APIError.invalidURL
        }
        return url
    }
    
    private func validate(_ response: URLResponse) throws {
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
    }
    
    private func decode(_ data: Data) throws -> Activity {
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
            
            let activity = try decoder.decode(Activity.self, from: data)
            Logger.network.info("Successfully fetched activity: \(activity.name) (ID: \(activity.id))")
            return activity
        } catch let error as APIError {
            throw error
        } catch {
            if let rawString = String(data: data, encoding: .utf8) {
                Logger.network.error("RAW JSON CRASH DUMP: \(rawString)")
            }
            Logger.network.error("Failed to decode JSON. Error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
        }
    }
}
