//
//  UIColor.swift
//  JBits
//
//  Created by Johan Basberg on 04/08/2016.
//

import UIKit

extension UIColor {
    
    /// Returns a new `UIColor` that will be have a brightness
    /// offset that makes it stand out from the source color.
    ///
    /// Whenever you need to dynamically find a color that is
    /// easily readable, that stands out while being harmounous
    /// when shown next to or on top of the source color - then
    /// using this makes perfect sense.
    func contrastingColor() -> UIColor {
        var hue: CGFloat = 1
        var saturation: CGFloat = 1
        var brightness: CGFloat = 1
        var alpha: CGFloat = 1
        assert(getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha), "Color is not UIColor.getHue compatible.")
        return UIColor(hue: hue, saturation: saturation, brightness: ((brightness + 0.5).truncatingRemainder(dividingBy: 1)), alpha: alpha)
    }
    
}
