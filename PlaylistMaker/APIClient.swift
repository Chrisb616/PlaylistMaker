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
        guard var url = URL(string: lastFmUrl) else {
            print("FAILURE: Could not create URL from base url string")
            return nil
        }
        
        var paramString = "method=\(apiMethod)"
        
        for param in params {
            paramString += "&\(param.key)=\(param.value)"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = paramString.data(using: .utf8)
        
        return request
    }
    
    
    func getRecentTracksfrom(_ startDate: Date, to endDate: Date, completion: @escaping (RecentTracksResponse?,String)->()) {
        
        let params = [
            "user":"chrisb616",
            "api_key":Keys.apiKey,
            "format":"json",
            "limit":"200",
            "from":"\(startDate.timeIntervalSince1970)",
            "to":"\(endDate.timeIntervalSince1970)"
        ]
        
        guard let request = urlRequest(httpMethod: "POST", apiMethod: recentTracksMethod, params: params) else {
            completion(nil, "FAILURE: Could not create url request.")
            return
        }
        
        paginatedRequest(request: request) { (data, errorString, success) in
            guard let data = data else {
                if let errorString = errorString {
                    completion(nil, errorString)
                } else {
                    completion(nil, "FAILURE: Could not retrieve data from URL.")
                }
                return
            }
            
            do {
                
                let recentTracksResponse = try JSONDecoder().decode(RecentTracksResponse.self, from: data)
                let string = String(data: data, encoding: .utf8)
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String:[String:Any]]
                let recentTracks = dict["recenttracks"]!
                let attr = recentTracks["@attr"] as! [String:Any]
                print(attr)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Completes a data task for the request. Completion handles response data, error string, and a boolean for success.
     */
    private func paginatedRequest(request: URLRequest, completion: @escaping (Data?,String?,Bool)->()) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
        
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                completion(nil, "FAILURE: Could not retrieve data from URL.", true)
                return
            }
            
            completion(data, nil, true)
        }
        
        task.resume()
    }
}
