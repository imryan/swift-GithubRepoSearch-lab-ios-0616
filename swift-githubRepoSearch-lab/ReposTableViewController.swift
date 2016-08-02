//
//  ReposTableViewController.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    let api = GithubAPIClient.sharedInstance
    
    var repositories: [GithubRepository] = []
    
    // MARK: - Functions
    
    @IBAction func search() {
        let alertController = UIAlertController(title: "Search", message: "Search GitHub repositories", preferredStyle: .Alert)
        let searchAction = UIAlertAction(title: "Search", style: .Default) { (action) in
            let textField = alertController.textFields![0]
            
            if let text = textField.text {
                self.store.searchForRepository(text, completion: {
                    self.repositories = self.store.repositories
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                })
            }
            
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Repository"
        }
        
        alertController.addAction(searchAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "Repositories", message: message, preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(dismiss)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Table
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repositories"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
         let repo = repositories[indexPath.row]
         cell.textLabel?.text = repo.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let repo = repositories[indexPath.row]
        
        api.repositoryIsStarred(repo.name) { (starred) in
            if starred {
                self.api.unstarRepository(repo.name, completion: {
                    cell?.accessoryType = .None
                    self.alert("Unstarred \(repo.name)")
                })
            } else {
                self.api.starRepository(repo.name, completion: {
                    cell?.accessoryType = .Checkmark
                    self.alert("Starred \(repo.name)")
                })
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
