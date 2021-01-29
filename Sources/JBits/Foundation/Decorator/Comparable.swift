//
//  Comparable.swift
//  
//
//  Created by Johan Basberg on 28/01/2021.
//

import Foundation

public extension Comparable {
    
    /// Will clamp a value within a given range.
    ///
    /// Given a closed range, the returned value will be minimum value of range if less than lower limit,
    /// or maximum value of range if more than the upper limit:
    /// ```
    /// 10.clamped(to: 0...5) // == 5
    /// ```
    func clamped(to r: ClosedRange<Self>) -> Self {
        let min = r.lowerBound, max = r.upperBound
        return self < min ? min : (max < self ? max : self)
    }
}
