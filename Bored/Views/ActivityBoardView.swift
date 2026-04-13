import SwiftUI

struct ActivityBoardView: View {
    @State private var viewModel = ActivityBoardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                if viewModel.activityHistory.isEmpty && viewModel.isLoading {
                    // 1. Initial Loading State
                    ProgressView("Finding a great activity...")
                        .controlSize(.large)
                } else if let error = viewModel.errorMessage, viewModel.activityHistory.isEmpty {
                    // 2. Error State (only if no history exists to show)
                    ContentUnavailableView(
                        "Oops!",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else {
                    // 3. Content State (The swipeable feed)
                    VStack {
                        TabView(selection: $viewModel.currentIndex) {
                            ForEach(Array(viewModel.activityHistory.enumerated()), id: \.element.id) { index, activity in
                                ActivityCardView(activity: activity)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                        // "Next" Button to explicitly fetch a new one
                        Button {
                            Task {
                                await viewModel.fetchNewActivity()
                            }
                        } label: {
                            HStack {
                                Text("I'm still bored")
                                Image(systemName: "arrow.right.circle.fill")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isLoading ? Color.gray : Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Bored?")
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
                // Fetch the very first activity when the view appears
                if viewModel.activityHistory.isEmpty {
                    await viewModel.fetchNewActivity()
                }
            }
        }
    }
}

#Preview {
    ActivityBoardView()
}
