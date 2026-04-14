import SwiftUI

struct ActivityBoardView: View {
    @State private var viewModel = ActivityBoardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    contentArea
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // We will implement Navigation to FilterView in Step 4
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .task {
                // Initial Load: Prefetch the first two cards so the user can immediately swipe
                if viewModel.activityHistory.isEmpty {
                    await viewModel.fetchNewActivity()
                    // Be polite to the free API to avoid rate limits
                    try? await Task.sleep(for: .seconds(0.5))
                    await viewModel.fetchNewActivity()
                }
            }
            // Alert overlay for background fetch errors
            .alert(
                "Fetch Failed",
                isPresented: $viewModel.showErrorAlert,
                presenting: viewModel.errorMessage
            ) { _ in
                Button("Try Again") {
                    Task {
                        await viewModel.fetchNewActivity()
                    }
                }
            } message: { message in
                Text(message)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 6) {
            Text("Bored?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Swipe to discover, tap to save.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var contentArea: some View {
        if viewModel.activityHistory.isEmpty && viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage, viewModel.activityHistory.isEmpty {
            errorView(message: error)
        } else {
            mainContentView
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Finding a great activity...")
                .controlSize(.large)
            Spacer()
        }
    }
    
    private func errorView(message: String) -> some View {
        ScrollView {
            ContentUnavailableView(
                "Oops!",
                systemImage: "exclamationmark.triangle",
                description: Text("\(message)\n\nSwipe down to refresh.")
            )
            .containerRelativeFrame(.vertical)
        }
        .refreshable {
            await viewModel.fetchNewActivity()
            try? await Task.sleep(for: .seconds(0.5))
            await viewModel.fetchNewActivity()
        }
    }
    
    private var mainContentView: some View {
        TabView(selection: $viewModel.currentIndex) {
            
            // 1. The Actual Activity Cards
            ForEach(Array(viewModel.activityHistory.enumerated()), id: \.element.id) { index, activity in
                ActivityCardView(activity: activity)
                    .tag(index)
            }
            
            // 2. The Seamless "Ghost" Loading Card at the end of the line
            if viewModel.isLoading && !viewModel.activityHistory.isEmpty {
                VStack(spacing: 24) {
                    ProgressView()
                        .controlSize(.large)
                    Text("Fetching next idea...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 80)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 24)
                .tag(viewModel.activityHistory.count)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.currentIndex) { oldIndex, newIndex in
            if newIndex == viewModel.activityHistory.count - 1 && newIndex > oldIndex {
                Task {
                    await viewModel.fetchNewActivity()
                }
            }
        }
    }
}

#Preview {
    ActivityBoardView()
}
