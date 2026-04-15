import SwiftUI

struct EndOfLineCardView: View {
    let isLoading: Bool
    let errorMessage: String?
    let onTryAgain: () async -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            if isLoading {
                ProgressView()
                    .controlSize(.large)
                Text("Fetching next idea...")
                    .font(.headline)
                    .foregroundStyle(.secondary) // FIX: Foreground Style
            } else if let error = errorMessage {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.orange)
                
                Text("Fetch Failed")
                    .font(.title2.weight(.bold))
                
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Button("Try Again") {
                    Task {
                        await onTryAgain()
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
    }
}
