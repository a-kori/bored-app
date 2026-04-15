import SwiftUI

struct BookmarkView: View {
    @Environment(BookmarkViewModel.self) private var bookmarkViewModel
    
    var body: some View {
        Group {
            if bookmarkViewModel.bookmarkedActivities.isEmpty {
                ContentUnavailableView(
                    "No Bookmarks",
                    systemImage: "bookmark.slash",
                    description: Text("Activities you save will appear here.")
                )
            } else {
                List {
                    ForEach(bookmarkViewModel.bookmarkedActivities) { activity in
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(activity.name)
                                    .font(.headline)
                                
                                HStack(spacing: 8) {
                                    Text(activity.type.displayName)
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.blue)
                                    
                                    Text("•")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    
                                    Text("\(activity.participants) \(activity.participants == 1 ? "Person" : "People")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("•")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    
                                    Text(activity.level.displayName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("•")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    
                                    Text(activity.duration.displayName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            }
                            
                            // Pushes the following interactive icon to the far right
                            Spacer()
                            
                            // Conditional interactive icon for URL access
                            if let urlString = activity.url, !urlString.isEmpty, let url = URL(string: urlString) {
                                Link(destination: url) {
                                    Image(systemName: "link")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.blue)
                                        .padding(.horizontal, 4)
                                }
                                .accessibilityLabel("Open link in Safari")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    // Native iOS swipe-to-delete
                    .onDelete(perform: bookmarkViewModel.deleteBookmarks)
                }
            }
        }
        .navigationTitle("Saved Ideas")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BookmarkView()
            .environment(BookmarkViewModel())
    }
}
