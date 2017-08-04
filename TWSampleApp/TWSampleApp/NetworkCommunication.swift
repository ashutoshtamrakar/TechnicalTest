//
//  NetworkCommunication.swift
//  TWSampleApp
//
//  Created by apple on 8/2/17.
//  Copyright © 2017 teamwork. All rights reserved.
//

import Foundation


struct NetworkCommunication {
    
    // URL String
    let URLString = "https://yat.teamwork.com/projects.json"
    
    
    public func authenticateUser(username un: String, password pw: String) {
        
        let loginData = String(format: "%@:%@", un, pw).data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        networkService(requestFor: "UserAuthentication", withHTTPMethod: "GET", info:base64LoginString)
    }
    
    
    public func getProjects(withStatus status: String) {
        
        networkService(requestFor: status, withHTTPMethod: "GET", info: nil)
    }
    
    
    private func networkService(requestFor: String, withHTTPMethod: String, info: String?) {
        
        var newURLString: String?
        
        if requestFor == "UserAuthentication" {
            newURLString = URLString
        } else {
            newURLString =  URLString.appending("?status=\(requestFor)")
        }
        
        // URL Request
        var urlRequest = URLRequest(url: URL(string: newURLString!)!)
        if let information = info {
            urlRequest.setValue("Basic \(information)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpMethod = withHTTPMethod
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-type")
        
        // Set up the URL Session
        let urlSessionconfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlSessionconfig)
        
        // URLSessionDataTask variable to make HTTP GET Request
        _ = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                var dictionary: [String: Any] = [:]
                var notificationName: String? = "UserAuthentication"
                
                if (httpResponse.statusCode == 200) {
                    if requestFor == "UserAuthentication" {
                       notificationName = "UserAuthentication"
                       dictionary = [notificationName!: true]
                        
                    } else {
                        
                        do {
                            notificationName = "Projects"
                            if let jsonData = data,
                                let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                                let projectsDic = json["projects"] as? [[String: Any]] {
                                for project in projectsDic {
                                    if let projectName = (project["name"] as? String) {
                                        dictionary[projectName] = project
                                    }
                                }
                            }
                        } catch {
                            print("Error deserializing JSON: \(error)")
                        }
                    }
                } else {
                    if requestFor == "UserAuthentication" {
                        notificationName = "UserAuthentication"
                        dictionary = [notificationName!: false]
                        
                    } else {
                        
                        //TODO
                    }
                }
                //TODO: Error Handling
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName!), object: nil, userInfo: dictionary)
            }
        }.resume()
    }
}
