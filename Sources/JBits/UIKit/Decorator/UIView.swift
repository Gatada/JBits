//
//  UIView.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import UIKit

public enum ParalaxAxis {
    case both
    case y
    case x
}

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
    /// The default values creates a visible throb, not really useful as a tap or refresh reponse.
    /// If the throb is being used to visualize a content refresh, then you may find a duration of 0.05
    /// and a scale of 1.15 to be more suitable.
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
    
    /// Adds a paralax effect to the provided view.
    func addParallax(withFactor factor: Int, along axis: ParalaxAxis = .both) {
        
        let group = UIMotionEffectGroup()
        var effects = [UIInterpolatingMotionEffect]()

        if axis == .both || axis == .x {
            let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            horizontal.minimumRelativeValue = -factor
            horizontal.maximumRelativeValue = factor
            effects.append(horizontal)
        }
        
        if axis == .both || axis == .y {
            let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            vertical.minimumRelativeValue = -factor
            vertical.maximumRelativeValue = factor
            effects.append(vertical)
        }
        
        group.motionEffects = effects
        self.addMotionEffect(group)
    }
    
    /// Call to specify exactly which corner should have a radius.
    func cornerRadii(_ radius: CGFloat, of corners: UIRectCorner, borderColor: UIColor) {
        let radii = CGSize(width: radius, height: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii).cgPath
        layer.mask = maskLayer
    }
    
    /// Adds a drop shadow to the view.
    func addShadow(withColor color: UIColor, withOffset offset: CGSize = CGSize(width: 0, height: -3)) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 8
        layer.masksToBounds = false
        backgroundColor = .clear
    }
    
    
    /// Creates a rounded visual effects view containing an activity indicator.
    ///
    /// The spinner is fully constrained and ready to be added where needed.
    /// The size of the view is 60 × 60 points.
    ///
    /// - Returns: The spinner view.
    static func createSpinner() -> UIView {
        
        let spinnerBackdrop = UIView()
        spinnerBackdrop.translatesAutoresizingMaskIntoConstraints = false
        spinnerBackdrop.layer.masksToBounds = true
        spinnerBackdrop.layer.cornerRadius = 22
        spinnerBackdrop.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = spinnerBackdrop.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spinnerBackdrop.insertSubview(blurEffectView, at: 0)
                    
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        spinnerBackdrop.addSubview(spinner)
        
        spinnerBackdrop.widthAnchor.constraint(equalToConstant: 60).isActive = true
        spinnerBackdrop.heightAnchor.constraint(equalToConstant: 60).isActive = true

        spinner.widthAnchor.constraint(equalTo: spinnerBackdrop.widthAnchor).isActive = true
        spinner.heightAnchor.constraint(equalTo: spinnerBackdrop.heightAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerBackdrop.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: spinnerBackdrop.centerXAnchor).isActive = true

        return spinnerBackdrop
    }
}
