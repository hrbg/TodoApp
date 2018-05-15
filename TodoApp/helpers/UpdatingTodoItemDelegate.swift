//
//  UpdatingTodoItemDelegate.swift
//  TodoApp
//
//  Created by Hector Bavio on 15/05/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import Foundation
protocol UpdatingTodoItemDelegate {
    func addedNewItem(with title: String)
    func didMarkAsCompleted(at indexPath: IndexPath)
    func didChangeTodo(title:String, at indexPath: IndexPath)
}
