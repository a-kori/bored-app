import Foundation

struct Activity: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let type: ActivityType
    let level: ActivityLevel
    let duration: ActivityDuration
    let participants: Int
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id = "key"
        case name = "activity"
        case type
        case level = "accessibility"
        case duration
        case participants
        case url = "link"
    }
}
