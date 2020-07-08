//
//  ChevronHandle.swift
//  Letterlock
//
//  Created by Johan H. W. Basberg on 11/09/16.
//  Copyright © 2016 Johan Basberg. All rights reserved.
//

import UIKit

/// Draws a chevron 36 × 10 big on screen.
///
/// Use the `currentOffset` ranging from 0 to 1 to determine the angle of the chevron. A value of 0
/// means the handle is straight, while a value of 1 means a chevron will be drawn.
@IBDesignable class ChevronHandle: UIView {
    
    var currentOffset: CGFloat = 1
    @IBInspectable var chevronColor: UIColor = UIColor.systemGray
    
    override func draw(_ rect: CGRect) {
        drawDynamicChevron(color: chevronColor, chevronAngled: currentOffset)
    }
    
    /// Draws a chevron with a given angle.
    private func drawDynamicChevron(color: UIColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000), chevronAngled: CGFloat = 0) {
        // General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        // Variable Declarations
        let chevronAngledOffset: CGFloat = chevronAngled * 4
        
        // Bezier Drawing
        context.saveGState()
        context.translateBy(x: 3, y: 3)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 15, y: chevronAngledOffset))
        bezierPath.addLine(to: CGPoint(x: 30, y: 0))
        bezierPath.lineCapStyle = .round;
        
        bezierPath.lineJoinStyle = .round
        
        color.setStroke()
        bezierPath.lineWidth = 6
        bezierPath.stroke()
        
        context.restoreGState()
    }
}
