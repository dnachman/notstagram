//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by David Nachman on 8/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var usernames = [""]
    var userids = [""]
    var isFollowing = ["":false]
    var refresher: UIRefreshControl!
    
    func refresh() {
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if let users = objects {
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                for object in users {
                    if let user = object as? PFUser {
                        if user.objectId != PFUser.currentUser()?.objectId {
                            // don't add currenlty logged in user to arrays
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
                            // see if they're followed by the current user
                            let query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                                
                                if objects != nil {
                                    if objects!.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    }
                                    else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                
                                // need this here since async call
                                if self.isFollowing.count == self.userids.count {
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                }
                            })
                        }
                    }
                }
            }
            
        })

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        refresh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        if self.isFollowing[userids[indexPath.row]] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if self.isFollowing[userids[indexPath.row]] == false {
            let following = PFObject(className: "followers")
            
            self.isFollowing[userids[indexPath.row]] = true
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            following["following"] = userids[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            following.saveInBackground()
            
        }
        else {
            
            self.isFollowing[userids[indexPath.row]] = false
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            
            // see if they're followed by the current user
            let query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
            query.whereKey("following", equalTo: self.userids[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                
                if objects != nil {
                    for object in objects! {
                        // should only be one, but why not
                        object.deleteInBackground()
                    }
                }
                
                
            })
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
