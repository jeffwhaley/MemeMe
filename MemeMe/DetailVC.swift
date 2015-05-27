//
//  DetailVC.swift
//  MemeMe
//
//  Created by Jeff Whaley on 5/25/15.
//  Copyright (c) 2015 Jeff Whaley. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
// simple view to show a full screen view of a memed image
// caller sets the meme property before instantiating the view 
    
    @IBOutlet weak var detailImage: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailImage.image = self.meme.memedImage
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
}
