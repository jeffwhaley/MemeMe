//
//  SentMemeTableVC.swift
//  MemeMe
//
//  Created by Jeff Whaley on 5/23/15.
//  Copyright (c) 2015 Jeff Whaley. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
// basic table to show shared meme history, selection shows a detail view
    
    var memes:[Meme]!
        
    @IBOutlet weak var sentMemeTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        sentMemeTableView.reloadData()  // data must be reloaded to update the table
        
        self.automaticallyAdjustsScrollViewInsets = false  // removes some extra space at top of table
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMemeTableCell") as! UITableViewCell
    
        let meme = self.memes[indexPath.row]
                
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! DetailVC
        detailController.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}
