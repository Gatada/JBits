//
//  UIViewController.swift
//  JBits
//
//  Created by Johan Basberg on 12/06/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    /// Returns `true` if the view is on screen.
    ///
    /// This variable implies that the view is visible, and has therefore been renamed.
    ///
    /// - Note: Deprecated, please use `isOnScreen` instead.
    @available(*, deprecated, renamed: "isOnScreen", message: "Please update code to use isOnScreen instead.")
    var isVisible: Bool {
        self.isViewLoaded == true && self.view.window != nil
    }

    /// Returns `true` if the view is on screen.
    ///
    /// Receiving `true` does not mean that the view is actually visible, only that it is in the currently
    /// displayed view stack.
    var isOnScreen: Bool {
        self.isViewLoaded == true && self.view.window != nil
    }

    /// Returns the currently visible view controller.
    ///
    /// Untested, may be removed in a future version.
    
    @available(*, deprecated, message: "Please use isOnScreen instead; the new and more approriately named state variable")
    func visibleViewController() -> UIViewController? {
        guard !(self is UINavigationController) else {
            let navVC = self as! UINavigationController
            return navVC.topViewController?.visibleViewController()
        }
        
        guard !(self is UITabBarController) else {
            let tabVC = self as! UITabBarController
            return tabVC.selectedViewController?.visibleViewController()
        }
        
        if self.presentedViewController == nil ||
            self.presentedViewController!.isBeingDismissed {
            return self
        }
        
        return self.presentedViewController?.visibleViewController()
    }

}
