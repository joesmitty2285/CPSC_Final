//
//  NoteDetail.swift
//  Notes
//
//  Created by Joseph Smith on 11/17/24.
//

import SwiftUI

struct NoteDetail: View {
    
    @Binding var note: NoteModel
    @StateObject var noteApp = NoteViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Note Title", text: $note.title)
                .font(.system(size: 25))
                .fontWeight(.bold)
            TextEditor(text: $note.notesdata)
                .font(.system(size: 20))
        }.padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        noteApp.saveData(note: note)
                        note.title = ""
                        note.notesdata = ""
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
    }
}

#Preview {
    NoteDetail(note: .constant(NoteModel(title: "one", notesdata: "one note")))
}
