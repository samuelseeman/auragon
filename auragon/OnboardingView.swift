import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var isOnboardingComplete: Bool
    
    // Tracks which page we are on (0 = Welcome, 1 = Triggers, 2 = Meds, 3 = Finish)
    @State private var currentPage = 0
    
    // Temporary storage for user choices
    @State private var selectedTriggers: Set<String> = []
    @State private var selectedMeds: Set<String> = []
    
    // Suggested Defaults
    let suggestedTriggers = ["Stress", "Dehydration", "Bright Light", "Lack of Sleep", "Weather Change", "Alcohol", "Caffeine", "Screen Time", "Loud Noise", "Strong Smells"]
    
    let suggestedMeds = ["Ibuprofen", "Sumatriptan", "Excedrin", "Water", "Sleep", "Dark Room", "Ice Pack", "Caffeine", "Massage", "Magnesium"]
    
    var body: some View {
        ZStack {
            Color.base.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // PAGE 1: Welcome
                WelcomePage(action: nextPage)
                    .tag(0)
                
                // PAGE 2: Triggers
                SelectionPage(
                    title: "Identify Triggers",
                    subtitle: "Select the things that most commonly cause your migraines. You can change this later.",
                    items: suggestedTriggers,
                    selections: $selectedTriggers,
                    action: nextPage
                )
                .tag(1)
                
                // PAGE 3: Medications
                SelectionPage(
                    title: "Your Toolkit",
                    subtitle: "Select the medications or relief methods you typically use.",
                    items: suggestedMeds,
                    selections: $selectedMeds,
                    action: nextPage
                )
                .tag(2)
                
                // PAGE 4: Finalize
                FinalPage {
                    completeOnboarding()
                }
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // We handle navigation manually
            .animation(.easeInOut, value: currentPage)
        }
    }
    
    func nextPage() {
        withAnimation {
            currentPage += 1
        }
    }
    
    func completeOnboarding() {
        // 1. Clear any existing junk (optional safety)
        try? modelContext.delete(model: TriggerOption.self)
        try? modelContext.delete(model: MedicationOption.self)
        
        // 2. Save Triggers
        for name in selectedTriggers {
            let newTrigger = TriggerOption(name: name, isDefault: true)
            modelContext.insert(newTrigger)
        }
        
        // 3. Save Meds
        for name in selectedMeds {
            let newMed = MedicationOption(name: name, isDefault: true)
            modelContext.insert(newMed)
        }
        
        // 4. Close Onboarding
        withAnimation {
            isOnboardingComplete = true
        }
    }
}

// MARK: - Subviews

struct WelcomePage: View {
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundStyle(Color.accentColor)
                .shadow(color: Color.accentColor.opacity(0.5), radius: 20)
            
            VStack(spacing: 12) {
                Text("Welcome to Auragon")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Your personal companion for\ntracking and managing migraines.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: action) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundStyle(.base)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

struct SelectionPage: View {
    let title: String
    let subtitle: String
    let items: [String]
    @Binding var selections: Set<String>
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.horizontal)
            
            // Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            toggle(item)
                        }) {
                            HStack {
                                Text(item)
                                Spacer()
                                if selections.contains(item) {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .padding()
                            .background(selections.contains(item) ? Color.accentColor.opacity(0.2) : Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selections.contains(item) ? Color.accentColor : Color.clear, lineWidth: 2)
                            )
                        }
                        .foregroundStyle(.white)
                    }
                }
                .padding()
            }
            
            // Next Button
            Button(action: action) {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.base)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
    
    func toggle(_ item: String) {
        if selections.contains(item) {
            selections.remove(item)
        } else {
            selections.insert(item)
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

struct FinalPage: View {
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
                .shadow(color: .green.opacity(0.5), radius: 20)
            
            VStack(spacing: 12) {
                Text("You're All Set!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Auragon is ready to help you\ntrack and predict your migraines.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: action) {
                Text("Enter App")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}