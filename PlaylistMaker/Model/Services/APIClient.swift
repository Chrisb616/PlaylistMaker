 //
//  APIClient.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/28/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class APIClient {
    
    private init() {}
    static let instance = APIClient()
    
    private let lastFmUrl = "https://ws.audioscrobbler.com/2.0/"
    
    let recentTracksMethod = "user.getrecenttracks"
    let getUserInfoMethod = "user.getinfo"
    
    private func urlRequest(httpMethod: String, apiMethod: String, params: [String:String]) -> URLRequest? {
        guard let url = URL(string: lastFmUrl) else {
            print("FAILURE: Could not create URL from base url string")
            return nil
        }
        
        var paramString = "method=\(apiMethod)"
        
        for param in params {
            paramString += "&\(param.key)=\(param.value)"
        }
        
        print("Request Endpoint: \(url.absoluteString + "?" + paramString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = paramString.data(using: .utf8)
        
        return request
    }
    
    func getImage(fromUrlString urlString: String, completion: @escaping (UIImage?, CBError?)->()) {
        guard let url = URL(string: urlString) else {
            let error = CBError(debugString: "Could not create url with string: \(urlString)", userDisplayString: "There was a problem loading this image.")
            completion(nil, error)
            return
        }
        
        let session = URLSession.shared
    
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                let error = CBError(debugString: "No data recieved from url \(urlString)", userDisplayString: "There was a problem loading this image.")
                completion(nil, error)
                return
            }
            
            let image = UIImage(data: data)
            
            completion(image, nil)
        }
        
        task.resume()
    }
    
    func getInfoFor(username: String, completion: @escaping (UserInfoResponse?, CBError?)-> ()) {
        let params = [
            "user":username,
            "format":"json",
            "api_key":Keys.apiKey
        ]
        
        guard let request = urlRequest(httpMethod: "POST", apiMethod: getUserInfoMethod, params: params) else {
            let error = CBError(debugString: "Could not create url request for User Info for \(username)", userDisplayString: "There was a problem loading info for \(username)")
            completion(nil, error)
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                let error = CBError(debugString: "No data recieved from request for user info for \(username)", userDisplayString: "There was a problem loading info for \(username)")
                completion(nil, error)
                return
            }
            
            do {
                let userInfoResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                completion(userInfoResponse, nil)
            }
            catch {
                var cbError = CBError(debugString: error.localizedDescription, userDisplayString: "There was a problem loading info for \(username)")
                cbError.swiftError = error
                completion(nil, cbError)
            }
        }
        
        task.resume()
    }
    
    func getRecentTracksfrom(_ startDate: Date, to endDate: Date, username: String, completion: @escaping ([RecentTracksResponse],CBError?)->()) {
        getRecentTracksRecursive(startDate, to: endDate, username: username, currentPage: 1, progress: []) { (responses, error) in
            completion(responses,error)
        }
    }
    
    /**
     Completes a data task for the request. Completion handles response data, error string.
     */
    private func getRecentTracksRecursive(_ startDate: Date, to endDate: Date, username: String, currentPage: Int, progress: [RecentTracksResponse], completion: @escaping ([RecentTracksResponse],CBError?)->()) {
        let params = [
            "user":username,
            "api_key":Keys.apiKey,
            "format":"json",
            "limit":"200",
            "from":"\(Int(startDate.timeIntervalSince1970))",
            "to":"\(Int(endDate.timeIntervalSince1970))",
            "page":"\(currentPage)"
        ]
        
        guard let request = urlRequest(httpMethod: "POST", apiMethod: recentTracksMethod, params: params) else {
            let cbError = CBError(debugString: "Could not create url request for page \(currentPage)", userDisplayString: "There was a problem loading tracks for this user.")
            completion(progress, cbError)
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
        
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                let cbError = CBError(debugString: "No data recieved from recent   \(currentPage)", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                completion(progress, cbError)
                return
            }
            
            do {
                
                let recentTracksResponse = try JSONDecoder().decode(RecentTracksResponse.self, from: data)
                var newProgress = progress
                newProgress.append(recentTracksResponse)
                
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:[String:Any]] else {
                    let cbError = CBError(debugString: "Could not convert JSON into dictionary", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                    completion(progress,cbError)
                    return
                }
                
                guard let recentTracks = dict["recenttracks"] else {
                    let cbError = CBError(debugString: "No tag 'recenttracks' inside of dictionary object", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                    completion(progress,cbError)
                    return
                }
                
                guard let attr = recentTracks["@attr"] as? [String:String] else {
                    let cbError = CBError(debugString: "No tag '@attr' inside of dictionary object", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                    completion(progress,cbError)
                    return
                }
                
                guard let totalPagesObject = attr["totalPages"] else {
                    let cbError = CBError(debugString: "No tag 'totalPages' inside of dictionary object", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                    completion(progress,cbError)
                    return
                }
                
                guard let totalPages = Int(totalPagesObject) else {
                    let cbError = CBError(debugString: "Object 'totalPages' cannot be cast to Int", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                    completion(progress,cbError)
                    return
                }
                
                if (totalPages == 0) {
                    let cbError = CBError(debugString: "Total track pages is 0", userDisplayString: "No tracks found for this user.", swiftError: error)
                    completion(progress,cbError)
                    return
                }
                
                print("\(currentPage)/\(totalPages)")
                
                if (totalPages == currentPage) {
                    completion(newProgress, nil)
                } else {
                    self.getRecentTracksRecursive(startDate, to: endDate, username: username, currentPage: currentPage + 1, progress: newProgress) { (finalProgress, nil) in
                        completion(finalProgress, nil)
                    }
                }
                
            } catch {
                let cbError = CBError(debugString: "Exception in json data handling", userDisplayString: "There was a problem loading tracks for this user.", swiftError: error)
                completion(progress,cbError)
            }
        }
        
        task.resume()
    }
}
