import Foundation
import FirebaseCore
import FirebaseFirestore

class TaskViewModel: ObservableObject {
    
    @Published var tasks = [TaskModel]() 
    let db = Firestore.firestore()
    
    func fetchTasks() {
        self.tasks.removeAll()
        db.collection("tasks")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            self.tasks.append(try document.data(as: TaskModel.self))
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    func saveTask(task: TaskModel) {
        guard !task.title.isEmpty else {
            print("Task title is empty. Aborting save.")
            return
        }
        
        if let id = task.id {
            // Update existing task
            let docRef = db.collection("tasks").document(id)
            docRef.updateData([
                "title": task.title,
                "isCompleted": task.isCompleted
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } else {
            // Create a new task
            var ref: DocumentReference? = nil
            ref = db.collection("tasks").addDocument(data: [
                "title": task.title,
                "isCompleted": task.isCompleted
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

