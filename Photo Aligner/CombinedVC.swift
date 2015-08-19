//
//  CombinedVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class CombinedVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var blendModeTextField: UITextField!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var combinedView: UIView!
    
    var blendView: UIView?
    
    let pickerOptions = ["Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Color Dodge", "Color Burn", "Soft Light", "Hard Light", "Difference", "Exclusion", "Hue", "Saturation", "Color", "Luminosity"]
    let blendModeOptions = [kCGBlendModeNormal, kCGBlendModeMultiply, kCGBlendModeScreen, kCGBlendModeOverlay, kCGBlendModeDarken, kCGBlendModeLighten, kCGBlendModeColorDodge, kCGBlendModeColorBurn, kCGBlendModeSoftLight, kCGBlendModeHardLight, kCGBlendModeDifference, kCGBlendModeExclusion, kCGBlendModeHue, kCGBlendModeSaturation, kCGBlendModeColor, kCGBlendModeLuminosity]
    
    var blendMode = kCGBlendModeNormal
    var blendAlpha: Float = 0.5
    
    func drawImages() {
        
        blendView?.removeFromSuperview()
        blendView = BlendImageView(frame: combinedView.frame)
        blendView = BlendImageView(frame: combinedView.frame, blendMode: blendMode, alpha: blendAlpha)
        blendView!.frame = CGRectMake(0, 0, combinedView.frame.width, combinedView.frame.height)
        combinedView.addSubview(blendView!)
        // REFACTOR: Is this needed?
        //        combinedView.setNeedsDisplay()
        
    }
    
    func saveCombined() {
        println("save")
        
        if blendView != nil && firstPhoto != nil && secondPhoto != nil {
//            // maybe make a hidden big image, save that one, and then dismiss the hidden image
//            println(blendView!.frame.size) // pass this to SaveBlendImageView
//            // calculate size of exported image in here and pass it in instead
//                // imageView = (320, 325)
//                // firstImage = (834, 1250)
//                // secondImage = (1500, 1001)
//                // saveBlendView should = ()
//            let imageViewRatio = blendView!.frame.size.height / blendView!.frame.size.width
//            let firstImageRatio = firstPhoto!.size.height / firstPhoto!.size.width
//            let secondImageRatio = secondPhoto!.size.height / secondPhoto!.size.width
//            if
            
        
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
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "saveCombined")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Save"), style: UIBarButtonItemStyle.Done, target: self, action: "saveCombined")
        navigationController?.navigationBar.tintColor = UIColor(red:0.65, green:0.88, blue:0.99, alpha:1)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        println("viewDidAppear")
        println(combinedView.frame.size)
        
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
