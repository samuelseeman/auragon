import SwiftUI

struct HistoryRow: View {
    let log: MigraineLog
    
    var body: some View {
        HStack(spacing: 16) {
            // 1. Pain Circle
            ZStack {
                Circle()
                    .fill(painColor(level: log.painLevel).opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text("\(log.painLevel)")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(painColor(level: log.painLevel))
            }
            
            // 2. Date and Details
            VStack(alignment: .leading, spacing: 4) {
                Text(log.startTime.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                    .foregroundStyle(.white)
                
                if !log.triggers.isEmpty {
                    Text(log.triggers.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                } else {
                    Text("No triggers recorded")
                        .font(.caption)
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            
            Spacer()
            
            // 3. Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.3))
        }
        .padding(.vertical, 8)
    }
    
    // Helper helper for consistency
    func painColor(level: Int) -> Color {
        switch level {
        case 1...3: return .green
        case 4...6: return .orange
        case 7...10: return .red
        default: return .blue
        }
    }
}