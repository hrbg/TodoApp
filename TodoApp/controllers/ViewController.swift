//
//  ViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 26/04/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let todoItem = TodoItem(title: "foo bar", completed: false, createdAt: Date(), itemIdentifier: UUID())
        
        todoItem.saveItem()
        
        let todos = DataManager.loadAll(TodoItem.self)
        
        print(todos)
    }


}

