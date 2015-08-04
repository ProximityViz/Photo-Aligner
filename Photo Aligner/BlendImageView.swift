//
//  BlendImageView.swift
//  Photo Aligner
//
//  Created by Mollie on 8/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class BlendImageView: UIView {
    
    func getImageRect(imageSize: CGSize, viewSize: CGSize) -> CGRect {
        
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
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        // TODO: secondScale should be different for especially tall images (CGRect's max height should be rect.height)
        let firstImageRect = getImageRect(firstPhoto!.size, viewSize: rect.size)
        let secondImageRect = getImageRect(secondPhoto!.size, viewSize: rect.size)
        secondPhoto?.drawInRect(secondImageRect, blendMode: kCGBlendModeNormal, alpha: 1)
        firstPhoto?.drawInRect(firstImageRect, blendMode: kCGBlendModeNormal, alpha: 0.5)
        
        super.drawRect(rect)
    }

}
