//
//  feedCell.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import UIKit

class feedCell: UITableViewCell {
    
    @IBOutlet var feedImage: UIImageView!
    @IBOutlet var userImage: CircleImage!
    @IBOutlet var userName: UILabel!
    @IBOutlet var postMessage: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likesLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
