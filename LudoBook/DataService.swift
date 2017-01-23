//
//  DataService.swift
//  LudoBook
//
//  Created by Ludo on 22/01/2017.
//  Copyright © 2017 Ludo. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_STORAGE = STORAGE_BASE
    private var _REF_POSTS_IMAGE = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_STORAGE: FIRStorageReference {
        return _REF_STORAGE
    }
    
    var REF_POSTS_IMAGE: FIRStorageReference {
        return _REF_POSTS_IMAGE
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
}
