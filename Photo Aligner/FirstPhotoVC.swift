//
//  FirstPhotoVC.swift
//  Map My Day
//
//  Created by Mollie on 3/13/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class FirstPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var firstPhotoButton: UIButton!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization(nil)
        
    }
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        
        let libraryPickerController = UIImagePickerController()
        libraryPickerController.delegate = self
        libraryPickerController.sourceType = .PhotoLibrary
        
        presentViewController(libraryPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        firstPhoto = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // TODO: should this be inside completion block?
        // save image from picker, if it came from the camera
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera) {
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                
                }, completionHandler: { (success, error) -> Void in
                    if success {
                        println("Success")
                    } else {
                        println(error)
                    }
            })
            
        }
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("secondPhotoVC") as! SecondPhotoVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    // TODO: are these used?
    @IBAction func cancelImage(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func saveImage(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
