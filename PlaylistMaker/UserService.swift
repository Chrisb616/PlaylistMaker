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
}
