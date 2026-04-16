import SwiftUI

struct EndOfFeedCardView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 80, height: 80)
                .background(Color.green.gradient)
                .clipShape(Circle())
                .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 6)
            
            Text("You're all caught up!")
                .font(.system(.title, design: .rounded).weight(.bold))
                .multilineTextAlignment(.center)
            
            Text("You have seen every activity that matches your current filters.\n\nTry broadening your search to discover more ideas!")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
    }
}

#Preview {
    EndOfFeedCardView()
}
