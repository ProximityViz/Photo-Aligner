////
////  SecondPhotoVC.swift
////  Map My Day
////
////  Created by Mollie on 3/13/15.
////  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
////
//
//import UIKit
//import Photos
//
//class SecondPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
//    
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var secondImageView: UIImageView!
//    @IBOutlet weak var takePhotoButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        imageView.image = firstPhoto
//        
//    }
//    
////    var metadataOutput = AVCaptureMetadataOutput()
////    func addOutputForMetadata() {
////        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
////        captureSession.addOutput(metadataOutput)
////        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
////    }
//    
//    @IBAction func openPhotoLibrary(sender: AnyObject) {
//        
//        let libraryPickerController = UIImagePickerController()
//        libraryPickerController.delegate = self
//        libraryPickerController.sourceType = .PhotoLibrary
//        
//        presentViewController(libraryPickerController, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        
//        secondPhoto = image
//        
//        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
//            
//            // save image from picker, if it came from the camera
//            if picker.sourceType == UIImagePickerControllerSourceType.Camera {
//                
//                PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
//                    PHAssetChangeRequest.creationRequestForAssetFromImage(image)
//                    
//                    }, completionHandler: { (success, error) -> Void in
//                        if success {
//                            println("Success")
//                        } else {
//                            println(error)
//                        }
//                })
//                
//            }
//            
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("resultsVC") as! ResultsVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        })
//        
//    }
//    
//    var takePhotoButtonClicks = 0
//    @IBAction func takePhoto(sender: AnyObject) {
//        
////        var imageView = UIImageView(image: firstPhoto)
//        let phoneFrame = view.bounds
//        let imageRect = CGRectMake(0, 33, phoneFrame.width, phoneFrame.height - 128)
//        var imageView = UIImageView(frame: imageRect)
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        imageView.image = firstPhoto
//        imageView.alpha = 0.5
//        
//        
//        // placeholder:
////        let cameraView = UIView(frame: view.bounds)
////        cameraView.addSubview(imageView)
//        
//        var imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .Camera
//        imagePicker.cameraOverlayView = imageView
//        
//        presentViewController(imagePicker, animated: true, completion: nil)
//        
////        // the first time the user taps the 2nd photo button, it displays the camera view
////        // the second time they tap it, it saves the image
////        takePhotoButtonClicks += 1
////        if takePhotoButtonClicks == 1 {
////            flashButton.hidden = false
////            switchCameraButton.hidden = false
////            displaySecondPhotoCamera()
////            // TODO: change takePhotoButton title/image
////        } else if takePhotoButtonClicks == 2 {
////            // TODO: it actually should save the combined photo now
////            // or segue
////            flashButton.hidden = true
////            switchCameraButton.hidden = true
////            takePhotoButtonClicks = 0
////            finishSecondPhoto()
////            // TODO: change takePhotoButton title/image
////            // reset button title
////            
////        }
//        
//    }
//    
//    // are these used?
//    @IBAction func cancelImage(sender: AnyObject) {
//        
//        dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    
//    @IBAction func saveImage(sender: AnyObject) {
//        
//        dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    
//    
//    
//    
//}
