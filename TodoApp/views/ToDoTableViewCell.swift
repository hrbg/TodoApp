//
//  ToDoTableViewCell.swift
//  TodoApp
//
//  Created by Hector Bavio on 26/04/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.contentView.backgroundColor = .white        
    }
}
