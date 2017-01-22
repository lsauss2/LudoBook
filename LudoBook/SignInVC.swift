//
//  ViewController.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet var emailTextField: RoundedTextField!
    @IBOutlet var passwordTextField: RoundedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: self)
        }
    }
    

    @IBAction func FacebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("LUDO: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("LUDO: User cancelled facebook authentication")
            } else {
                print("LUDO: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential: credential)
            }
            
        }
        
    }
    
    func firebaseAuth(credential: FIRAuthCredential){
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("LUDO: Impossible to authenticate with Firebase: \(error.debugDescription)")
            } else {
                print("LUDO: Successfully authenticated with Firebase")
                if let user = user {
                self.completeSignIn(id: user.uid)
                }
            }
            
        })
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    
                    print("LUDO: Successfully signed in with Email and Password")
                    self.completeSignIn(id: user!.uid)
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("LUDO: There as been a problem creating a user: \(error.debugDescription)")
                        } else {
                            print("LUDO: Successfully creating a user")
                            self.completeSignIn(id: user!.uid)
                            
                        }
                        
                    })
                    
                }
                
            })
            
        }
        
    }
    
    func completeSignIn(id: String){
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("LUDO: Successfully saving the UID in the KeyChain")
        performSegue(withIdentifier: "goToFeed", sender: self)
        
    }
    

}

