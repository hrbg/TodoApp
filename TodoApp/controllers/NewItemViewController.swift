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
        button.backgroundColor = UIColor(named: "mainBlueColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(bounce(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButon: UIButton = {
        let button = UIButton()
        let mainRed = UIColor(named: "mainRedColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(mainRed, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth  = 2
        button.layer.borderColor  = mainRed?.cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        return button
    }()
    
    let newItemTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(newItemTextField)
        self.view.addSubview(doneButton)
        self.view.addSubview(dismissButon)
        
        let guide = view.safeAreaLayoutGuide
        newItemTextField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 50).isActive = true
        newItemTextField.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        newItemTextField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        doneButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        dismissButon.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        dismissButon.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -16).isActive = true
        dismissButon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dismissButon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    @objc func dismissScreen() {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(){
        print(#function)
        todoItemDelegate?.addedNewItem(with: newItemTextField.text)
    }
    
    @objc func bounce(sender: UIButton) {
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
                       completion: {(completed: Bool) in
                        self.dismiss(animated: true, completion: nil)
        })
    }
    
}
