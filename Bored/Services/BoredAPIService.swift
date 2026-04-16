import Foundation
import OSLog

protocol BoredAPIServiceProtocol {
    func fetchRandomActivity(excluding seenIDs: Set<String>) async throws -> Activity
    func fetchFilteredActivity(with filters: FilterSettings, excluding seenIDs: Set<String>) async throws -> Activity
}

struct BoredAPIService: BoredAPIServiceProtocol {
    private let randomURLString = "https://bored-api.appbrewery.com/random"
    private let filterURLString = "https://bored-api.appbrewery.com/filter"
    
    // MARK: - 1. Fetch Random (Single Object)
    
    func fetchRandomActivity(excluding seenIDs: Set<String> = []) async throws -> Activity {
        var attempts = 0
        let maxAttempts = 5
        
        guard let url = URL(string: randomURLString) else {
            throw APIError.invalidURL
        }
        
        while attempts < maxAttempts {
            attempts += 1
            Logger.network.info("Fetching random activity... (Attempt \(attempts)/\(maxAttempts))")
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                try validate(response)
                let safeData = try sanitize(data)
                
                let activity = try JSONDecoder().decode(Activity.self, from: safeData)
                
                if !seenIDs.contains(activity.id) {
                    Logger.network.info("Successfully fetched random activity: \(activity.name)")
                    return activity
                } else {
                    Logger.network.notice("Collision with seen activity. Retrying...")
                }
            } catch let error as APIError {
                if case .rateLimitExceeded = error { throw error }
            } catch {
                throw APIError.networkError(error)
            }
        }
        
        Logger.logic.notice("Max retry attempts reached for random fetch.")
        throw APIError.noActivityFound
    }
    
    // MARK: - 2. Fetch Filtered (Array of Objects)
    
    func fetchFilteredActivity(with filters: FilterSettings, excluding seenIDs: Set<String> = []) async throws -> Activity {
        Logger.network.info("Fetching filtered activities...")
        
        guard let filterURL = URL(string: filterURLString),
              var components = URLComponents(url: filterURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        
        var queryItems: [URLQueryItem] = []
        if let type = filters.type { queryItems.append(URLQueryItem(name: "type", value: type.rawValue)) }
        if let participants = filters.participants { queryItems.append(URLQueryItem(name: "participants", value: String(participants.rawValue))) }
        components.queryItems = queryItems
        let url = components.url ?? filterURL
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.networkError(error)
        }
        
        try validate(response)
        let safeData = try sanitize(data)
        
        let allActivities = try JSONDecoder().decode([Activity].self, from: safeData)
        
        var validActivities = allActivities
        if let level = filters.level { validActivities = validActivities.filter { $0.level == level } }
        if let duration = filters.duration { validActivities = validActivities.filter { $0.duration == duration } }
        
        validActivities = validActivities.filter { !seenIDs.contains($0.id) }
        
        guard let finalActivity = validActivities.randomElement() else {
            Logger.logic.notice("Pool exhausted. All \(allActivities.count) activities filtered out or seen.")
            throw APIError.noActivityFound
        }
        
        Logger.network.info("Successfully resolved final filtered activity: \(finalActivity.name)")
        return finalActivity
    }
    
    // MARK: - Shared Helpers
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        if httpResponse.statusCode == 404 { throw APIError.noActivityFound }
        if httpResponse.statusCode == 429 || httpResponse.statusCode == 502 || httpResponse.statusCode == 503 { throw APIError.rateLimitExceeded }
        guard (200...299).contains(httpResponse.statusCode) else { throw APIError.invalidResponse }
    }
    
    private func sanitize(_ data: Data) throws -> Data {
        var safeData = data
        if let rawString = String(data: data, encoding: .utf8) {
            var cleaned = rawString.replacingOccurrences(of: "'\"", with: "\"")
            cleaned = cleaned.replacingOccurrences(of: "\"'", with: "\"")
            safeData = cleaned.data(using: .utf8) ?? data
        }
        
        if let errorResponse = try? JSONDecoder().decode([String: String].self, from: safeData),
           let apiErrorMessage = errorResponse["error"] {
            // Fixed Statement Position Violation: Multi-line formatting
            if apiErrorMessage.lowercased().contains("limit") {
                throw APIError.rateLimitExceeded
            } else {
                throw APIError.noActivityFound
            }
        }
        return safeData
    }
}
