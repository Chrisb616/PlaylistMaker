 //
//  APIClient.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/28/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class APIClient {
    
    private init() {}
    static let instance = APIClient()
    
    private let lastFmUrl = "https://ws.audioscrobbler.com/2.0/"
    
    let recentTracksMethod = "user.getrecenttracks"
    
    private func urlRequest(httpMethod: String, apiMethod: String, params: [String:String]) -> URLRequest? {
        guard let url = URL(string: lastFmUrl) else {
            print("FAILURE: Could not create URL from base url string")
            return nil
        }
        
        var paramString = "method=\(apiMethod)"
        
        for param in params {
            paramString += "&\(param.key)=\(param.value)"
        }
        
        print("Request Endpoint: \(url.absoluteString + paramString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = paramString.data(using: .utf8)
        
        return request
    }
    
    
    func getRecentTracksfrom(_ startDate: Date, to endDate: Date, completion: @escaping ([RecentTracksResponse],String?)->()) {
        getRecentTracksRecursive(startDate, to: endDate, currentPage: 1, progress: []) { (responses, errorString) in
            completion(responses,errorString)
        }
    }
    
    /**
     Completes a data task for the request. Completion handles response data, error string.
     */
    private func getRecentTracksRecursive(_ startDate: Date, to endDate: Date, currentPage: Int, progress: [RecentTracksResponse], completion: @escaping ([RecentTracksResponse],String?)->()) {
        let params = [
            "user":"chrisb616",
            "api_key":Keys.apiKey,
            "format":"json",
            "limit":"200",
            "from":"\(Int(startDate.timeIntervalSince1970))",
            "to":"\(Int(endDate.timeIntervalSince1970))",
            "page":"\(currentPage)"
        ]
        
        guard let request = urlRequest(httpMethod: "POST", apiMethod: recentTracksMethod, params: params) else {
            completion(progress, "FAILURE: Could not create url request for page 1.")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
        
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                completion(progress, "FAILURE: Could not retrieve data from URL.")
                return
            }
            
            do {
                
                let recentTracksResponse = try JSONDecoder().decode(RecentTracksResponse.self, from: data)
                var newProgress = [RecentTracksResponse]()
                newProgress.append(recentTracksResponse)
                
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:[String:Any]] else {
                    completion(progress,"Could not convert JSON into dictionary")
                    return
                }
                
                guard let recentTracks = dict["recenttracks"] else {
                    completion(progress,"No tag 'recenttracks' inside of dictionary object")
                    return
                }
                
                guard let attr = recentTracks["@attr"] as? [String:String] else {
                    completion(progress,"No tag '@attr' inside of recenttracks dictionary")
                    return
                }
                
                guard let totalPagesObject = attr["totalPages"] else {
                    completion(progress,"No tag 'totalPages' inside of attr dictionary")
                    return
                }
                
                guard let totalPages = Int(totalPagesObject) else {
                    completion(progress,"Object 'totalPages' cannot be cast to Int")
                    return
                }
                
                if (totalPages == 0) {
                    completion(progress,"No tracks found for date")
                    return
                }
                
                print("\(currentPage)/\(totalPages)")
                
                if (totalPages == currentPage) {
                    completion(newProgress, nil)
                } else {
                    self.getRecentTracksRecursive(startDate, to: endDate, currentPage: currentPage + 1, progress: newProgress) { (finalProgress, nil) in
                        completion(newProgress, nil)
                    }
                }
                
            } catch {
                completion(progress, error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
