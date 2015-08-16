//
//  BlendImageView.swift
//  Photo Aligner
//
//  Created by Mollie on 8/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class BlendImageView: UIView {
    
    var blendMode = kCGBlendModeNormal
    var blendAlpha: Float = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    init(frame: CGRect, blendMode: CGBlendMode, alpha: Float) {
        // not sure about this
        super.init(frame: frame)
        
        self.blendMode = blendMode
        blendAlpha = alpha
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getImageRect(imageSize: CGSize, viewSize: CGSize) -> CGRect {
        
        // tests: 
        // (834.0, 1250.0), (320.0, 389.0) -> (190.0, 0.0, 260.0, 389.0)
        // (1500.0, 1001.0), (320.0, 389.0) -> (0.0, 87.5, 320.0, 214.0)
        // (834.0, 1250.0), (320.0, 276.0) -> (68, 0.0, 184, 276.0)
        // (1500.0, 1001.0), (320.0, 276.0) -> (0.0, 31, 320.0, 214)
        
        let viewRatio = self.frame.size.height / self.frame.size.width
        let imageRatio = imageSize.height / imageSize.width
        var imageRect:CGRect!
        if imageRatio <= viewRatio {
            // maybe change Y and X so it's in the middle of the screen
            let scaledHeight = self.frame.size.width * imageRatio
            return CGRectMake(0, (self.frame.size.height - scaledHeight) / 2, self.frame.size.width, scaledHeight)
        } else {
            let scaledWidth = self.frame.size.height / imageRatio
            return CGRectMake((self.frame.size.width - scaledWidth) / 2, 0, scaledWidth, self.frame.size.height)
        }
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        // TODO: secondScale should be different for especially tall images (CGRect's max height should be rect.height)
        if secondPhoto != nil {
            let secondImageRect = getImageRect(secondPhoto!.size, viewSize: rect.size)
            secondPhoto?.drawInRect(secondImageRect, blendMode: kCGBlendModeNormal, alpha: 1)
        }
        if firstPhoto != nil {
            let firstImageRect = getImageRect(firstPhoto!.size, viewSize: rect.size)
            firstPhoto?.drawInRect(firstImageRect, blendMode: blendMode, alpha: CGFloat(blendAlpha))
        }
        
        super.drawRect(rect)
    }

}
