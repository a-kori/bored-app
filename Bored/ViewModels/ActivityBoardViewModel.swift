import Foundation
import Observation
import OSLog

@Observable
class ActivityBoardViewModel {
    var activityHistory: [Activity] = []
    var currentIndex: Int = 0
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Controls the popup alert for background fetch failures
    var showErrorAlert: Bool = false
    
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
    func fetchNewActivity() async {
        // Prevent overlapping fetches
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newActivity = try await apiService.fetchActivity(with: currentFilters)
            activityHistory.append(newActivity)
            Logger.logic.info("Fetched new activity. Total in history: \(self.activityHistory.count)")
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
            // If the user already has history, pop up an alert instead of taking over the screen
            if !activityHistory.isEmpty {
                self.showErrorAlert = true
            }
        } catch {
            self.errorMessage = "An unexpected error occurred. Please try again."
            if !activityHistory.isEmpty {
                self.showErrorAlert = true
            }
        }
        
        isLoading = false
    }
}
