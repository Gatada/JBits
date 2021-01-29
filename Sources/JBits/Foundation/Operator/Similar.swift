//
//  File.swift
//  
//
//  Created by Johan Basberg on 07/01/2021.
//

import Foundation
import CoreGraphics

/// Returns `true` if the provided values are within the defined range of one another.
infix operator ==~: AssignmentPrecedence
public func ==~ (left: Double, right: Double) -> Bool {
    let x = left.distance(to: right)

    // Adjust sensitivity as required:
    // 1 returns true if the two numbers are 1 or less apart.
    // 0.01 is one hundred times more precise, and so on.

    let isWithinRange = abs(x) <= 0.2 // 1e-1
    return isWithinRange
}
