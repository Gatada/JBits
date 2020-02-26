//
//  Weak.swift
//  JBits
//
//  Created by Johan Basberg on 26/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

/// A wrapper class to retain a weak reference to an `AnyObject` instance.
public class Weak<T: AnyObject> {
    
    // MARK: - Properties
    
    public weak var value: T?
    
    // MARK: - Life Cycle
    
    public init (value: T) {
        self.value = value
    }
}
