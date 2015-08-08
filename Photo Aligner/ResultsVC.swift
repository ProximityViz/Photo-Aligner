//
//  ResultsVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/1/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import Photos

class ResultsVC: UIViewController {
    
//    @IBOutlet weak var blendImageView: BlendImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blendView = BlendImageView()
        blendView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        view.addSubview(blendView)
        
//        // save image
//        
//        // TODO: change size to getImageRect once it's based on both images
//        UIGraphicsBeginImageContext(blendImageView.frame.size)
//        let context = UIGraphicsGetCurrentContext()
//        blendImageView.layer.renderInContext(context)
//        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
//            PHAssetChangeRequest.creationRequestForAssetFromImage(screenShot)
//            
//            }, completionHandler: { (success, error) -> Void in
//                if success {
//                    println("Success")
//                } else {
//                    println(error)
//                }
//        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
