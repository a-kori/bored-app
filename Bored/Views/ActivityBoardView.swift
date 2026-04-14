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
                        // Filter view action later
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .task {
                if viewModel.activityHistory.isEmpty {
                    await viewModel.fetchNewActivity()
                    try? await Task.sleep(for: .seconds(0.5))
                    await viewModel.fetchNewActivity()
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
            
            // 2. The Permanent "End of Line" Status Card
            if !viewModel.activityHistory.isEmpty {
                VStack(spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView()
                            .controlSize(.large)
                        Text("Fetching next idea...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    } else {
                        // If it's not loading, it means a fetch failed. Show the error cleanly!
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        Text("Fetch Failed")
                            .font(.title2.weight(.bold))
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                        
                        Button("Try Again") {
                            Task {
                                await viewModel.fetchNewActivity()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(Capsule())
                        .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 80)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 24)
                .tag(viewModel.activityHistory.count) // Tagged so the user can always swipe to it
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.currentIndex) { oldIndex, newIndex in
            // Prefetch when they hit the last REAL card
            if newIndex == viewModel.activityHistory.count - 1 && newIndex > oldIndex {
                Task {
                    await viewModel.fetchNewActivity()
                }
            }
            // Also trigger a fetch if they explicitly swipe to the End of Line card
            else if newIndex == viewModel.activityHistory.count && !viewModel.isLoading {
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
