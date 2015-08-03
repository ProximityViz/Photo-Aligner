//
//  ResultsVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/1/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var combinedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstImageView.image = firstPhoto
        secondImageView.image = secondPhoto
//        combinedImageView.image = photosCombined
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
