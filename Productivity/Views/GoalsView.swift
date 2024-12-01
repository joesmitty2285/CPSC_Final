//
//  GoalsView.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import SwiftUI

struct GoalsView: View {
    @StateObject var goalsVM = GoalsViewModel()
    @State private var isShowingGoalDialog = false
    @State private var selectedGoal: GoalModel?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(goalsVM.goals) { goal in
                    Button(action: {
                        selectedGoal = goal
                        isShowingGoalDialog = true
                    }) {
                        Text(goal.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
                .onDelete(perform: deleteGoals) 
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedGoal = nil
                        isShowingGoalDialog = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                goalsVM.fetchGoals()
            }
            .sheet(isPresented: $isShowingGoalDialog) {
                AddGoalDialog(
                    isPresented: $isShowingGoalDialog,
                    selectedGoal: $selectedGoal,
                    goalsVM: goalsVM
                )
            }
        }
    }
    
    // delete goals
    func deleteGoals(at offsets: IndexSet) {
        offsets.forEach { index in
            let goalToDelete = goalsVM.goals[index]
            if let id = goalToDelete.id {
                goalsVM.db.collection("goals").document(id).delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document successfully deleted")
                    }
                }
            }
        }
        goalsVM.goals.remove(atOffsets: offsets)
    }
}



#Preview {
    GoalsView()
}
