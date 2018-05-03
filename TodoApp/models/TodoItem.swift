//
//  TodoItem.swift
//  TodoApp
//
//  Created by Hector Bavio on 26/04/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import Foundation
struct TodoItem : Codable  {
    var title:String
    var completed:Bool
    var createdAt:Date
    var itemIdentifier:UUID
    
    func saveItem() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func toggle() {
        self.completed ? markAsIncompleted() : markAsCompleted()
    }
    
    private mutating func markAsCompleted() {
        print(#function)
        self.completed = true
        saveItem()
    }
    
    private mutating func markAsIncompleted() {
        print(#function)
        self.completed = false
        saveItem()
    }
    
}
