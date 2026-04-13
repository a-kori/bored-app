import Foundation

struct FilterSettings: Equatable {
    var type: ActivityType?
    var level: ActivityLevel?
    var duration: ActivityDuration?
    var participants: Int?
    
    mutating func setFilters(type: ActivityType?, level: ActivityLevel?, duration: ActivityDuration?, participants: Int?) {
        self.type = type
        self.level = level
        self.duration = duration
        self.participants = participants
    }
    
    mutating func clearFilters() {
        self.type = nil
        self.level = nil
        self.duration = nil
        self.participants = nil
    }
}
