//
//  Character.swift
//  Letterlock
//
//  Created by Johan H. W. L. Basberg on 07/09/2017.
//  Copyright © 2017 Johan Basberg. All rights reserved.
//

import UIKit

extension Character {
    
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

extension Character: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(String(self))
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let string = try container.decode(String.self)
        
        guard string.count == 1 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Multiple characters found when decoding a Character")
        }
        
        guard let character = string.first else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty String found when decoding a Character")
        }
        
        self = character
    }
    
}

