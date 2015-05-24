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
    
    var memes:[Meme] = []
        
    @IBOutlet weak var sentMemeTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        println("VWA memes.count \(memes.count)")
        if memes.count > 0 {
            println("meme[0].toptext = \(memes[0].topText)")
        }
        
        sentMemeTableView.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("memes.count \(memes.count)")
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMemeTableCell") as! UITableViewCell
    
        let meme = self.memes[indexPath.row]
        
        println("meme.toptext = \(meme.topText)")
        
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }

}
