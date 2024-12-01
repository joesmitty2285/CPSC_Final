//
//  GoalsViewModel.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class GoalsViewModel: ObservableObject {
    
    @Published var goals = [GoalModel]() 
    let db = Firestore.firestore()
    
    func fetchGoals() {
        self.goals.removeAll()
        db.collection("goals")
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            self.goals.append(try document.data(as: GoalModel.self))
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    func saveGoal(goal: GoalModel) {
        guard !goal.title.isEmpty else {
            print("Goal title is empty. Aborting save.")
            return
        }
        
        if let id = goal.id {
            // Update existing goal
            let docRef = db.collection("goals").document(id)
            docRef.updateData([
                "title": goal.title
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } else {
            // Create a new goal
            var ref: DocumentReference? = nil
            ref = db.collection("goals").addDocument(data: [
                "title": goal.title
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
}

