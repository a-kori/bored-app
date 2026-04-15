import Foundation
import Observation

@Observable
class BookmarkViewModel {
    var bookmarkedActivities: [Activity] = []
    
    private let storageService = LocalStorageService()
    
    init() {
        self.bookmarkedActivities = storageService.loadBookmarks()
    }
    
    func isBookmarked(_ activity: Activity) -> Bool {
        bookmarkedActivities.contains(where: { $0.id == activity.id })
    }
    
    func toggleBookmark(for activity: Activity) {
        if let index = bookmarkedActivities.firstIndex(where: { $0.id == activity.id }) {
            // Remove if it already exists
            bookmarkedActivities.remove(at: index)
        } else {
            // Add if it doesn't exist
            bookmarkedActivities.append(activity)
        }
        
        // Persist the changes
        storageService.saveBookmarks(bookmarkedActivities)
    }
    
    func deleteBookmarks(at offsets: IndexSet) {
        bookmarkedActivities.remove(atOffsets: offsets)
        storageService.saveBookmarks(bookmarkedActivities)
    }
}
