//
//  NoteModel.swift
//  Notes
//
//  Created by Joseph Smith on 11/17/24.
//

import Foundation
import FirebaseFirestore

struct NoteModel : Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var notesdata: String
}
