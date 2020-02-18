//
//  UIColor.swift
//  JBits
//
//  Created by Johan Basberg on 04/08/2016.
//

import UIKit

extension UIColor {
    
    /// Initialize a color from a hex value. Optionally include an alpha value, which defaults
    /// to 1 (no transparency).
    ///
    /// The hexidecimal is not case sensitive.
    ///
    /// To instantiate a UIColor using a hex value, you'll need to format the integer as a
    /// hexidecimal value. You do this by adding the hexidecimal prefix to the number: `0x`
    ///
    /// # Examples:
    /// ```swift
    /// UIColor(hex: 0xff0000) // Red
    /// UIColor(hex: 0xCDCDCD) // Gray
    /// ```
    ///
    /// - Parameters:
    ///   - hex: The integer that will be resolved to the red, green and blue color component.
    ///   - alpha: The alpha value of the color, default is 1 (full opacity, or no transparency).
    convenience init?(hex: UInt, alpha: CGFloat = 1) {
          
        guard hex <= 0xFFFFFF else {
            // Value is out of range; an invalid color
            return nil
        }
        
        let red = CGFloat((hex & 0xFF0000) >> 16)/255
        let green = CGFloat((hex & 0x00FF00) >> 8)/255
        let blue = CGFloat(hex & 0x0000FF)/255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    /// Returns a new `UIColor` that will have a brightness
    /// offset of 1, making it stand out from the source color.
    ///
    /// This is quite useful when you need to dynamically find a color that is
    /// easily readable against a backdrop, while also being easy on the eyes
    /// when shown next to or on top of the source color.
    ///
    /// If the color is not in a compatible color space, the returned color will
    /// be the same as the source color (i.e. unchanged); additionally an assert
    /// failure is thrown.
    func contrastingColor() -> UIColor {
        
        var hue: CGFloat = 1
        var saturation: CGFloat = 1
        var brightness: CGFloat = 1
        var alpha: CGFloat = 1
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
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
        var current: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
        
        guard getRed(&current.red, green: &current.green, blue: &current.blue, alpha: &current.alpha) else {
            assertionFailure("Color is not in a compatible color space")
            return self
        }

        return UIColor(red: current.red * shadow, current.green: green * shadow, current.blue: blue * shadow, alpha: current.alpha)
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
