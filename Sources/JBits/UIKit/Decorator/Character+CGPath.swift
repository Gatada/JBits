//
//  Character.swift
//  Letterlock
//
//  Created by Johan H. W. L. Basberg on 07/09/2017.
//  Copyright © 2017 Johan Basberg. All rights reserved.
//

import CoreGraphics
import UIKit

extension Character {
    
    
    /// Creates and returns the CGPath for the provided character.
    func cgPath(withFont font: UIFont) -> CGPath {
        let unichars = [UniChar](String(self).utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs: Bool = CTFontGetGlyphsForCharacters(font, unichars, &glyphs, unichars.count)
        
        guard gotGlyphs, let glyph = glyphs.first, let cgpath = CTFontCreatePathForGlyph(font, glyph, nil) else {
            fatalError("No path created for character")
        }
        
        return cgpath
    }
}
