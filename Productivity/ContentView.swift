import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var noteApp = NoteViewModel()
    @StateObject var taskVM = TaskViewModel()
    
    @State var note = NoteModel(title: "", notesdata: "")
    @State var isSignedIn = Auth.auth().currentUser != nil
    
    var body: some View {
        if isSignedIn {
            TabView {
                // Notes Section
                NavigationStack {
                    VStack {
                        List {
                            ForEach($noteApp.notes) { $note in
                                NavigationLink {
                                    NoteDetail(note: $note)
                                } label: {
                                    Text(note.title)
                                }
                            }
                            .onDelete(perform: deleteNotes)
                            
                            Section {
                                NavigationLink {
                                    NoteDetail(note: $note)
                                } label: {
                                    Text("New Note")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                        .onAppear {
                            noteApp.fetchhData()
                        }
                        .refreshable {
                            noteApp.fetchhData()
                        }
                    }
                    .navigationTitle("Notes")
                }
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                
                // Tasks Section
                NavigationStack {
                    TaskView()
                        .navigationTitle("Tasks")
                }
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
                
                // Quotes Section
                NavigationStack {
                    QuoteView()
                        .navigationTitle("Motivation")
                }
                .tabItem {
                    Label("Quotes", systemImage: "quote.bubble")
                }
                
                // Goals Section
                NavigationStack {
                    GoalsView()
                        .navigationTitle("Goals")
                }
                .tabItem {
                    Label("Goals", systemImage: "star")
                }
                NavigationStack {
                    SettingsView()
                        .navigationTitle("Settings")
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            isSignedIn = false
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
            }
        } else {
            AuthView() // Redirect to authentication view if not signed in
        }
    }
    
    // delete notes
    func deleteNotes(at offsets: IndexSet) {
        offsets.forEach { index in
            let noteToDelete = noteApp.notes[index]
            if let id = noteToDelete.id {
                // Delete from Firestore
                noteApp.db.collection("notes").document(id).delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document successfully deleted")
                    }
                }
            }
        }
        noteApp.notes.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
