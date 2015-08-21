//
//  TextureVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/20/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class TextureVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var blendModeTextField: UITextField!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var combinedView: UIView!
    
    var blendView: UIView?
    
    let pickerOptions = ["Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Soft Light", "Hard Light", "Difference", "Exclusion", "Saturation", "Luminosity"]
    let blendModeOptions = [kCGBlendModeNormal, kCGBlendModeMultiply, kCGBlendModeScreen, kCGBlendModeOverlay, kCGBlendModeDarken, kCGBlendModeLighten, kCGBlendModeSoftLight, kCGBlendModeHardLight, kCGBlendModeDifference, kCGBlendModeExclusion, kCGBlendModeSaturation, kCGBlendModeLuminosity]
    
    var blendMode = kCGBlendModeNormal
    var blendAlpha: Float = 0.5
    
    func drawImages() {
        
        blendView?.removeFromSuperview()
        blendView = BlendImageView(frame: combinedView.frame)
        blendView = BlendImageView(frame: combinedView.frame, blendMode: blendMode, alpha: blendAlpha, exportMode: "texture")
        blendView!.frame = CGRectMake(0, 0, combinedView.frame.width, combinedView.frame.height)
        combinedView.addSubview(blendView!)
        
    }
    
    func saveCombined() {
        println("save")
        
        if blendView != nil && firstPhoto != nil && secondPhoto != nil {
            
            // save image from saveBlendView
            UIGraphicsBeginImageContext(blendView!.frame.size)
            let context = UIGraphicsGetCurrentContext()
            blendView!.layer.renderInContext(context)
            let screenShot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                PHAssetChangeRequest.creationRequestForAssetFromImage(screenShot)
                
                }, completionHandler: { (success, error) -> Void in
                    if success {
                        
                        let savedAlertController = UIAlertController(title: "Image Saved", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(savedAlertController, animated: false, completion: nil)
                        let delay = 0.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                            savedAlertController.dismissViewControllerAnimated(false, completion: nil)
                        })
                        
                    } else {
                        println(error)
                    }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        
        blendModeTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        alphaSlider.value = blendAlpha
        
        // redraw image on device rotation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawImages", name: "screenRotated", object: nil)
        
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Save"), style: UIBarButtonItemStyle.Done, target: self, action: "saveCombined")
        navigationController?.navigationBar.tintColor = UIColor(red:0.65, green:0.88, blue:0.99, alpha:1)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        println("viewDidAppear")
        println(combinedView.frame.size)
        
        drawImages()
    }
    
    // maybe move this function to BlendImageView.swift?
    @IBAction func switchImages(sender: AnyObject) {
        
        if firstPhoto != nil {
            let newCGFirstPhoto = CGImageCreateCopy(firstPhoto?.CGImage)
            let newSecondPhoto = UIImage(CGImage: newCGFirstPhoto, scale: firstPhoto!.scale, orientation: firstPhoto!.imageOrientation)
            firstPhoto = secondPhoto
            secondPhoto = newSecondPhoto
        }
        // set needs display? or drawImages()
        drawImages()
    }
    
    
    // MARK: Picker
    
    // tap outside dismisses picker
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        blendModeTextField.resignFirstResponder()
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        blendModeTextField.text = pickerOptions[row]
        blendMode = blendModeOptions[row]
        
        drawImages()
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerOptions[row]
    }
    
    // MARK: Slider
    @IBAction func sliderChanged(sender: UISlider) {
        
        blendAlpha = sender.value
        
        drawImages()
        
    }
    
    
}
