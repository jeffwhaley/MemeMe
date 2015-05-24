//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Jeff Whaley on 5/22/15.
//  Copyright (c) 2015 Jeff Whaley. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var useCameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    let toolbarHeight: Int = 44 // used to have the image move out of way the correct amount, not sure how to get this programmatically
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        topText.delegate = self
        bottomText.delegate = self
        topText.hidden = true
        bottomText.hidden = true
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        topText.clearsOnBeginEditing = true
        bottomText.clearsOnBeginEditing = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        useCameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let objectsToShare = ["Share my meme", generateMemedImage()]
        var shareVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        shareVC.completionWithItemsHandler = shareCompletionHandler
        self.presentViewController(shareVC, animated: true, completion: nil)
    }
    
    func shareCompletionHandler (s: String!, ok: Bool, items: [AnyObject]!, err: NSError!) -> Void {
        //TODO: if ok share to list
        //TODO: adjust scope so memedimage isn't recalced???
        if ok {
            let sharedMeme = Meme(topText: topText.text, bottomText: bottomText.text, rawImage: memeImage.image!, memedImage:generateMemedImage())
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(sharedMeme)
            println("complete \(s) \(ok) \(items) \(err)")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage {
        //TODO: hide toolbar and navbar
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.toolbarHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //TODO: restore toolbar and navbar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = false
        return memedImage
    }
    
    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImage.image = image
            topText.hidden = false
            bottomText.hidden = false
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Function to dismiss keyboard
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
}


