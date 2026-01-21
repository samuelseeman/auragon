import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.base.ignoresSafeArea()
                
                List {
                    Section("Configuration") {
                        NavigationLink(destination: ManageTriggersView()) {
                            Label("Manage Triggers", systemImage: "bolt.fill")
                        }
                        
                        // You can replicate this for Medications later
                        Label("Manage Medications", systemImage: "pills.fill")
                            .foregroundStyle(.gray) // Grayed out for now
                    }
                    
                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .scrollContentBackground(.hidden) // Makes the list transparent to show our background
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}