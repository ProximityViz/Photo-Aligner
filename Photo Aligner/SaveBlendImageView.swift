////
////  SaveBlendImageView.swift
////  Photo Aligner
////
////  Created by Mollie on 8/16/15.
////  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
////
//
//import UIKit
//
//class SaveBlendImageView: UIView {
//    
//    var blendMode = kCGBlendModeNormal
//    var blendAlpha: Float = 0.5
//    var imageViewSize: CGSize?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        
//    }
//    
//    init(frame: CGRect, blendMode: CGBlendMode, alpha: Float) {
//        // not sure about this
//        super.init(frame: frame)
//        
//        self.blendMode = blendMode
//        blendAlpha = alpha
//        
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    func centerImage(imageSize: CGSize) -> CGRect {
//        
//    }
//    
//    override func drawRect(rect: CGRect) {
//        
//        let ctx = UIGraphicsGetCurrentContext()
//        
//        // TODO: center image
//        if secondPhoto != nil {
//            let secondImageRect = centerImage(secondPhoto!.size)
//            secondPhoto?.drawInRect(secondImageRect, blendMode: kCGBlendModeNormal, alpha: 1)
//        }
//        if firstPhoto != nil {
//            let firstImageRect = centerImage(firstPhoto!.size)
//            firstPhoto?.drawInRect(firstImageRect, blendMode: blendMode, alpha: CGFloat(blendAlpha))
//        }
//        
//        super.drawRect(rect)
//    }
//    
//}
