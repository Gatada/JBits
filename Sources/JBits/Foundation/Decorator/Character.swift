//
//  Character.swift
//  Letterlock
//
//  Created by Johan H. W. L. Basberg on 07/09/2017.
//  Copyright © 2017 Johan Basberg. All rights reserved.
//

import Foundation

extension Character: Codable {
    
    /// Adds comformance to encoding a `Character`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(String(self))
    }
    
    /// Adds comformance to decode a `Character`.
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

