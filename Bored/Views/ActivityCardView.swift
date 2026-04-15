import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    
    var body: some View {
        VStack(spacing: 24) {
            // 1. Activity Type Badge
            Text(activity.type.displayName)
                .textCase(.uppercase)
                .font(.caption.weight(.bold))
                .foregroundStyle(.blue)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.15))
                .clipShape(Capsule())
            
            // 2. Main Activity Name
            Text(activity.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
            
            // 3. Details Row
            HStack(spacing: 16) {
                DetailPill(icon: "person.fill", text: "\(activity.participants) Person")
                DetailPill(icon: "chart.bar.fill", text: activity.level.displayName)
                DetailPill(icon: "clock.fill", text: activity.duration.displayName)
            }
            
            // 4. Conditional URL Button
            // We check that the string exists, is not empty, AND forms a valid URL
            if let urlString = activity.url, !urlString.isEmpty, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack {
                        Text("Learn More")
                        Image(systemName: "safari.fill")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
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
        .foregroundStyle(.secondary)
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
            url: "https://en.wikipedia.org/wiki/Juggling"
        )
    )
}
