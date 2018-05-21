//
//  SearchFilterViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 18/05/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

class SearFilterViewController: UIViewController {
    // MARK: Dismiss Button
    lazy var dismissButon: UIButton = {
        let button      = UIButton()
        let mainRed     = UIColor(named: "mainRedColor")
        let cancelImage = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = mainRed
        button.setImage(cancelImage, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(mainRed, for: .normal)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        setupViews()
    }
    
    fileprivate func setupViews() {
        self.view.addSubview(dismissButon)
        
        let guide = view.safeAreaLayoutGuide
        dismissButon.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        dismissButon.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        dismissButon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dismissButon.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
}
