//
//  feedCell.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import UIKit
import Firebase

class feedCell: UITableViewCell {
    
    @IBOutlet var feedImage: UIImageView!
    @IBOutlet var userImage: CircleImage!
    @IBOutlet var userName: UILabel!
    @IBOutlet var postMessage: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likesLabel: UILabel!
    
    var likesRef: FIRDatabaseReference!
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        postMessage.text = post.caption
        likesLabel.text = "\(post.likes) likes"
        
        if img != nil {
            
            self.feedImage.image = img
            
        } else {
                
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
                
                if error != nil {
                    
                    print("LUDO: Unable to download image from Firebase Storage")
                    
                } else {
                    
                    if let imgData = data {
                        
                        if let image = UIImage(data: imgData) {
                            
                            self.feedImage.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.likeButton.setImage(UIImage(named: "empty-heart"), for: .normal)
                
            } else {
                self.likeButton.setImage(UIImage(named: "filled-heart"), for: .normal)
            }
            
        })
        
    }
    
    @IBAction func likeButtonTapped(sender: UIButton){
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeButton.setImage(UIImage(named: "filled-heart"), for: .normal)
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeButton.setImage(UIImage(named: "empty-heart"), for: .normal)
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            
        })
    }

}
