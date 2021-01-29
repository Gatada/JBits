//
//  Date.swift
//  
//
//  Created by Johan Basberg on 28/01/2021.
//

import Foundation

public extension Date {
    
    /// Substracts left side `Date` from right side `Date` and returns the `TimeInterval`.
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
