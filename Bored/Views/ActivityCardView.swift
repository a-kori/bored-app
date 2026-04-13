import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    
    var body: some View {
        VStack(spacing: 24) {
            
            // 1. Activity Type Badge (Brought back!)
            Text(activity.type.displayName.uppercased())
                .font(.caption.weight(.bold))
                .foregroundColor(.blue)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.15))
                .clipShape(Capsule())
            
            // 2. Main Activity Name
            Text(activity.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            // 3. Details Row
            HStack(spacing: 16) {
                DetailPill(icon: "person.fill", text: "\(activity.participants) Person")
                DetailPill(icon: "chart.bar.fill", text: activity.level.displayName)
                DetailPill(icon: "clock.fill", text: activity.duration.displayName)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48) // Gives the card a solid, consistent size without taking up the whole screen
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground)) // HIG compliant background
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 24)
    }
}

// Subview for the bottom row
struct DetailPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption.weight(.medium))
        .foregroundColor(.secondary)
    }
}

#Preview {
    ActivityCardView(
        activity: Activity(
            id: "1",
            name: "Learn how to juggle",
            type: .education,
            level: .medium,
            duration: .hours,
            participants: 1,
            url: nil
        )
    )
}
