//
//  FirstViewController.swift
//  ScrollViewSnapshotter
//
//  Created by Moshe Berman on 4/10/16.
//  Copyright © 2016 Moshe Berman. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        let images = ["first", "second"]
        
        if let label = cell.textLabel
        {
            label.text = "IndexPath: \(indexPath.section),\(indexPath.row)"
        }
        
        if let imageView = cell.imageView
        {
            let n = Int(arc4random()) % Int(images.count)
            let imageIndex = images.startIndex.advancedBy(n)
            let imageName = images[imageIndex]
            let image = UIImage(named: imageName)
            imageView.image = image
        }
        
        return cell
    }

}

