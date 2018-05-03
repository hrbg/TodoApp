//
//  DetailTodoViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 02/05/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

protocol UpdatingTodoItemDelegate {
    func didChangeTodo(title:String, at indexPath: IndexPath)
}

class DetailTodoViewController: UIViewController {
    
    var todoItem: TodoItem!
    var todoItemDelegate: UpdatingTodoItemDelegate?
    var indexPath: IndexPath!

    lazy var todoItemTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor   = .lightGray
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.text = self.todoItem.title
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let completedTodoItemSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do"
        navigationItem.largeTitleDisplayMode = .never
        setupViews()
    }
    
    func setupViews() {
        print(#function)
        view.addSubview(todoItemTextField)
        view.addSubview(completedTodoItemSwitch)

        todoItemTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        todoItemTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        todoItemTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        todoItemTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        completedTodoItemSwitch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        completedTodoItemSwitch.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        print(#function)
        guard let text = todoItemTextField.text else {
            return
        }
        todoItemDelegate?.didChangeTodo(title: text, at: indexPath)
        navigationController?.popViewController(animated: true)
    }
}
