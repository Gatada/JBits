//
//  NSCharacterSet.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//
//  Credit to Keehun Nam for the parsing of a NSCharacterSet to a string array.
//
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

public extension NSCharacterSet {

    
    /// Returns a character set as an array of strings.
    ///
    /// Useful for printing a character set while debugging.
    /// ```
    /// var allowedCharacters: CharacterSet = CharacterSet.urlQueryAllowed
    /// allowedCharacters.remove(charactersIn: "!*'();:@&=-~+$,/?%#[]")
    ///
    /// for character in (allowedCharacters as NSCharacterSet).characters {
    ///     print(character, terminator: "")
    /// }
    /// ```
    var characters: [String] {
        
        /// An array to hold all the found characters
        var characters: [String] = []

        /// Iterate over the 17 Unicode planes (0..16)
        for plane:UInt8 in 0..<17 {
            
            /// Iterating over all potential code points of each plane could be expensive as
            /// there can be as many as 2^16 code points per plane. Therefore, only search
            /// through a plane that has a character within the set.
            if self.hasMemberInPlane(plane) {

                /// Define the lower end of the plane (i.e. U+FFFF for beginning of Plane 0)
                let planeStart = UInt32(plane) << 16
                
                /// Define the lower end of the next plane (i.e. U+1FFFF for beginning of
                /// Plane 1)
                let nextPlaneStart = (UInt32(plane) + 1) << 16

                /// Iterate over all possible UTF32 characters from the beginning of the
                /// current plane until the next plane.
                for char: UTF32Char in planeStart..<nextPlaneStart {

                    /// Test if the character being iterated over is part of this
                    /// `NSCharacterSet`
                    if self.longCharacterIsMember(char) {

                        /// Convert `UTF32Char` (a typealiased `UInt32`) into a
                        /// `UnicodeScalar`. Otherwise, converting `UTF32Char` directly
                        /// to `String` would turn it into a decimal representation of
                        /// the code point, not the character.
                        if let unicodeCharacter = UnicodeScalar(char) {
                            characters.append(String(unicodeCharacter))
                        }
                    }
                }
            }
        }
        return characters
    }
    
}
