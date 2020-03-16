//
//  Collection.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index or nil if out of bounds.
    subscript (optional index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
