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
                    await viewModel.fetchNewActivity()
                }
            }
            // NEW: Alert overlay for background fetch errors
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
                Button("Cancel", role: .cancel) { }
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
        .padding(.bottom, 16) // Increased slightly to give the card some breathing room
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
            await viewModel.fetchNewActivity()
        }
    }
    
    private var mainContentView: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(Array(viewModel.activityHistory.enumerated()), id: \.element.id) { index, activity in
                
                // NEW: Wrapped in a VStack with a Spacer to push the card higher up
                VStack {
                    ActivityCardView(activity: activity)
                        .padding(.top, 8)
                    Spacer() 
                }
                .tag(index)
                
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.currentIndex) { _, newIndex in
            if newIndex == viewModel.activityHistory.count - 1 {
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
