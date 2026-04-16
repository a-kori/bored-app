import SwiftUI
import ConfettiSwiftUI

struct ActivityCardView: View {
    let activity: Activity
    
    private var themeColor: Color {
        ColorHelper.color(for: activity.type)
    }

    @Environment(BookmarkViewModel.self) private var bookmarkViewModel
    @State private var confettiCounter = 0
    
    var body: some View {
        VStack(spacing: 24) {
            // 1. Top Row: Centered Badge and Trailing Bookmark
            ZStack {
                Text(activity.type.displayName)
                    .textCase(.uppercase)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(themeColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(themeColor.opacity(0.15), in: Capsule())
                
                HStack {
                    Spacer()
                    Button {
                        bookmarkViewModel.toggleBookmark(for: activity)
                        if bookmarkViewModel.isBookmarked(activity) {
                            confettiCounter += 1
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    } label: {
                        Image(systemName: bookmarkViewModel.isBookmarked(activity) ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundStyle(bookmarkViewModel.isBookmarked(activity) ? themeColor : .secondary)
                            .padding(.leading, 12)
                            .padding(.vertical, 8)
                    }
                    .accessibilityLabel(bookmarkViewModel.isBookmarked(activity) ? "Remove bookmark" : "Add bookmark")
                    .confettiCannon(
                        counter: $confettiCounter,
                        num: 30,
                        colors: [.blue, .red, .green, .yellow, .pink, .purple],
                        confettiSize: 10,
                        radius: 60
                    )
                }
            }
            
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
                    .background(Color.blue.opacity(0.1), in: Capsule())
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                Color(.secondarySystemBackground)
                ColorHelper.background(for: activity.type)
            }
        }
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
    .environment(BookmarkViewModel())
}
