import SwiftUI

struct ErrorRefreshView: View {
    let message: String
    let onRefresh: () async -> Void
    
    var body: some View {
        ScrollView {
            ContentUnavailableView(
                "Oops!",
                systemImage: "exclamationmark.triangle",
                description: Text("\(message)\n\nSwipe down to refresh.")
            )
            .containerRelativeFrame(.vertical)
        }
        .refreshable {
            await onRefresh()
        }
    }
}
