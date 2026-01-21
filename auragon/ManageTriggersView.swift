import SwiftUI
import SwiftData

struct ManageTriggersView: View {
    @Environment(\.modelContext) var modelContext
    // Fetch all triggers, sorted alphabetically
    @Query(sort: \TriggerOption.name) var triggers: [TriggerOption]
    
    @State private var newTriggerName = ""
    
    var body: some View {
        List {
            // Section 1: Add New
            Section {
                HStack {
                    TextField("Add new trigger (e.g. Red Wine)", text: $newTriggerName)
                    Button(action: addTrigger) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.accent)
                    }
                    .disabled(newTriggerName.isEmpty)
                }
            }
            
            // Section 2: Existing List
            Section("My Triggers") {
                ForEach(triggers) { trigger in
                    Text(trigger.name)
                }
                .onDelete(perform: deleteTrigger)
            }
        }
        .navigationTitle("Manage Triggers")
        .onAppear(perform: seedDefaultTriggers)
    }
    
    func addTrigger() {
        let newTrigger = TriggerOption(name: newTriggerName)
        modelContext.insert(newTrigger)
        newTriggerName = "" // Reset text field
    }
    
    func deleteTrigger(at offsets: IndexSet) {
        for index in offsets {
            let trigger = triggers[index]
            modelContext.delete(trigger)
        }
    }
    
    // Helper to ensure the list isn't empty on first run
    func seedDefaultTriggers() {
        if triggers.isEmpty {
            let defaults = ["Stress", "Dehydration", "Bright Light", "Lack of Sleep", "Weather Change"]
            for name in defaults {
                modelContext.insert(TriggerOption(name: name, isDefault: true))
            }
        }
    }
}