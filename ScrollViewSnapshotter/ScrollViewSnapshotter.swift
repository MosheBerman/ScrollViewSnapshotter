//
//  ScrollViewSnapshotter.swift
//  ScrollViewSnapshotter
//
//  Created by Moshe Berman on 4/10/16.
//  Copyright © 2016 Moshe Berman. All rights reserved.
//

import UIKit

class ScrollViewSnapshotter: NSObject {
    
    func PDFWithScrollView(scrollview: UIScrollView) -> NSData {
        
        /**
         *  Step 1: The first thing we need is the default origin and size of our pages.
         *          Since bounds always start at (0, 0) and the scroll view's bounds give us
         *          the correct size for the visible area, we can just use that.
         *
         *          In the United States, a standard printed page is 8.5 inches by 11 inches,
         *          but when generating a PDF it's simpler to keep the page size matching the
         *          visible area of the scroll view. We can let our printer software (such
         *          as the Preview app on OS X or the Printer app on iOS) do the scaling.
         *
         *          If we wanted to scale ourselves, we could multiply each of those
         *          numbers by 72, to get the number of points for each dimension.
         *          We would have to change how we generated the the pages below, so
         *          for simplicity, we're going to stick to one page per screenful of content.
         */
        
        let pageDimensions = scrollview.bounds
        
        /**
         *  Step 2: Now we need to know how many pages we will need to fit our content.
         *          To get this, we divide our scroll views dimensions by the size
         *          of each page, in either direction.
         *          We also need to round up, so that the pages don't get clipped.
         */
        
        let pageSize = pageDimensions.size
        let totalSize = scrollview.contentSize
        
        let numberOfPagesThatFitHorizontally = Int(ceil(totalSize.width / pageSize.width))
        let numberOfPagesThatFitVertically = Int(ceil(totalSize.height / pageSize.height))
        
        /**
         *  Step 3: Set up a Core Graphics PDF context.
         *
         *          First we create a backing store for the PDF data, then
         *          pass it and the page dimensions to Core Graphics.
         *
         *          We could pass in some document information here, which mostly cover PDF metadata,
         *          including author name, creator name (our software) and a password to
         *          require when viewing the PDF file.
         *
         *          Also note that we can use UIGraphicsBeginPDFContextToFile() instead,
         *          which writes the PDF to a specified path. I haven't played with it, so
         *          I don't know if the data is written all at once, or as each page is closed.
         */
        
        let outputData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(outputData, pageDimensions, nil)
        
        /**
         *  Step 4: Remember some state for later.
         *          Then we need to clear the content insets, so that our
         *          core graphics layer and our content offset match up.
         *          We don't need to reset the content offset, because that
         *          happens implicitly, in the loop below.
         */
        
        let savedContentOffset = scrollview.contentOffset
        let savedContentInset = scrollview.contentInset
        
        scrollview.contentInset = UIEdgeInsetsZero
        
        /**
         *  Step 6: Now we loop through the pages and generate the data for each page.
         */
        
        if let context = UIGraphicsGetCurrentContext()
        {
            for indexHorizontal in 0 ..< numberOfPagesThatFitHorizontally
            {
                for indexVertical in 0 ..< numberOfPagesThatFitVertically
                {
                    
                    /**
                     *  Step 6a: Start a new page.
                     *
                     *          This automatically closes the previous page.
                     *          There's a similar method UIGraphicsBeginPDFPageWithInfo,
                     *          which allows you to configure the rectangle of the page and
                     *          other metadata.
                     */
                    
                    UIGraphicsBeginPDFPage()
                    
                    /**
                     *  Step 6b:The trick here is to move the visible portion of the
                     *          scroll view *and* adjust the core graphics context
                     *          appropriately.
                     *
                     *          Consider that the viewport of the core graphics context
                     *          is attached to the top of the scroll view's content view
                     *          and we need to push it in the opposite direction as we scroll.
                     *          Further, anything not inside of the visible area of the scroll
                     *          view is clipped, so scrolling will move the core graphics viewport
                     *          out of the rendered area, producing empty pages.
                     *
                     *          To counter this, we scroll the next screenful into view, and adjust
                     *          the core graphics context. Note that core graphics uses a coordinate
                     *          system which has the y coordinate decreasing as we go from top to bottom.
                     *          This is the opposite of UIKit (although it matches AppKit on OS X.)
                     */
                    
                    let offsetHorizontal = CGFloat(indexHorizontal) * pageSize.width
                    let offsetVertical = CGFloat(indexVertical) * pageSize.height
                    
                    scrollview.contentOffset = CGPointMake(offsetHorizontal, offsetVertical)
                    CGContextTranslateCTM(context, -offsetHorizontal, -offsetVertical) // NOTE: Negative offsets
                    
                    /**
                     *  Step 6c: Now we are ready to render the page.
                     *
                     *  There are faster ways to snapshot a view, but this
                     *  is the most straightforward way to render a layer
                     *  into a context.
                     */
                    
                    scrollview.layer.renderInContext(context)
                }
            }
        }
        
        /**
         *  Step 7: End the document context.
         */
        
        UIGraphicsEndPDFContext()
        
        /**
         *  Step 8: Restore the scroll view.
         */
        
        scrollview.contentInset = savedContentInset
        scrollview.contentOffset = savedContentOffset
        
        /**
         *  Step 9: Return the data.
         *          You can write it to a file, or display it the user,
         *          or even pass it to iOS for sharing.
         */
        
        return outputData
    }
}
