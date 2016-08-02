//
//  ReposDataStore.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    
    let api = GithubAPIClient.sharedInstance
    var repositories:[GithubRepository] = []
    
    func searchForRepository(name: String, completion: () -> ()) {
        api.searchForRepository(name) { (repositories) in
            self.repositories = repositories
            completion()
        }
    }
}
