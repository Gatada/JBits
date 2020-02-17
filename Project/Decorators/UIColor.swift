//
//  UIColor.swift
//  JBits
//
//  Created by Johan Basberg on 04/08/2016.
//

import UIKit

extension UIColor {
    
    /// Returns a new `UIColor` that will have a brightness
    /// offset that makes it stand out from the source color.
    ///
    /// This is quite useful when you need to dynamically find a color that is
    /// easily readable, that stands out from the background, while also being
    /// pleasing to the eye when shown next to or on top of the source color.
    ///
    /// If the color is not in a compatible color space, the returned color will
    /// be the same as the source color (i.e. unchanged); additionally an assert
    /// failure is thrown.
    func contrastingColor() -> UIColor {
        
        var hue: CGFloat = 1
        var saturation: CGFloat = 1
        var brightness: CGFloat = 1
        var alpha: CGFloat = 1
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha), "Color is not UIColor.getHue compatible.") else {
            assertionFailure("Color is not in a compatible color space")
            return self
        }
        
        return UIColor(hue: hue, saturation: saturation, brightness: ((brightness + 0.5).truncatingRemainder(dividingBy: 1)), alpha: alpha)
    }

    
    /// Returns a color with an adjusted intensity, increasingly darker by a higher shadow value.
    ///
    /// If the color is not in a compatible color space, the returned color will
    /// be the same as the source color (i.e. unchanged); additionally an assert
    /// failure is thrown.
    ///
    /// - Parameter shadow: The darkness level of the shadow, 0 is no shadow and 1 is maximum shadow.
    /// - Returns: A new color where a shadow of 1 results in a black color, while 0 returns an unchanged color (no shadow).
    func withShadowComponent(_ shadow: CGFloat) -> UIColor {
        
        let shadow = 1 - shadow
        var red: CGFloat = 1
        var green: CGFloat = 1
        var blue: CGFloat = 1
        var alpha: CGFloat = 1
        
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            assertionFailure("Color is not in a compatible color space")
            return self
        }
        
        return UIColor(red: red * shadow, green: green * shadow, blue: blue * shadow, alpha: alpha)
    }

    
    /// Returns a new `UIColor` with the provided saturation level.
    ///
    /// With a new saturation value of 0 the returned color is unchanged. Providing
    /// a value of 1 will return a fully desaturated color.
    ///
    /// If the color is not in a compatible color space, the returned color will
    /// be the same as the source color (i.e. unchanged); additionally an assert
    /// failure is thrown.
    ///
    /// - Parameter newSaturation: The new saturation level, ranging from 0 (no change) to 1 (full desaturated).
    func withSaturation(_ newSaturation: CGFloat) -> UIColor {
        
        var current: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
        
        guard getRed(&current.red, green: &current.green, blue: &current.blue, alpha: &current.alpha) else {
            assertionFailure("Color is not in a compatible color space")
            return self
        }

        let brightnessRed = 0.299 * pow(current.red, 2)
        let brightnessGreen = 0.587 * pow(current.green, 2)
        let brightnessBlue = 0.114 * pow(current.blue, 2)
        let perceivedBrightness = sqrt(brightnessRed + brightnessGreen + brightnessBlue)
        
        let newRed = current.red + newSaturation * (perceivedBrightness - current.red)
        let newGreen = current.green + newSaturation * (perceivedBrightness - current.green)
        let newBlue = current.blue + newSaturation * (perceivedBrightness - current.blue)
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: current.alpha)
    }
    
    
}
