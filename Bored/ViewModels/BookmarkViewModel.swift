import Foundation
import Observation

@Observable
class BookmarkViewModel {
    var bookmarkedActivities: [Activity] = []
    
    private let storageService = LocalStorageService()
    
    init() {
        self.bookmarkedActivities = storageService.loadBookmarks()
    }
    
    // MARK: - Core Functions
    
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
    
    // MARK: - Category Logic
    
    var activeCategories: [ActivityType] {
        ActivityType.allCases.filter { type in
            bookmarkedActivities.contains(where: { $0.type == type })
        }
    }
    
    func activities(for type: ActivityType) -> [Activity] {
        bookmarkedActivities.filter { $0.type == type }
    }
    
    func delete(at offsets: IndexSet, in type: ActivityType) {
        let categoryActivities = activities(for: type)
        let idsToDelete = offsets.map { categoryActivities[$0].id }
        
        bookmarkedActivities.removeAll { idsToDelete.contains($0.id) }
        storageService.saveBookmarks(bookmarkedActivities)
    }
    
    func move(from source: IndexSet, to destination: Int, in type: ActivityType) {
        var categoryActivities = activities(for: type)
        categoryActivities.move(fromOffsets: source, toOffset: destination)
        
        // Find original slots and replace them with the newly ordered items
        let originalIndices = bookmarkedActivities.indices.filter { bookmarkedActivities[$0].type == type }
        for (index, originalIndex) in originalIndices.enumerated() {
            bookmarkedActivities[originalIndex] = categoryActivities[index]
        }
        
        storageService.saveBookmarks(bookmarkedActivities)
    }
}
