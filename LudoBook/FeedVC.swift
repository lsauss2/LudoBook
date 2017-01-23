//
//  FeedVC.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var imagePickButton: RoundedButton!
    @IBOutlet var postText: RoundedTextField!
    @IBOutlet var postButton: RoundedButton!
    
    
    var postArray = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var hasImage = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    print(snap)
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.postArray.append(post)
                    }
                    
                }
                
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let keychainresult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("LUDO: ID removed from keychain \(keychainresult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? feedCell {
            
            var image: UIImage!
            if let img = FeedVC.imageCache.object(forKey: postArray[indexPath.row].imageUrl as NSString) {
                
                cell.configureCell(post: postArray[indexPath.row], img: img)
                return cell
                
            } else {
                
                cell.configureCell(post: postArray[indexPath.row])
                return cell
            }
            
        } else {
            
            return UITableViewCell()
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickButton.setImage(image, for: .normal)
            hasImage = true
        } else {
            print("LUDO: A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func sendPostTapped(_ sender: Any) {
        
        guard let caption = postText.text, caption != "" else {
            print("LUDO: You need to add a Caption")
            return
        }
        guard let img = imagePickButton.imageView?.image, hasImage == true else {
            print("LUDO: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imageUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POSTS_IMAGE.child(imageUid).put(imgData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print("LUDO: Error uploading image to Firebase")
                } else {
                    print("LUDO: Successfully uploaded image to Firebase Storage")
                    let downloadUrl = metaData.downloadURL()?.absoluteString
                    
                }
                
            }
            
        }
        
    }
    
    
    

}
