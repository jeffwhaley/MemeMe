//
//  SentMemeCollectionVC.swift
//  MemeMe
//
//  Created by Jeff Whaley on 5/26/15.
//  Copyright (c) 2015 Jeff Whaley. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
// basic collection of history of sent memes, selecting cell shows the detail
    
    var memes:[Meme]!
    
    @IBOutlet weak var sentMemesCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        sentMemesCollectionView.reloadData()  // data must be reloaded to update the collection
                
        self.automaticallyAdjustsScrollViewInsets = false // removes extra space at top of collection
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("sentMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
                
        let meme = self.memes[indexPath.row]
        
        cell.memeCollectionViewImage.image = meme.memedImage
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! DetailVC
        detailController.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}

class MemeCollectionViewCell: UICollectionViewCell {
// holds the custom cell view
    @IBOutlet weak var memeCollectionViewImage: UIImageView!
}

