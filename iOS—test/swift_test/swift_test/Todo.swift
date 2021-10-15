//
//  Todo.swift
//  Swift_test
//
//  Created by gary on 2021/9/1.
//

import Foundation

class Todo {
    var id: UInt?
    var title: String
    var completed: Bool
    
    init(id: UInt, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    required init?(json: [String: Any]) {
        guard let todoId = json["id"] as? UInt,
              let title = json["title"] as? String,
              let completed = json["completed"] as? Bool else {
            return nil
         }
        self.id = todoId
        self.title = title
        self.completed = completed
    }
}

extension Todo: CustomStringConvertible {
    var description: String {
        return  "ID: \(self.id ?? 0), " +
            "title: \(self.title), " +
            "completed: \(self.completed)"
    }
}
