import SwiftUI

struct DashboardView: View {
    // Controls the presentation of the "Log Attack" form
    @State private var showLogSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Solid Background
                Color.base.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // 1. Status Section (Clickable -> Leads to Pressure Graph)
                        NavigationLink(destination: PressureDetailView()) {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("Current Status")
                                        .font(.headline)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.gray.opacity(0.5))
                                }
                                
                                HStack {
                                    // Placeholder for live data or "High Pressure"
                                    Text("High Pressure")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.green)
                                }
                            }
                            .padding()
                            .background(Color.base.opacity(0.05)) // Subtle tile background
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes blue link color
                        
                        // 2. Action Button (Triggers the Log Sheet)
                        Button(action: {
                            showLogSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Log Migraine Attack")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                        }
                        .foregroundStyle(Color.base) // Text color (dark) on the accent button
                        
                        // 3. Snapshot Details (Placeholder stats)
                        VStack(spacing: 1) {
                            HStack {
                                Text("Hydration")
                                Spacer()
                                Text("20oz")
                                    .foregroundStyle(.gray)
                            }
                            .padding()

                            HStack {
                                Text("Sleep")
                                Spacer()
                                Text("6h 30m")
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                        }
                        .background(Color.gray.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                }
            }
            .navigationTitle("Auragon")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            // The Sheet for Logging
            .sheet(isPresented: $showLogSheet) {
                LogAttackView()
            }
        }
    }
}

#Preview {
    DashboardView()
}