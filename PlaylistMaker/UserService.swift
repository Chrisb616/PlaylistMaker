//
//  UserService.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class UserService {
    static let instance = UserService()
    private init () {}
    
    var user: User?
    
    func loadInformationFor(username: String, completion: @escaping (User?)->()) {
        APIClient.instance.getInfoFor(username: username) { (response, errorString) in
            if let errorString = errorString {
                print(errorString)
            }
            
            guard let response = response else {
                completion(nil)
                return
            }
            
            self.user = response.user
            
            completion(response.user)
        }
    }
    
    func clearUserInfo() {
        user = nil
    }
    
    private var _storedUsernames = [String]()
    
    func save(username: String) {
        _storedUsernames.append(username)
        UserDefaults.standard.set(_storedUsernames,forKey: "storedUsernames")
    }
    
    func retrieveStoredUsernames() -> [String] {
        if let usernames = UserDefaults.standard.array(forKey: "storedUsernames") as? [String] {
            _storedUsernames = usernames
            return usernames
        } else {
            return []
        }
    }
}
