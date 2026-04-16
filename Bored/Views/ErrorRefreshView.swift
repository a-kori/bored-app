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

#Preview {
    ErrorRefreshView(message: "We couldn't connect to the server. Please check your internet connection and try again.") {}
}
