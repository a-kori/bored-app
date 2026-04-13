import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    
    var body: some View {
        VStack(spacing: 24) {
            // Category Badge
            Text(activity.type.displayName)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue)
                .clipShape(Capsule())
            
            // Main Activity Name
            Text(activity.name)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
            
            // Details Grid
            VStack(alignment: .leading, spacing: 16) {
                DetailRow(icon: "person.2.fill", label: "Participants", value: "\(activity.participants)")
                DetailRow(icon: "chart.bar.fill", label: "Difficulty", value: activity.level.displayName)
                DetailRow(icon: "clock.fill", label: "Duration", value: activity.duration.displayName)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding()
    }
}

// A small subview to keep the code DRY
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.body)
    }
}

// FIX 3: Broke the preview initialization into multiple lines to satisfy the line length rule
#Preview {
    ActivityCardView(
        activity: Activity(
            id: "1",
            name: "Learn how to play a new instrument",
            type: .education,
            level: .hard,
            duration: .days,
            participants: 1,
            url: nil
        )
    )
}
