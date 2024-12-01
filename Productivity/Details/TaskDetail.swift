import SwiftUI

struct TaskDetail: View {
    
    @Binding var task: TaskModel
    @StateObject var taskVM = TaskViewModel() 
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Task Title", text: $task.title)
                .font(.system(size: 25))
                .fontWeight(.bold)
            
            Toggle("Completed", isOn: $task.isCompleted)
                .font(.system(size: 18))
                .padding(.bottom)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    taskVM.saveTask(task: task)
                    task.title = ""
                    task.isCompleted = false
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

#Preview {
    TaskDetail(task: .constant(TaskModel(title: "Task Title", isCompleted: false)))
}
