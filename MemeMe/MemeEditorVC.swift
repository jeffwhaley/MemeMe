//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Jeff Whaley on 5/22/15.
//  Copyright (c) 2015 Jeff Whaley. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
// class for meme editor, allows selecting image, adding text and sharing
    
    // outlets for user interface
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var useCameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup text appearance attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2
        ]

        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center

        // setup text to enable delegates
        topText.delegate = self
        bottomText.delegate = self
        
        // set initial state for UI
        
        topText.hidden = true
        bottomText.hidden = true
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.clearsOnBeginEditing = true
        bottomText.clearsOnBeginEditing = true
        
        
        shareButton.enabled = false
    }
    
    // subscribe/unsubscribe to keyboard notifications
    override func viewWillAppear(animated: Bool) {
        useCameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // functions to handle sharing
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let objectsToShare = ["Share my meme", generateMemedImage()]
        var shareVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        shareVC.completionWithItemsHandler = shareCompletionHandler
        self.presentViewController(shareVC, animated: true, completion: nil)
    }
    
    func shareCompletionHandler (s: String!, ok: Bool, items: [AnyObject]!, err: NSError!) -> Void {
        if ok {
            let sharedMeme = Meme(topText: topText.text, bottomText: bottomText.text, rawImage: memeImage.image!, memedImage:generateMemedImage())
            let object = UIApplication.sharedApplication().delegate
            
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(sharedMeme)
            
            // println("complete \(s) \(ok) \(items) \(err)")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage {
    // use image context to save image with text, hide bars so they are not included
        navBar.hidden = true
        toolBar.hidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolBar.hidden = false
        return memedImage
    }
    
    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // functions to select and show image with camera or album with text field overlays
    
    @IBAction func useCamera(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickFromAlbum(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(pickerController: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
    // executes after image picker completes, either camera or album

        shareButton.enabled = true
        self.navigationController?.navigationBarHidden = true

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImage.image = image
            topText.hidden = false
            bottomText.hidden = false
        }
    }
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.navigationBarHidden = false
    }
    
    // Functions to dismiss keyboard either with return or touching outside keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // Clear keyboard when starting to edit
    func textFieldDidBeginEditing(textField: UITextField) {
        if topText.isFirstResponder() {
            topText.clearsOnBeginEditing = false
        }

        if bottomText.isFirstResponder() {
            bottomText.clearsOnBeginEditing = false
        }
    }
    
    // Functions to move text fields out of way when keyboard appears
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    let toolbarHeight: Int = 44 // used to have the image move out of way the correct amount

    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification) - CGFloat(toolbarHeight)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification) - CGFloat(toolbarHeight)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

// Start for a future enhancement to put the text in the proper place for aspect fit image
// I wasn't able to figure out how to 
//     let imageFrame = frameForImage(image, imageView: memeImage)
//     let topTextFrame = CGRectMake(imageFrame.origin.x, imageFrame.origin.y, imageFrame.width, topText.frame.height)
//     topText.frame = topTextFrame

    
//    func frameForImage(image: UIImage, imageView: UIImageView) -> CGRect {
//        let imageRatio = image.size.width / image.size.height
//        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
//        if imageRatio < viewRatio {
//            let scale = imageView.frame.size.height / image.size.height
//            let width = scale * image.size.width
//            let topLeftX = (imageView.frame.size.width - width) * 0.5
//            return CGRectMake(topLeftX, 0, width, imageView.frame.size.height)
//        } else {
//            let scale = imageView.frame.size.width / image.size.width
//            let height = scale * image.size.height
//            let topLeftY = (imageView.frame.size.height - height) * 0.5
//            return CGRectMake(0, topLeftY, imageView.frame.size.width, height)
//        }
//    }
}


