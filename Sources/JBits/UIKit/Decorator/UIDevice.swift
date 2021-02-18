//
//  File.swift
//  
//
//  Created by Johan Basberg on 29/01/2021.
//

import UIKit

#if !os(tvOS)
import CoreMotion
#endif

public protocol JBitDeviceMotionDelegate: class {
    
    var deviceOrientation: UIDevice.Orientation { get }
    
    func deviceOrientationChanged(to: UIDevice.Orientation)
    
}

public extension UIDevice {
    
    // MARK: - MOTION HANDLING -

    /// The orientation of the device.
    enum Orientation: String {
        
        case screenUp
        case screenDown
        case onLeftEdge
        case onRightEdge
        case onTopEdge
        case onBottomEdge
        
        init?(acceleration: CMAcceleration) {
            
            let totalMotion = abs(acceleration.x) + abs(acceleration.y) + abs(acceleration.z)
            guard totalMotion < 1.7 else {
                // Too much motion, waiting for move to finish before
                // reading device orientation.
                return nil
            }
            
            // These values came from an iPhone 12, and I have not
            // tested this with other devices - yet.
            
            switch (acceleration.x, acceleration.y, acceleration.z) {
            case let (x, y, z) where x.distance(to: -0.99, isLessThan: 0.2) && y.distance(to: -0.035, isLessThan: 0.2) && z.distance(to: 0.021, isLessThan: 0.2):
                self = .onLeftEdge
            case let (x, y, z) where x.distance(to: 0.99, isLessThan: 0.2) && y.distance(to: -0.015, isLessThan: 0.2) && z.distance(to: 0.047, isLessThan: 0.2):
                self = .onRightEdge
            case let (x, y, z) where x.distance(to: -0.007, isLessThan: 0.2) && y.distance(to: 0.99, isLessThan: 0.2) && z.distance(to: -0.013, isLessThan: 0.2):
                self = .onTopEdge
            case let (x, y, z) where x.distance(to: -0.0032, isLessThan: 0.2) && y.distance(to: -0.99, isLessThan: 0.2) && z.distance(to: 0.021, isLessThan: 0.2):
                self = .onBottomEdge
            case let (_, _, z) where z > 0.85:
                self = .screenDown
            case let (_, _, z) where z < 0:
                self = .screenUp
            default:
                return nil
            }
        }
    }
    
    func handleAcceleration(_ acceleration: CMAcceleration, delegate: JBitDeviceMotionDelegate) {
        if let currentOrientation = Orientation(acceleration: acceleration), currentOrientation != delegate.deviceOrientation {
            delegate.deviceOrientationChanged(to: currentOrientation)
            // Log.da("New Device Orientation: \(currentOrientation.rawValue)", log: .info)
        }
    }
    
    func startSensingOrientation(using delegate: JBitDeviceMotionDelegate) -> CMMotionManager {
        let manager = CMMotionManager()
        
        manager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
            guard error == nil, let accelerationData = data?.acceleration  else {
                return
            }
            self.handleAcceleration(accelerationData, delegate: delegate)
        }
        
        return manager
    }
    
    func stopSensingOrientation(manager: CMMotionManager) {
        manager.stopAccelerometerUpdates()
    }
}
