//
//  PhotoVC.swift
//  Map My Day
//
//  Created by Mollie on 3/13/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class PhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstPhotoButton: UIButton!
    @IBOutlet weak var secondPhotoButton: UIButton!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        addOutputForMetadata()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    var metadataOutput = AVCaptureMetadataOutput()
    func addOutputForMetadata() {
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureSession.addOutput(metadataOutput)
        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
    }
    
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
            device.focusMode = .Locked
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
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        
        let libraryPickerController = UIImagePickerController()
        libraryPickerController.delegate = self
        libraryPickerController.sourceType = .PhotoLibrary
        
        presentViewController(libraryPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.firstPhotoButton.setTitle("Retake First Photo", forState: .Normal)
        self.firstPhotoButton.setTitle("Retake First Photo", forState: .Highlighted)
        self.secondPhotoButton.hidden = false
        
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
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func takeSecondPhoto(sender: AnyObject) {
        
        // or high
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == .Back {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
        
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
                
//                var imageView = UIImageView(image: image)
                self.imageView.image = image
//                imageView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
                
                //Show the captured image to
//                self.view.addSubview(imageView)
                
                //Save the captured preview to image
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
            })
        }
        // remove camera view
        // save image
        //        captureSession.stopRunning()
        //        println(captureSession.outputs.last?.description)
        //        previewLayer?.frame
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
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
        
        //        var newImage = PFObject(className: "Image") // Media or Image
        //        newImage["user"] = PFUser.currentUser()
        //
        //        let location = manager.location
        //
        //        newImage["location"] = ["latitude":location.coordinate.latitude,
        //            "longitude":location.coordinate.longitude,
        //            "altitude":location.altitude,
        //            "horizontalAccuracy":location.horizontalAccuracy,
        //            "verticalAccuracy":location.verticalAccuracy,
        //            "time":dateformatterTime(location.timestamp)]
        //        newImage["time"] = NSDate()
        //
        //        let width = 540 * imageView.image!.size.width / imageView.image!.size.height
        //        let image = resizeImage(imageView.image!, withSize: CGSizeMake(width, 540.0))
        //
        //        // turn UIImage into PFFile
        //        let imageFile = PFFile(name: "image.png", data: UIImagePNGRepresentation(image))
        //        newImage["image"] = imageFile
        //        
        //        newImage.saveInBackgroundWithBlock { (success, error) -> Void in
        //            photos.append(newImage.objectId)
        //            media.append(["type": "photo", "objectId": newImage.objectId])
        //        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
