//
//  AnimatableView.swift
//  
//
//  Created by Johan Basberg on 02/02/2021.
//

import UIKit

public class AnimatableView: UIView {
    
    /// The timer used to link to the display.
    private var animationTimer: CADisplayLink?
    
    /// The number of frame updates per second needed by you animation.
    ///
    /// Increasing the rate will have a slight impact on power consumption. If you don't need
    /// frequent updates, you should consider lowering it.
    open var framesPerSecond = 60
    
    /// Starts or stops the display linked frame updates.
    public var isAnimating: Bool {
        set(startMonitoring) {
            if startMonitoring {
                
                guard isAnimating == false else {
                    return
                }
                
                animationTimer = CADisplayLink(target: self, selector: #selector(updateAnimation(_:)))
                animationTimer!.preferredFramesPerSecond = framesPerSecond
                animationTimer!.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
                
            } else {
                animationTimer?.invalidate()
                animationTimer = nil
            }
        }
        get {
            return animationTimer != nil
        }
    }
    
    @objc open func updateAnimation(_ something: Any) {
        // #warning("Not Implemented")
        fatalError("You need to override AnimatableView.updateAnimation(_:)")
    }
    
}
