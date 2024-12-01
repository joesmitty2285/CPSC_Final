//
//  AddGoalDiolog.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import SwiftUI

struct AddGoalDialog: View {
    @Binding var isPresented: Bool 
    @Binding var selectedGoal: GoalModel?
    @ObservedObject var goalsVM: GoalsViewModel
    
    @State private var goalTitle = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Edit Goal")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Enter goal title", text: $goalTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
                
                if let goal = selectedGoal {
                    Button(action: {
                        if let id = goal.id {
                            // Delete the goal
                            goalsVM.db.collection("goals").document(id).delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error)")
                                } else {
                                    print("Document successfully deleted")
                                }
                            }
                        }
                        goalsVM.goals.removeAll { $0.id == goal.id }
                        isPresented = false
                        goalsVM.fetchGoals()
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                
                Button(action: {
                    if !goalTitle.isEmpty {
                        if let goal = selectedGoal {
                            var updatedGoal = goal
                            updatedGoal.title = goalTitle
                            goalsVM.saveGoal(goal: updatedGoal)
                        } else {
                            let newGoal = GoalModel(title: goalTitle)
                            goalsVM.saveGoal(goal: newGoal)
                        }
                        goalTitle = ""
                        isPresented = false
                        goalsVM.fetchGoals()
                    }
                }) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .onAppear {
                if let goal = selectedGoal {
                    goalTitle = goal.title
                }
            }
        }
    }
}

