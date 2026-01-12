import SwiftUI

struct HomeView: View {
    @StateObject private var goalService = GoalService()
    @State private var showingCreateGoal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                if goalService.goals.isEmpty {
                    // Empty State
                    VStack(spacing: 24) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("Start Your First Goal")
                            .font(AppFonts.header)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Define your objective, set a timeline, and let AI guide you to success.")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        PrimaryButton(title: "Create Goal") {
                            showingCreateGoal = true
                        }
                        .frame(width: 200)
                        .padding(.top, 20)
                    }
                } else {
                    // Goal List
                    List {
                        ForEach(goalService.goals) { goal in
                            NavigationLink(destination: GoalChatView(goal: goal)) {
                                HStack(spacing: 16) {
                                    // Goal Icon Placeholder
                                    Circle()
                                        .fill(AppColors.cardBackground)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Text(String(goal.title.prefix(1)).uppercased())
                                                .font(AppFonts.subheader)
                                                .foregroundColor(AppColors.primaryText)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(goal.title)
                                            .font(AppFonts.subheader)
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Text("Target: \(goal.targetDate, formatter: dateFormatter)")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("My Goals", displayMode: .large)
            // Add navigation bar button for when list is populated
            .navigationBarItems(
                trailing: !goalService.goals.isEmpty ? Button(action: {
                    showingCreateGoal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                } : nil
            )
            .sheet(isPresented: $showingCreateGoal) {
                GoalCreationSheet(goalService: goalService)
            }
        }
        .colorScheme(.dark) // Enforce dark navigation bar
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
