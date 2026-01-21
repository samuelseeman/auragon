import SwiftUI
import SwiftData

struct HistoryView: View {
    // This line fetches all logs and sorts them by newest first
    @Query(sort: \MigraineLog.startTime, order: .reverse) var logs: [MigraineLog]
    @Environment(\.modelContext) var modelContext // To delete items
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.base.ignoresSafeArea()
                
                if logs.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "notebook")
                            .font(.system(size: 50))
                            .foregroundStyle(.gray.opacity(0.3))
                        Text("No history yet")
                            .font(.headline)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                } else {
                    // The List
                    List {
                        ForEach(logs) { log in
                            // In the future, we can add a NavigationLink here to see details
                            HistoryRow(log: log)
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(.gray.opacity(0.2))
                        }
                        .onDelete(perform: deleteLog)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("History")
        }
    }
    
    // Swipe to delete function
    func deleteLog(at offsets: IndexSet) {
        for index in offsets {
            let logToDelete = logs[index]
            modelContext.delete(logToDelete)
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: MigraineLog.self, inMemory: true)
}