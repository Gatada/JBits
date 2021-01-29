//
//  Double.swift
//  
//
//  Created by Johan Basberg on 28/01/2021.
//

import Foundation

public extension Double {
    
    /// Returns `true` if the difference between the receiver and the provided value does not
    /// exceed the provided range, and `false` otherwise.
    func distance(to value: Double, isLessThan range: Double) -> Bool {
        let distance = self.distance(to: value)

        // Adjust sensitivity as required
        // 1 returns true if the two numbers are 1 or less apart.
        // 0.01 is one hundred times more precise, and so on.

        return abs(distance) <= range
    }
    
}
