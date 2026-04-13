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
    case easy = "Few to no challenges"
    case medium = "Minor challenges"
    case hard = "Major challenges"
    
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
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
