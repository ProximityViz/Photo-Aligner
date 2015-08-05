//
//  SecondPhotoVC.swift
//  Map My Day
//
//  Created by Mollie on 3/13/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class SecondPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDevice: AVCaptureDevice?
    
    enum CameraType {
        case Front
        case Back
    }
    
    var camera = CameraType.Back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = firstPhoto
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func beginSession() {
        var err: NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
//        addOutputForMetadata()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = secondImageView.bounds
        secondImageView.layer.addSublayer(previewLayer)
        imageView.alpha = 0.5
        view.sendSubviewToBack(secondImageView)
        captureSession.startRunning()
    }
    
//    var metadataOutput = AVCaptureMetadataOutput()
//    func addOutputForMetadata() {
//        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
//        captureSession.addOutput(metadataOutput)
//        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
//    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        println(metadataObjects.count)
        for object in metadataObjects {
            if let metadata = object as? AVMetadataObject {
                println(metadata.type)
            }
        }
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked // TODO: is this a problem?
            device.unlockForConfiguration()
        }
    }
    
    func focusTo(value: Float) {
        if let device = captureDevice {
            if device.lockForConfiguration(nil) {
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
        }
    }
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        
        let libraryPickerController = UIImagePickerController()
        libraryPickerController.delegate = self
        libraryPickerController.sourceType = .PhotoLibrary
        
        presentViewController(libraryPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        secondImageView.image = image
        secondPhoto = image
        imageView.alpha = 0.5
        view.sendSubviewToBack(secondImageView)
        secondPhotoHasBeenChosen()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
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
            
            takePhotoButton.setTitle("Retake First Photo", forState: .Normal)
            takePhotoButton.setTitle("Retake First Photo", forState: .Highlighted)
            
        }
        
    }
    
    var takePhotoButtonClicks = 0
    @IBAction func takePhoto(sender: AnyObject) {
        
        // the first time the user taps the 2nd photo button, it displays the camera view
        // the second time they tap it, it saves the image
        takePhotoButtonClicks += 1
        if takePhotoButtonClicks == 1 {
            displaySecondPhotoCamera()
        } else if takePhotoButtonClicks == 2 {
            finishSecondPhoto()
            takePhotoButtonClicks = 0;
            // reset button title
        }
        
    }
    
    func displaySecondPhotoCamera() {
        // if there was already a session, stop it
        captureSession.stopRunning()
        previewLayer?.removeFromSuperlayer()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if camera == .Back {
                    if device.position == .Back {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            beginSession()
                        }
                    }
                } else {
                    if device.position == .Front {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            beginSession()
                        }
                    }
                }
            }
        }
        
    }
    
//    func reloadCamera() {
//        
//    }
    
    @IBAction func switchCamera(sender: AnyObject) {
        camera = camera == .Back ? .Front : .Back
//        if camera == .Back {
//            camera = .Front
//        } else {
//            camera = .Back
//        }
        
//        reloadCamera()
        
        displaySecondPhotoCamera()
        
    }
    
    func finishSecondPhoto() {
        var stillImageOutput = AVCaptureStillImageOutput()
        let screenSize = UIScreen.mainScreen().bounds.size
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var dataProvider = CGDataProviderCreateWithCFData(imageData)
                var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                
//                self.secondImageView.image = image
                secondPhoto = image
                self.secondPhotoHasBeenChosen()
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                self.captureSession.stopRunning()
                // hide/remove view
                
            })
        }
        
        
    }
    
    func secondPhotoHasBeenChosen() {
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneWasPressed"))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func doneWasPressed() {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext())
        photosCombined = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        // save combined photo as combinedPhoto
//        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0)
//        view.drawViewHierarchyInRect(imageView.frame, afterScreenUpdates: true)
//        photosCombined = UIGraphicsGetImageFromCurrentImageContext()
        
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.renderInContext(UIGraphicsGetCurrentContext())
//        photosCombined = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(photosCombined, nil, nil, nil)
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("resultsVC") as! ResultsVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let screenSize = UIScreen.mainScreen().bounds.size
        // change view to just imageView
        var focusPoint = CGPoint(x: touch.locationInView(self.view).y / screenSize.height, y: 1.0 - touch.locationInView(self.view).x / screenSize.width)
        
        // just auto-focus instead of tap to focus
        
        if let device = captureDevice {
            if device.lockForConfiguration(nil) {
                device.focusPointOfInterest = focusPoint
                device.focusMode = .ContinuousAutoFocus
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .ContinuousAutoExposure
            }
        }
    }
    
    @IBAction func cancelImage(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //    func resizeImage(image: UIImage, withSize size: CGSize) -> UIImage {
    //
    //        // make square
    //
    //        //        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    //        UIGraphicsBeginImageContext(size)
    //        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        return newImage
    //
    //    }
    
    @IBAction func saveImage(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
