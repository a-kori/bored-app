import Foundation
import Observation
import OSLog

@Observable
class ActivityBoardViewModel {
    var activityHistory: [Activity] = []
    var currentIndex: Int = 0
    var isLoading: Bool = false
    var errorMessage: String?
    
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
    func fetchInitialActivities() async {
        await fetchNewActivity()
        // Be polite to the free API to avoid rate limits
        try? await Task.sleep(for: .seconds(0.5))
        await fetchNewActivity()
    }
    
    @MainActor
    func fetchNewActivity() async {
        guard !isLoading else {
            return
        }
        isLoading = true
        errorMessage = nil
        
        do {
            let newActivity = try await apiService.fetchActivity(with: currentFilters)
            activityHistory.append(newActivity)
            Logger.logic.info("Fetched new activity. Total in history: \(self.activityHistory.count)")
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "An unexpected error occurred. Please try again."
        }
        
        isLoading = false
    }
}
