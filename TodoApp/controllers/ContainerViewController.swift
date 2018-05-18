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
        bounce(sender)
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
    
    func bounce(_ sender: UIButton) {
        print(#function)
        sender.transform = sender.transform.scaledBy(x: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
                        sender.transform = .identity
        },
                       completion: nil)
    }

}
