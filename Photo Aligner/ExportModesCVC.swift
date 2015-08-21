//
//  ExportModesCVC.swift
//  Photo Aligner
//
//  Created by Mollie on 8/19/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class ExportModesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell"
    
    var exportModes: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("ExportModes", ofType: "plist") {
            exportModes = NSArray(contentsOfFile: path)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return exportModes!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ExportModeCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ExportModeCell
    
        // Configure the cell
        if let exportModeDict = exportModes?.objectAtIndex(indexPath.row) as? NSDictionary {
            if let name = exportModeDict.valueForKey("name") as? String {
                cell.cellTitle.text = name
            }
            if let image = exportModeDict.valueForKey("image") as? String {
                cell.imageView.image = UIImage(named: image)
            }
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var storyboardID = ""
        var className = ""
        
        if let exportModeDict = exportModes?.objectAtIndex(indexPath.row) as? NSDictionary {
            storyboardID = exportModeDict.valueForKey("storyboardID") as! String
            className = exportModeDict.valueForKey("class") as! String
        }

        
//        let storyboard = UIStoryboard(name: "Media", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("venuesTVC") as VenuesTVC
//        presentViewController(navC, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "ExportModes", bundle: nil)
//        let navC = storyboard.instantiateViewControllerWithIdentifier("venuesNavC") as UINavigationController
        
        // REFACTOR (hopefully)
        if className == "CombinedVC" {
            let vc = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! CombinedVC
//            self.navigationController!.presentViewController(vc, animated: true, completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        } else if className == "TextureVC" {
            let vc = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! TextureVC
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK: Flow
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        var cellSize: CGFloat = 100
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            // landscape = 3 wide
            cellSize = (UIScreen.mainScreen().bounds.size.width - 80) / 3
        } else {
            // portrait = 2 wide
            cellSize = (UIScreen.mainScreen().bounds.size.width - 60) / 2
        }
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    // update view on orientation change
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
