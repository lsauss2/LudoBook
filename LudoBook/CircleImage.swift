//
//  CircleImage.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        
        layer.cornerRadius = self.frame.width / 2
        
    }

}
