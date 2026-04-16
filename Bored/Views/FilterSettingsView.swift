import SwiftUI
import OSLog

struct FilterSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Draft filters hold the state until the user hits "Apply"
    @State private var draftFilters: FilterSettings
    let onApply: (FilterSettings) -> Void
    
    init(currentFilters: FilterSettings, onApply: @escaping (FilterSettings) -> Void) {
        _draftFilters = State(initialValue: currentFilters)
        self.onApply = onApply
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category")) {
                    Picker("Type", selection: $draftFilters.type) {
                        Text("Any").tag(ActivityType?.none)
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(ActivityType?.some(type))
                        }
                    }
                }
                
                Section(header: Text("Group Size")) {
                    Picker("Participants", selection: $draftFilters.participants) {
                        Text("Any").tag(ParticipantFilter?.none)
                        ForEach(ParticipantFilter.allCases) { count in
                            Text(count.displayName).tag(ParticipantFilter?.some(count))
                        }
                    }
                }
                
                Section(header: Text("Difficulty & Time")) {
                    Picker("Level", selection: $draftFilters.level) {
                        Text("Any").tag(ActivityLevel?.none)
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(ActivityLevel?.some(level))
                        }
                    }
                    
                    Picker("Duration", selection: $draftFilters.duration) {
                        Text("Any").tag(ActivityDuration?.none)
                        ForEach(ActivityDuration.allCases, id: \.self) { duration in
                            Text(duration.displayName).tag(ActivityDuration?.some(duration))
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear All") {
                        draftFilters = FilterSettings()
                    }
                    .tint(draftFilters.isActive ? .red : .secondary)
                    .disabled(!draftFilters.isActive)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        onApply(draftFilters)
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    FilterSettingsView(
        currentFilters: FilterSettings(),
        onApply: { filters in
            Logger.logic.info("Preview applied filters: \(filters)")
        }
    )
}
