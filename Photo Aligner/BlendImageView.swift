//
//  BlendImageView.swift
//  Photo Aligner
//
//  Created by Mollie on 8/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class BlendImageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getImageRect(imageSize: CGSize, viewSize: CGSize) -> CGRect {
        
        println("rect")
        println(viewSize)
        
        let viewRatio = self.frame.size.height / self.frame.size.width
        let imageRatio = imageSize.height / imageSize.width
        var imageRect:CGRect!
        if imageRatio <= viewRatio {
            // maybe change Y and X so it's in the middle of the screen
            return CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * imageRatio)
        } else {
            return CGRectMake(0, 0, self.frame.size.height / imageRatio, self.frame.size.height)
        }
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        // TODO: secondScale should be different for especially tall images (CGRect's max height should be rect.height)
        let firstImageRect = getImageRect(firstPhoto!.size, viewSize: rect.size)
        let secondImageRect = getImageRect(secondPhoto!.size, viewSize: rect.size)
        if secondPhoto != nil {
            secondPhoto?.drawInRect(rect, blendMode: kCGBlendModeNormal, alpha: 1)
        }
        if firstPhoto != nil {
            firstPhoto?.drawInRect(rect, blendMode: kCGBlendModeNormal, alpha: 0.5)
        }
        
        super.drawRect(rect)
    }

}
