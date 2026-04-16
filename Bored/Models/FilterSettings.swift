import Foundation

enum ParticipantFilter: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case aboveFive = 8 // Maps to 8 for the API
    
    var id: Int { rawValue }
    
    var displayName: String {
        self == .aboveFive ? "Above 5" : "\(rawValue)"
    }
}

struct FilterSettings: Equatable, CustomStringConvertible {
    var type: ActivityType?
    var participants: ParticipantFilter?
    var level: ActivityLevel?
    var duration: ActivityDuration?
    
    var isActive: Bool {
        type != nil || participants != nil || level != nil || duration != nil
    }
    
    var description: String {
        var activeFilters: [String] = []
        
        if let type = type { activeFilters.append("Type: \(type.displayName)") }
        if let participants = participants { activeFilters.append("Participants: \(participants.displayName)") }
        if let level = level { activeFilters.append("Level: \(level.displayName)") }
        if let duration = duration { activeFilters.append("Duration: \(duration.displayName)") }
        
        if activeFilters.isEmpty {
            return "No Active Filters"
        } else {
            return activeFilters.joined(separator: ", ")
        }
    }
}
