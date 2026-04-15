import Foundation
import OSLog

struct LocalStorageService {
    private let bookmarksKey = "saved_bookmarks"
    
    func saveBookmarks(_ activities: [Activity]) {
        do {
            let encoded = try JSONEncoder().encode(activities)
            UserDefaults.standard.set(encoded, forKey: bookmarksKey)
            Logger.logic.info("Successfully saved \(activities.count) bookmarks to disk.")
        } catch {
            Logger.logic.error("Failed to encode bookmarks: \(error.localizedDescription)")
        }
    }
    
    func loadBookmarks() -> [Activity] {
        guard let data = UserDefaults.standard.data(forKey: bookmarksKey) else {
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode([Activity].self, from: data)
            Logger.logic.info("Loaded \(decoded.count) bookmarks from disk.")
            return decoded
        } catch {
            Logger.logic.error("Failed to decode bookmarks: \(error.localizedDescription)")
            return []
        }
    }
}
