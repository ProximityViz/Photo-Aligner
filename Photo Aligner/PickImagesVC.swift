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
    
    func createActionSheet() -> UIAlertController {
        
        let actionSheet = UIAlertController(title: "Title", message: "Choose", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            
            let phoneFrame = self.view.bounds
            let imageRect = CGRectMake(0, 33, phoneFrame.width, phoneFrame.height - 128)
            var imageView = UIImageView(frame: imageRect)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.alpha = 0.5
            
            if self.photoBeingPicked == 1 && secondPhoto != nil {
                imageView.image = secondPhoto
                println("photo 2 overlay; shooting photo 1")
            } else if self.photoBeingPicked == 2 && firstPhoto != nil {
                imageView.image = firstPhoto
                println("photo 1 overlay; shooting photo 2")
            } else if self.photoBeingPicked == 1 && secondPhoto == nil {
                println("no overlay; shooting photo 1")
            } else if self.photoBeingPicked == 2 && firstPhoto == nil {
                println("no overlay; shooting photo 2")
            }
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.cameraOverlayView = imageView
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
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
