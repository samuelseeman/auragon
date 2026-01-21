import SwiftUI
import SwiftData

struct LogAttackView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext // The database connection
    
    // Form Inputs
    @State private var painLevel: Double = 5.0
    @State private var selectedTriggers: Set<String> = []
    @State private var notes: String = ""
    @State private var startTime = Date()
    
    // Hardcoded options for now (We will make these editable in Settings later)
    let commonTriggers = ["Stress", "Dehydration", "Bright Light", "Lack of Sleep", "Alcohol", "Weather Change"]
    
    var body: some View {
        NavigationStack {
            Form {
                // Section 1: The Basics
                Section {
                    HStack {
                        Text("Pain Level")
                        Spacer()
                        Text("\(Int(painLevel))")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(painColor(level: painLevel))
                    }
                    
                    Slider(value: $painLevel, in: 1...10, step: 1) {
                        Text("Pain Level")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("10")
                    }
                    .tint(painColor(level: painLevel))
                    
                    DatePicker("Time Started", selection: $startTime)
                } header: {
                    Text("Severity")
                }
                
                // Section 2: Triggers (Multi-select)
                Section {
                    ForEach(commonTriggers, id: \.self) { trigger in
                        Button(action: {
                            toggleTrigger(trigger)
                        }) {
                            HStack {
                                Text(trigger)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if selectedTriggers.contains(trigger) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accent)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Potential Triggers")
                }
                
                // Section 3: Notes
                Section {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                    Text("Add any specific details here...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                } header: {
                    Text("Notes")
                }
            }
            .navigationTitle("Log Attack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Log") {
                        saveLog()
                    }
                    .font(.headline)
                }
            }
        }
    }
    
    // Helper: Dynamic color for pain slider
    func painColor(level: Double) -> Color {
        switch level {
        case 1...3: return .green
        case 4...6: return .orange
        case 7...10: return .red
        default: return .blue
        }
    }
    
    func toggleTrigger(_ trigger: String) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(trigger)
        } else {
            selectedTriggers.insert(trigger)
        }
    }
    
    func saveLog() {
        let newLog = MigraineLog(
            startTime: startTime,
            painLevel: Int(painLevel),
            triggers: Array(selectedTriggers),
            notes: notes
        )
        
        // Save to Database
        modelContext.insert(newLog)
        
        // Close the screen
        dismiss()
    }
}

#Preview {
    LogAttackView()
}