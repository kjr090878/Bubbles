//
//  TouchButton.swift
//  TouchyDot
//
//  Created by Kelly Robinson on 12/3/15.
//  Copyright © 2015 Kelly Robinson. All rights reserved.
//

import UIKit

@IBDesignable class Bubble: UIView {

    @IBInspectable var color: UIColor = UIColor.black
    
    @IBInspectable var spacing: CGFloat = 1
    
    @IBInspectable var maxRings: Int = 0
    
    override func draw(_ rect: CGRect) {
        
        print(maxRings)
        
        if spacing < 1 { spacing = 1 }
        if maxRings < 1 { maxRings = 1000 }
        
        let context = UIGraphicsGetCurrentContext()
        
        let radius = rect.width / 2
        
        var inset: CGFloat = 1
        
        color.set()
        
        var ringCount = 0
        
        while inset < radius {
            
            if ringCount == maxRings { inset = radius }
            
            let insetRect = rect.insetBy(dx: inset, dy: inset)
            
            context?.strokeEllipse(in: insetRect)
            
            ringCount += 1
            inset += spacing
            
         
            
        }
        

    }

}
