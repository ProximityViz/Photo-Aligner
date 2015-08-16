//
//  PickImagesVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class PickImagesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstImageButton: UIButton!
    @IBOutlet weak var secondImageButton: UIButton!
    @IBOutlet weak var combineImagesButton: UIButton!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    var photoBeingPicked = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBarHidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if photoBeingPicked == 1 {
            firstPhoto = image
            firstImageView.image = image
        } else if photoBeingPicked == 2 {
            secondPhoto = image
            secondImageView.image = image
        }
        
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
        
    }
    
    func rotateOverlay(imageView: UIImageView) -> UIImageView {
        
        // what do we want?
        
        // a) longest side of image to be on longest side of phone
        
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait {
            return imageView
        }
//        var transform: CGAffineTransform = CGAffineTransformIdentity
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft {
            // rotate left
//            let transform = CGAffineTransformRotate(transform, Float(M_PI_2))
            imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        } else if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight {
            // rotate right
            //            let transform = CGAffineTransformRotate(transform, Float(-M_PI_2))
            imageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        }
        
        //            // b) "bottom" of image to always be on "bottom" of phone (also needs to rotate when you rotate the device)
        
        
        return imageView
    }
    
    func createActionSheet() -> UIAlertController {
        
        let actionSheet = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            
            var imageView = UIImageView()
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.alpha = 0.5
            
            if self.photoBeingPicked == 1 && secondPhoto != nil {
                imageView.image = secondPhoto
            } else if self.photoBeingPicked == 2 && firstPhoto != nil {
                imageView.image = firstPhoto
            }
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            

            self.presentViewController(imagePicker, animated: true, completion: { () -> Void in
                
                imageView.frame = CGRectMake(0, -31, imagePicker.view.frame.width, imagePicker.view.frame.height)
                imagePicker.cameraOverlayView = imageView
                
            })
            
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            
            let libraryPickerController = UIImagePickerController()
            libraryPickerController.delegate = self
            libraryPickerController.sourceType = .PhotoLibrary
            
            self.presentViewController(libraryPickerController, animated: true, completion: nil)
            
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        
        return actionSheet
    }
    
    @IBAction func firstButtonTapped(sender: AnyObject) {
        
        photoBeingPicked = 1
        let actionSheet = createActionSheet()
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        
        photoBeingPicked = 2
        let actionSheet = createActionSheet()
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func combineImagesTapped(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
