//
//  DetailTodoViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 02/05/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

class DetailTodoViewController: UIViewController {
    
    var todoItem: TodoItem!
    var todoItemDelegate: UpdatingTodoItemDelegate?
    var indexPath: IndexPath!

    lazy var todoItemTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor   = .white
        textField.setLeftPaddingPoints(10)
        textField.text = self.todoItem.title
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    
    let completedTodoLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todoAttributesView: UIView = {
        let uiView = UIView()
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
    
    // MARK: viewDidLoad
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
    
    // MARK: - Target functions
    @objc fileprivate func addTapped() {
        guard let text = todoItemTextField.text else {
            return
        }
        todoItemDelegate?.didChangeTodo(title: text, at: indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func switchChanged() {
        todoItemDelegate?.didMarkAsCompleted(at: indexPath)
    }
    
    @objc fileprivate func textFieldChanged() {
        if todoItemTextField.text?.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

//MARK: - TextFieldDelegate
extension DetailTodoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 140
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
