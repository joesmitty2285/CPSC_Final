//
//  TasksView.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//
import SwiftUI

struct TaskView: View {
    @StateObject var taskVM = TaskViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($taskVM.tasks) { $task in
                    HStack {
                        TextField("Task Title", text: $task.title)
                            .font(.headline)
                            .strikethrough(task.isCompleted, color: .gray)
                            .onChange(of: task.title) { _ in
                                taskVM.saveTask(task: task) 
                            }
                        Spacer()
                        Toggle("", isOn: $task.isCompleted)
                            .labelsHidden()
                            .onChange(of: task.isCompleted) { _ in
                                taskVM.saveTask(task: task)
                            }
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newTask = TaskModel(title: "New Task", isCompleted: false)
                        taskVM.tasks.append(newTask)
                        taskVM.saveTask(task: newTask)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                taskVM.fetchTasks()
            }
            .refreshable {
                taskVM.fetchTasks()
            }
        }
    }
    
    // delete tasks
    func deleteTasks(at offsets: IndexSet) {
        offsets.forEach { index in
            let taskToDelete = taskVM.tasks[index]
            if let id = taskToDelete.id {
                // Delete from Firestore
                taskVM.db.collection("tasks").document(id).delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document successfully deleted")
                    }
                }
            }
        }
        // Remove from the local array
        taskVM.tasks.remove(atOffsets: offsets)
    }
}
