import SwiftUI

struct ColorHelper {
    static func color(for type: ActivityType) -> Color {
        switch type {
        case .education:    return .blue
        case .recreational: return .orange
        case .social:       return .pink
        case .diy:          return .teal
        case .charity:      return .green
        case .cooking:      return .red
        case .relaxation:   return .mint
        case .music:        return .purple
        case .busywork:     return .indigo
        }
    }
    
    static func background(for type: ActivityType) -> Color {
        // 10% opacity creates a pastel in Light mode and a dark jewel-tone in Dark mode
        return color(for: type).opacity(0.1)
    }
}
