//
//  SecondViewController.swift
//  ScrollViewSnapshotter
//
//  Created by Moshe Berman on 4/10/16.
//  Copyright © 2016 Moshe Berman. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {

    /**
     * A list of the saved files
     */
    var PDFPaths : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updatePaths), name: "com.mosheberman.pdf-saved", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updatePaths()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //  MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PDFPaths.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.row < self.PDFPaths.count {
            let index = self.PDFPaths.startIndex.advancedBy(indexPath.row)
            let path = self.PDFPaths[index]
            
            cell.textLabel?.text = path.componentsSeparatedByString("/").last
        }
        
        return cell
    }
    
    // MARK: - Helpers
    
    /**
     *  Here we update the paths by re-loading the contents of the directory.
     */
    
    func updatePaths()
    {
        let manager = PDFManager()
        
        self.PDFPaths = manager.filesInDocumentsDirectory()
    }
}

