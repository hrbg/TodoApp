////
////  DetailView.swift
////  TodoApp
////
////  Created by Hector Bavio on 02/05/2018.
////  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
////
//
//import UIKit
//
//class DetailView: UIView {
//    
//    
//    let todoItemTextField: UITextField = {
//        let textField = UITextField()
//        
//        return textField
//    }()
//    
//    func setupViews() {
//        addSubview(todoItemTextField)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: todoItemTextField)
//        addConstraintsWithFormat(format: "V:|-8-[v0(10)]|", views: todoItemTextField)
//    }
//}
//
//extension UIView {
//    func addConstraintsWithFormat(format: String, views: UIView...) {
//        var viewsDictionary = [String: UIView]()
//        for (index, view) in views.enumerated() {
//            let key = "v\(index)"
//            view.translatesAutoresizingMaskIntoConstraints = false
//            viewsDictionary[key] = view
//        }
//        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
//    }
//}

