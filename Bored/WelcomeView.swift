//
//  WelcomeView.swift
//  Bored
//
//  Created by Anastasiia Korzhylova on 07.04.26.
//

import SwiftUI

struct WelcomeView: View {
    // MARK: - State Properties
    @State private var cardOffset: CGSize = .zero
    private let swipeThreshold: CGFloat = 150.0
    @State private var showingSavedActivities = false
    
    // MARK: - Main Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                headerSection
                
                Spacer()
                
                activityCardSection
                
                Spacer()
                
                actionButtonsSection
            }
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingSavedActivities = true
                    }) {
                        Text("Saved")
                            .font(.callout)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingSavedActivities) {
                SavedActivitiesView()
            }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("  Bored?")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("   Swipe to discover, tap to save.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 10)
    }
    
    private var activityCardSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue.opacity(0.1))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 30) {
                Text("Learn how to juggle")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 12) {
                    Label("Education", systemImage: "book.fill")
                    Label("1 Person", systemImage: "person.fill")
                    Label("Indoor", systemImage: "house.fill")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
        }
        .frame(height: 400)
        .padding(.horizontal, 20)
        .offset(x: cardOffset.width, y: cardOffset.height)
        .rotationEffect(.degrees(Double(cardOffset.width / 20)))
        .gesture(swipeGesture)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            Button(action: {}) {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 60)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    // MARK: - Gestures
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                self.cardOffset = gesture.translation
            }
            .onEnded { _ in
                if abs(self.cardOffset.width) > swipeThreshold {
                    self.cardOffset = .zero
                } else {
                    withAnimation(.spring()) {
                        self.cardOffset = .zero
                    }
                }
            }
    }
}

// MARK: - Placeholder View for the Saved List
struct SavedActivitiesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Text("Learn how to juggle")
                Text("Bake a loaf of bread")
                Text("Organize your photo library")
            }
            .navigationTitle("Saved Activities")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    WelcomeView()
}
