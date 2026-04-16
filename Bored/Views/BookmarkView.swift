import SwiftUI

struct BookmarkView: View {
    @Environment(BookmarkViewModel.self) private var bookmarkViewModel
    @State private var isShowingCreateSheet = false
    @State private var expandedCategories: Set<ActivityType> = Set(ActivityType.allCases)
    
    var body: some View {
        Group {
            if bookmarkViewModel.bookmarkedActivities.isEmpty {
                ContentUnavailableView(
                    "No Bookmarks",
                    systemImage: "bookmark.slash",
                    description: Text("Activities you save or create will appear here.")
                )
            } else {
                List {
                    ForEach(bookmarkViewModel.activeCategories, id: \.self) { category in
                        let isExpanded = expandedCategories.contains(category)
                        
                        Section {
                            // Using a ternary array prevents the row from disappearing mid-drag
                            let items = isExpanded ? bookmarkViewModel.activities(for: category) : []
                            
                            ForEach(items) { activity in
                                BookmarkRowView(activity: activity)
                            }
                            .onDelete { offsets in
                                bookmarkViewModel.delete(at: offsets, in: category)
                            }
                            .onMove { source, destination in
                                bookmarkViewModel.move(from: source, to: destination, in: category)
                            }
                        } header: {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if isExpanded {
                                        expandedCategories.remove(category)
                                    } else {
                                        expandedCategories.insert(category)
                                    }
                                }
                            }) {
                                HStack {
                                    Text(category.displayName)
                                        .font(.title3.weight(.bold))
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.secondary)
                                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .textCase(nil)
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Saved Ideas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isShowingCreateSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .accessibilityLabel("Create custom activity")
                }
            }
        }
        .sheet(isPresented: $isShowingCreateSheet) {
            CreateActivityView { newActivity in
                bookmarkViewModel.add(newActivity)
            }
        }
    }
}

// MARK: - Extracted Row View
struct BookmarkRowView: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(activity.name)
                    .font(.headline)
                
                HStack(spacing: 8) {
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
}

#Preview {
    NavigationStack {
        BookmarkView()
            .environment(BookmarkViewModel())
    }
}
