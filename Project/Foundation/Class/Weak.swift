//
//  Weak.swift
//  JBits
//
//  Created by Johan Basberg on 26/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

/// A wrapper class to retain a weak reference to an `AnyObject` instance.
class Weak<T: AnyObject> {
    
    // MARK: - Properties
    
    weak var value: T?
    
    // MARK: - Life Cycle
    
    init (value: T) {
        self.value = value
    }
}
