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
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: BookmarkView()) {
                        Image(systemName: "bookmark.fill")
                            .accessibilityLabel("View saved activities")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Filter view action later
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .accessibilityLabel("Filter activities")
                    }
                }
            }
            .task {
                if viewModel.activityHistory.isEmpty {
                    await viewModel.fetchInitialActivities()
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 6) {
            Text("Bored?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            Text("Swipe to discover, tap to save.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var contentArea: some View {
        if viewModel.activityHistory.isEmpty && viewModel.isLoading {
            VStack {
                Spacer()
                ProgressView("Finding a great activity...")
                    .controlSize(.large)
                Spacer()
            }
        } else if let error = viewModel.errorMessage, viewModel.activityHistory.isEmpty {
            ErrorRefreshView(message: error) {
                await viewModel.fetchInitialActivities()
            }
        } else {
            mainContentView
        }
    }
    
    private var mainContentView: some View {
        TabView(selection: $viewModel.currentIndex) {
            // 1. The Actual Activity Cards
            ForEach(Array(viewModel.activityHistory.enumerated()), id: \.element.id) { index, activity in
                ActivityCardView(activity: activity)
                    .tag(index)
            }
            
            // 2. The Permanent "End of Line" Status Card
            if viewModel.isLoading || viewModel.errorMessage != nil {
                EndOfLineCardView(
                    isLoading: viewModel.isLoading,
                    errorMessage: viewModel.errorMessage
                ) {
                    await viewModel.fetchNewActivity()
                }
                .tag(viewModel.activityHistory.count)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.currentIndex) { oldIndex, newIndex in
            // Prefetch when they hit the last real card
            if newIndex == viewModel.activityHistory.count - 1 && newIndex > oldIndex {
                Task {
                    await viewModel.fetchNewActivity()
                }
            } else if newIndex == viewModel.activityHistory.count && !viewModel.isLoading {
                Task {
                    await viewModel.fetchNewActivity()
                }
            }
        }
    }
}

#Preview {
    ActivityBoardView()
    .environment(BookmarkViewModel())
}
