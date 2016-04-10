//
//  PDFManager.swift
//  ScrollViewSnapshotter
//
//  Created by Moshe Berman on 4/10/16.
//  Copyright © 2016 Moshe Berman. All rights reserved.
//

import UIKit

class PDFManager: NSObject {

    // MARK: - Writing a PDF
    
    func writeData(data: NSData) {
        
        let documentsDirectory = self.documentsDirectory()
        
        let path = "\(documentsDirectory)/\(NSDate()).pdf"
        
        do {
            try data.writeToFile(path, options: .AtomicWrite)
        }
        catch let e {
            print("Error writing '\(data.length)' bytes of PDF to file. Error: \(e)")
        }   
    }
    
    // MARK: - Reading a PDF
    
    func PDFAtPath(path:String) -> NSData? {
        return NSData(contentsOfFile: path)
    }
    
    // MARK: - PDFs in a Directory
    
    func filesInDocumentsDirectory () -> [String] {
        
        let documentsPath = documentsDirectory()
        
        do {
            let PDFs = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsPath)
            
            return PDFs
        }
        catch let e {
            print("Failed to find documents at path. Error: \(e)")
        }
        
        return []
    }
    
    // MARK: - Documents Directory 
    
    func documentsDirectory() -> String {
        
        let documentsDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if let directory = documentsDirectories.first {
            return directory
        }
        
        return ""
        
    }
}
