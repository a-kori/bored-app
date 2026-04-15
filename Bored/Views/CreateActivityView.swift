import SwiftUI

struct CreateActivityView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Activity) -> Void
    
    @State private var name = ""
    @State private var urlString = ""
    @State private var type = ActivityType.allCases[0]
    @State private var participants = 1
    @State private var level = ActivityLevel.allCases[0]
    @State private var duration = ActivityDuration.allCases[0]
    
    private var isURLValid: Bool {
        let trimmedURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedURL.isEmpty {
            return true
        }
        
        if trimmedURL.lowercased().hasPrefix("http://") || trimmedURL.lowercased().hasPrefix("https://") {
            guard let url = URL(string: trimmedURL), url.host != nil else {
                return false
            }
            return true
        }
        
        if trimmedURL.contains(".") && !trimmedURL.contains(" ") {
            let testURL = URL(string: "https://" + trimmedURL)
            return testURL?.host != nil
        }
        
        return false
    }
    
    private var isFormValid: Bool {
        let isNameValid = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return isNameValid && isURLValid
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Activity Details")) {
                    TextField("What do you want to do?", text: $name)
                    
                    VStack(alignment: .leading) {
                        TextField("URL (Optional)", text: $urlString)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        if !urlString.isEmpty && !isURLValid {
                            Text("Please enter a valid link (e.g., example.com)")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Picker("Category type", selection: $type) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Requirements")) {
                    Picker("Participants", selection: $participants) {
                        ForEach(1...20, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                                        
                    Picker("Difficulty level", selection: $level) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                    
                    Picker("Duration", selection: $duration) {
                        ForEach(ActivityDuration.allCases, id: \.self) { duration in
                            Text(duration.displayName).tag(duration)
                        }
                    }
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveActivity() }
                    .fontWeight(.bold)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveActivity() {
        var finalURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !finalURL.isEmpty && !finalURL.lowercased().hasPrefix("http://") && !finalURL.lowercased().hasPrefix("https://") {
            finalURL = "https://" + finalURL
        }
        
        let newActivity = Activity(
            id: UUID().uuidString,
            name: name,
            type: type,
            level: level,
            duration: duration,
            participants: participants,
            url: finalURL.isEmpty ? nil : finalURL
        )
        
        onSave(newActivity)
        dismiss()
    }
}

#Preview {
    CreateActivityView { _ in }
}
