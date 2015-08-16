//
//  CombinedVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class CombinedVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var blendModeTextField: UITextField!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var combinedView: UIView!
    
    var blendView: UIView?
    
    let pickerOptions = ["Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Color Dodge", "Color Burn", "Soft Light", "Hard Light", "Difference", "Exclusion", "Hue", "Saturation", "Color", "Luminosity"]
    let blendModeOptions = [kCGBlendModeNormal, kCGBlendModeMultiply, kCGBlendModeScreen, kCGBlendModeOverlay, kCGBlendModeDarken, kCGBlendModeLighten, kCGBlendModeColorDodge, kCGBlendModeColorBurn, kCGBlendModeSoftLight, kCGBlendModeHardLight, kCGBlendModeDifference, kCGBlendModeExclusion, kCGBlendModeHue, kCGBlendModeSaturation, kCGBlendModeColor, kCGBlendModeLuminosity]
    
    var blendMode = kCGBlendModeNormal
    var blendAlpha: Float = 0.5
    
    func getImageRect(imageSize: CGSize, viewSize: CGSize) -> CGRect {
        
        println("rect")
        println(viewSize)
        
        let viewRatio = viewSize.height / viewSize.width
        let imageRatio = imageSize.height / imageSize.width
        var imageRect:CGRect!
        if imageRatio <= viewRatio {
            // maybe change Y and X so it's in the middle of the screen
            return CGRectMake(0, 0, viewSize.width, viewSize.width * imageRatio)
        } else {
            return CGRectMake(0, 0, viewSize.height / imageRatio, viewSize.height)
        }
        
    }
    
    func drawImages() {
        
        blendView?.removeFromSuperview()
        blendView = BlendImageView(frame: combinedView.frame)
        blendView = BlendImageView(frame: combinedView.frame, blendMode: blendMode, alpha: blendAlpha)
        blendView!.frame = CGRectMake(0, 0, combinedView.frame.width, combinedView.frame.height)
        combinedView.addSubview(blendView!)
        // REFACTOR: Is this needed?
        //        combinedView.setNeedsDisplay()
        
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
