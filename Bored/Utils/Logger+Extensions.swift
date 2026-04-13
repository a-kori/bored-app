import OSLog
import Foundation

// We extend Logger to create static instances for different parts of our app.
// This allows us to easily filter logs in the Xcode console.
extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.boredapp"
    
    /// Logs related to HTTP requests, JSON decoding, and URL generation.
    static let network = Logger(subsystem: subsystem, category: "Networking")
    
    /// Logs related to app state, filtering logic, and user flow.
    static let logic = Logger(subsystem: subsystem, category: "Logic")
}
