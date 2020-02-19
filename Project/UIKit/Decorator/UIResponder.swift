//
//  UIResponder.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import UIKit

/// This extension allows the caller to get the current first responder.
public extension UIResponder {
    
    private weak static var currentResponder: UIResponder? = nil
    
    /// Finds and returns the current first responder.
    ///
    /// - returns: The current first responder as an optional UIResponder instance.
    class var current: UIResponder? {
        UIResponder.currentResponder = nil
        UIApplication.shared.sendAction(#selector(self.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return UIResponder.currentResponder
    }
    
    @objc internal func findFirstResponder(_ sender: AnyObject) {
        UIResponder.currentResponder = self
    }
}
