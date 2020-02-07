//
//  Array.swift
//  Pointo
//
//  Created by Johan Basberg on 07/02/2020.
//
//  Credit to Pedro M. for forEach(predicate:operation:).
//
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

extension Array {
    
    /// Parses the array to executes the `operation` on each element that returns `true` for `predicate`.
    ///
    /// - Parameters:
    ///   - predicate: The check that has to return `true` using the current element for `operation` to be executed.
    ///   - operation: This closure is executed using the received `element` as input whenever the `predicate` returns `true`.
    public func forEach(where predicate: ((Element) throws -> Bool), do operation: ((Element) throws -> Void)) rethrows {
        for element in self where try predicate(element) {
            try operation(element)
        }
    }
    
}
