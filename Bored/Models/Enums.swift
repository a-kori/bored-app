import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case education
    case recreational
    case social
    case charity
    case cooking
    case relaxation
    case busywork
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

enum ActivityLevel: String, Codable, CaseIterable {
    case easy
    case medium
    case hard
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

enum ActivityDuration: String, Codable, CaseIterable {
    case minutes
    case hours
    case days
    
    var displayName: String {
        self.rawValue.capitalized
    }
}
