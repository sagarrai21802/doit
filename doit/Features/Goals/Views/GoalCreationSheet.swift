import SwiftUI

struct GoalCreationSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var goalService: GoalService
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var targetDate: Date = Date().addingTimeInterval(86400 * 30) // Default 30 days
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal Title")
                                .font(AppFonts.subheader)
                                .foregroundColor(AppColors.primaryText)
                            OnboardingInputField(placeholder: "e.g. Learn Python", text: $title)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(AppFonts.subheader)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $description)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                                .frame(height: 120)
                                .padding()
                                .background(AppColors.secondaryBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.border, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target Date")
                                .font(AppFonts.subheader)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.bottom, 4)
                            
                            DatePicker("Select Date", selection: $targetDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .colorScheme(.dark)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(AppColors.secondaryText),
                trailing: Button("Create") {
                    if !title.isEmpty && !description.isEmpty {
                        goalService.addGoal(title: title, description: description, targetDate: targetDate)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .foregroundColor(AppColors.accent)
                .disabled(title.isEmpty || description.isEmpty)
            )
        }
        .colorScheme(.dark) // Enforce dark mode for standard components
    }
}
