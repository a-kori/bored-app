import Foundation
import Observation
import OSLog

@Observable
class ActivityBoardViewModel {
    var activityHistory: [Activity] = []
    var seenActivityIDs: Set<String> = []
    
    var currentIndex: Int = 0
    var isLoading: Bool = false
    var errorMessage: String?
    var hasReachedEndOfFeed: Bool = false
    
    private let apiService: BoredAPIServiceProtocol
    var currentFilters = FilterSettings()
    
    init(apiService: BoredAPIServiceProtocol = BoredAPIService()) {
        self.apiService = apiService
    }
    
    var currentActivity: Activity? {
        guard activityHistory.indices.contains(currentIndex) else {
            return nil
        }
        return activityHistory[currentIndex]
    }
    
    @MainActor
    func applyFilters(_ newFilters: FilterSettings) async {
        self.currentFilters = newFilters
        
        // Wipe the old history
        self.activityHistory.removeAll()
        self.seenActivityIDs.removeAll()
        self.currentIndex = 0

        // Fetch fresh data matching the new filters
        self.errorMessage = nil
        self.hasReachedEndOfFeed = false
        await fetchInitialActivities()
    }
    
    @MainActor
    func fetchInitialActivities() async {
        await fetchNewActivity()
        // Be polite to the free API to avoid rate limits
        try? await Task.sleep(for: .seconds(0.5))
        await fetchNewActivity()
    }
    
    @MainActor
    func fetchNewActivity() async {
        // Abort if we are already loading or if we know the feed is empty
        guard !isLoading && !hasReachedEndOfFeed else {
            return
        }
        isLoading = true
        errorMessage = nil
        
        do {
            let newActivity: Activity
            
            // Routing logic based on filter state
            if currentFilters.isActive {
                newActivity = try await apiService.fetchFilteredActivity(with: currentFilters, excluding: seenActivityIDs)
            } else {
                newActivity = try await apiService.fetchRandomActivity(excluding: seenActivityIDs)
            }
            
            activityHistory.append(newActivity)
            seenActivityIDs.insert(newActivity.id)
            
            // Cleanup mechanism to prevent infinite memory growth
            if activityHistory.count > 50 {
                let itemsToRemove = activityHistory.count - 50
                let removedActivities = activityHistory.prefix(itemsToRemove)
                removedActivities.forEach { seenActivityIDs.remove($0.id) }
                
                activityHistory.removeFirst(itemsToRemove)
                currentIndex -= itemsToRemove
            }
            
            Logger.logic.info("Fetched new activity. Total in history: \(self.activityHistory.count)")
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
            if case .noActivityFound = error {
                if currentFilters.isActive {
                    if !activityHistory.isEmpty {
                        self.errorMessage = "You've seen all the activities for these filters! Try broadening your search."
                        self.hasReachedEndOfFeed = true
                    }
                } else {
                    self.errorMessage = "We couldn't find any fresh activities right now. Try again later!"
                }
            }
        } catch {
            self.errorMessage = "An unexpected error occurred. Please try again."
        }
        
        isLoading = false
    }
}
