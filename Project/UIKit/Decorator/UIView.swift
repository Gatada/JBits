//
//  UIView.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// A pleasing shake animation using keyframe animations.
    ///
    /// This shake animation moves the view in a natural springy way
    /// without it appearing entirely physical.
    func shake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        
        self.layer.add(animation, forKey: "shake")
    }
    
    
    /// Briefly scales the view up and back down, like
    /// a the beating or throbbing of a heart.
    ///
    /// - Parameters:
    ///   - duration: The default duration of the entire animation, default is 0.1 seconds.
    ///   - scale: How much the view will be scaled, default is 1.3.
    func throb(duration: CFTimeInterval = 0.1, toScale scale: Double = 1.3) {
        let animationKey = "Throb"
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.toValue = scale
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        self.layer.add(pulseAnimation, forKey: animationKey)
    }
    
}
