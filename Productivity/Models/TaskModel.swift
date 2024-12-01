//
//  TaskModel.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import Foundation
import FirebaseFirestore

struct TaskModel: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var isCompleted: Bool
    
    }
