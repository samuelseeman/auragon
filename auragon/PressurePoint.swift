import SwiftUI
import Charts

// 1. Mock Data Model
struct PressurePoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double // inHg
}

// 2. Helper for the Time Range Picker
enum TimeRange: String, CaseIterable {
    case oneDay = "24 Hours"
    case threeDays = "3 Days"
    case sevenDays = "7 Days"
    
    var hours: Int {
        switch self {
        case .oneDay: return 24
        case .threeDays: return 72
        case .sevenDays: return 168
        }
    }
}

struct PressureDetailView: View {
    // State for Interaction
    @State private var selectedTimeRange: TimeRange = .oneDay
    @State private var rawSelectedDate: Date? // The raw touch location
    
    // Mock Data Generator
    // We create a sine wave to simulate realistic pressure rising/falling
    var data: [PressurePoint] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0..<selectedTimeRange.hours).map { hourOffset in
            let date = calendar.date(byAdding: .hour, value: hourOffset, to: now)!
            // Simulate a pressure wave between 29.80 and 30.20
            let sineValue = sin(Double(hourOffset) * 0.2) * 0.15
            let value = 30.00 + sineValue + Double.random(in: -0.01...0.01)
            return PressurePoint(date: date, value: value)
        }
    }
    
    // Helper to find the exact data point closest to where the user is touching
    var selectedPoint: PressurePoint? {
        guard let rawSelectedDate else { return nil }
        return data.min(by: { 
            abs($0.date.timeIntervalSince(rawSelectedDate)) < abs($1.date.timeIntervalSince(rawSelectedDate)) 
        })
    }
    
    var body: some View {
        ZStack {
            Color.base.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // --- Header & Current Value ---
                VStack(spacing: 8) {
                    Text(selectedPoint != nil ? "Forecast at Selected Time" : "Current Pressure")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    Text(String(format: "%.2f inHg", selectedPoint?.value ?? data.first?.value ?? 0))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)
                        .contentTransition(.numericText()) // Smooth number animation
                }
                .padding(.top, 20)
                
                // --- The Chart ---
                VStack(alignment: .leading) {
                    Chart {
                        ForEach(data) { point in
                            // The Line
                            LineMark(
                                x: .value("Time", point.date),
                                y: .value("Pressure", point.value)
                            )
                            .foregroundStyle(Color.accent)
                            .interpolationMethod(.catmullRom) // Smooths the jagged edges
                            
                            // The Gradient Fill below
                            AreaMark(
                                x: .value("Time", point.date),
                                yStart: .value("Base", 29.70), // Visual baseline
                                yEnd: .value("Pressure", point.value)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.accent.opacity(0.3), Color.accent.opacity(0.0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                        
                        // The "Scrubber" Line
                        if let selectedPoint {
                            RuleMark(x: .value("Selected Time", selectedPoint.date))
                                .foregroundStyle(.white.opacity(0.5))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                .annotation(position: .top) {
                                    Text(selectedPoint.date.formatted(date: .omitted, time: .shortened))
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                        .padding(4)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(4)
                                }
                        }
                    }
                    .chartXSelection(value: $rawSelectedDate) // NATIVE SWIFTUI INTERACTION
                    .chartYScale(domain: 29.70...30.30) // Keeps the graph centered
                    .frame(height: 250)
                }
                .padding(.horizontal)
                
                // --- Time Range Picker ---
                Picker("Time Range", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // --- Metrics Grid ---
                HStack(spacing: 16) {
                    MetricTile(title: "Trend", value: "Falling", icon: "arrow.down.right", color: .yellow)
                    MetricTile(title: "24h Delta", value: "-0.05", icon: "chart.bar", color: .red)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Pressure Forecast")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable Tile Component
struct MetricTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        PressureDetailView()
    }
}