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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

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
        
        let post = postArray[indexPath.row]
        print("\(post.caption)")
        
        return tableView.dequeueReusableCell(withIdentifier: "feedCell") as! feedCell
    }
    
    
    

}
