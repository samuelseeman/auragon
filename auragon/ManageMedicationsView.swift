import SwiftUI
import SwiftData

struct ManageMedicationsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \MedicationOption.name) var medications: [MedicationOption]
    
    @State private var newMedName = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Add new med (e.g. Excedrin)", text: $newMedName)
                    Button(action: addMed) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.accent)
                    }
                    .disabled(newMedName.isEmpty)
                }
            }
            
            Section("My Cabinet") {
                ForEach(medications) { med in
                    Text(med.name)
                }
                .onDelete(perform: deleteMed)
            }
        }
        .navigationTitle("Manage Medications")
        .onAppear(perform: seedDefaults)
    }
    
    func addMed() {
        let newMed = MedicationOption(name: newMedName)
        modelContext.insert(newMed)
        newMedName = ""
    }
    
    func deleteMed(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(medications[index])
        }
    }
    
    func seedDefaults() {
        if medications.isEmpty {
            let defaults = ["Ibuprofen", "Sumatriptan", "Excedrin", "Water", "Caffeine"]
            for name in defaults {
                modelContext.insert(MedicationOption(name: name, isDefault: true))
            }
        }
    }
}