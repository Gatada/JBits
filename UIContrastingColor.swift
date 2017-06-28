//
//  UIContrasingColor.swift
//  JBUserInterface
//
//  Created by Basberg, Johan on 04/08/2016.
//

import UIKit

extension UIColor {
    
    func contrastingColor() -> UIColor {
        var hue: CGFloat = 1
        var saturation: CGFloat = 1
        var brightness: CGFloat = 1
        var alpha: CGFloat = 1
        assert(getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha), "Color is not UIColor.getHue compatible.")
        return UIColor(hue: hue, saturation: saturation, brightness: ((brightness + 0.5) % 1), alpha: alpha)
    }
    
}
