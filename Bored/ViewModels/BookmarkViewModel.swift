import Foundation
import Observation

@Observable
class BookmarkViewModel {
    var bookmarkedActivities: [Activity] = []
    
    private let storageService = LocalStorageService()
    
    init() {
        self.bookmarkedActivities = storageService.loadBookmarks()
    }
    
    func add(_ activity: Activity) {
        guard !bookmarkedActivities.contains(where: { $0.id == activity.id }) else {
            return
        }
        bookmarkedActivities.append(activity)
        storageService.saveBookmarks(bookmarkedActivities)
    }
    
    func isBookmarked(_ activity: Activity) -> Bool {
        bookmarkedActivities.contains(where: { $0.id == activity.id })
    }
    
    func toggleBookmark(for activity: Activity) {
        if let index = bookmarkedActivities.firstIndex(where: { $0.id == activity.id }) {
            bookmarkedActivities.remove(at: index)
        } else {
            bookmarkedActivities.append(activity)
        }
        storageService.saveBookmarks(bookmarkedActivities)
    }
    
    func deleteBookmarks(at offsets: IndexSet) {
        bookmarkedActivities.remove(atOffsets: offsets)
        storageService.saveBookmarks(bookmarkedActivities)
    }
}
