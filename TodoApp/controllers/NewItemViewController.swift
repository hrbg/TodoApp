//
//  NewItemViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 14/05/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
   
    var todoItemDelegate: UpdatingTodoItemDelegate?
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("ｘ", for: .normal)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        return button
    }()
    
    let newItemTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(newItemTextField)
        self.view.addSubview(doneButton)
        self.view.addSubview(dismissButon)

        let guide = view.safeAreaLayoutGuide
        newItemTextField.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        newItemTextField.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        newItemTextField.heightAnchor.constraint(equalToConstant: 200).isActive = true

        doneButton.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        doneButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true

        dismissButon.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        dismissButon.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dismissButon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dismissButon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

    @objc func dismissScreen() {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(){
        print(#function)
        todoItemDelegate?.addedNewItem(with: newItemTextField.text)
        dismiss(animated: true, completion: nil)
    }

}
