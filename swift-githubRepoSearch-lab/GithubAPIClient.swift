//
//  GithubAPIClient.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GithubAPIClient {
    
    static let sharedInstance = GithubAPIClient()
    
    let GH_REPO_SEARCH_URL = "https://api.github.com/search/repositories?q="
    let GH_REPO_STARRED_URL = "https://api.github.com/user/starred/"
    
    let parameters = [
        "client_id" : GH_CLIENT_ID,
        "client_secret" : GH_CLIENT_SECRET
    ]
    
    func searchForRepository(name: String, completion: ([GithubRepository]) -> ()) {
        let query = name.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = GH_REPO_SEARCH_URL + query
        
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                var repositories: [GithubRepository] = []
                
                for item in json["items"] {
                    repositories.append(GithubRepository(item: item.1))
                }
                
                completion(repositories)
                
            } else {
                print("Error fetching repositories matching '\(name)'")
            }
        }
    }
    
    func repositoryIsStarred(name: String, completion: (starred: Bool) -> ()) {
        let url = GH_REPO_STARRED_URL + name
        let headers = ["Authorization" : GH_TOKEN]
        
        Alamofire.request(.GET, url, headers: headers).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                completion(starred: true)
            } else {
                completion(starred: false)
            }
        }
    }
    
    func starRepository(name: String, completion: () -> ()) {
        let url = GH_REPO_STARRED_URL + name
        let headers = ["Authorization" : GH_TOKEN]
        
        Alamofire.request(.PUT, url, headers: headers).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                completion()
            } else {
                print(response.response?.statusCode)
            }
        }
    }
    
    func unstarRepository(name: String, completion: () -> ()) {
        let url = GH_REPO_STARRED_URL + name
        let headers = ["Authorization" : GH_TOKEN]
        
        Alamofire.request(.DELETE, url, headers: headers).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                completion()
            } else {
                print(response.response?.statusCode)
            }
        }
    }
}