//
//  RoundedTextField.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        self.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        
    }
    
    

}
