import Foundation
import Observation
import OSLog

@Observable
class ActivityBoardViewModel {
    // State properties for the UI
    var activityHistory: [Activity] = []
    var currentIndex: Int = 0
    var isLoading: Bool = false
    
    // FIX 1: Removed the redundant "= nil"
    var errorMessage: String?
    
    // Dependencies
    private let apiService: BoredAPIServiceProtocol
    var currentFilters = FilterSettings()
    
    init(apiService: BoredAPIServiceProtocol = BoredAPIService()) {
        self.apiService = apiService
    }
    
    // Computed property for easy access
    var currentActivity: Activity? {
        // FIX 2: Moved 'return nil' to the next line
        guard activityHistory.indices.contains(currentIndex) else {
            return nil
        }
        return activityHistory[currentIndex]
    }
    
    @MainActor
    func fetchNewActivity() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let newActivity = try await apiService.fetchActivity(with: currentFilters)
            
            // Append to history and update index to show the new card
            activityHistory.append(newActivity)
            currentIndex = activityHistory.count - 1
            
            Logger.logic.info("Fetched new activity and added to history. Total count: \(self.activityHistory.count)")
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "An unexpected error occurred. Please try again."
        }
        
        isLoading = false
    }
}
