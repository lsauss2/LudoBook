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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let keychainresult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("LUDO: ID removed from keychain \(keychainresult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
        
    }
    

}
