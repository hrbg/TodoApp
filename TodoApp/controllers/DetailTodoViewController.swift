//
//  DetailTodoViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 02/05/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

protocol UpdatingTodoItemDelegate {
    func didMarkAsCompleted(at indexPath: IndexPath)
    func didChangeTodo(title:String, at indexPath: IndexPath)
}

class DetailTodoViewController: UIViewController {
    
    var todoItem: TodoItem!
    var todoItemDelegate: UpdatingTodoItemDelegate?
    var indexPath: IndexPath!

    lazy var todoItemTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor   = .white
        textField.setLeftPaddingPoints(10)
        textField.text = self.todoItem.title
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let completedTodoLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todoAttributesView: UIView = {
        let uiView = UIView() //frame: CGRect(x: 100, y: 200, width: self.view.bounds.width, height: 50))
        uiView.backgroundColor = .white
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var completedTodoItemSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.setOn(todoItem.completed, animated: false)
        return uiSwitch
    }()
    
    let attributesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment    = UIStackViewAlignment.center
        stackView.spacing      = 200
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(named: "detailGrayColor")
        setupViews()
    }
    
    func setupViews() {
        print(#function)
        attributesStackView.addArrangedSubview(completedTodoLabel)
        attributesStackView.addArrangedSubview(completedTodoItemSwitch)
        todoAttributesView.addSubview(attributesStackView)
        
        view.addSubview(todoItemTextField)
        view.addSubview(todoAttributesView)
        
        todoItemTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 125).isActive = true
        todoItemTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        todoItemTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        todoItemTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

        todoAttributesView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        todoAttributesView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        todoAttributesView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        todoAttributesView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        attributesStackView.topAnchor.constraint(equalTo: todoAttributesView.topAnchor, constant: 25).isActive = true
        attributesStackView.centerYAnchor.constraint(equalTo: todoAttributesView.centerYAnchor).isActive = true
        attributesStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    @objc fileprivate func switchChanged() {
        print(#function)
        todoItemDelegate?.didMarkAsCompleted(at: indexPath)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
