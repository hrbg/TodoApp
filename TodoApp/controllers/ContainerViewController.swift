//
//  ContainerViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 30/04/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var todoTableViewController: ToDoTableViewController!
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addNewTodoItem(_ sender: UIButton) {
        todoTableViewController.addNewTodo()
    }
    
    @IBAction func triggerConnection(_ sender: UIButton) {
        todoTableViewController.showConnectivityAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoSegue" {
            todoTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! ToDoTableViewController
            todoTableViewController.connectionButtonReference = connectionButton
        }
    }

}
