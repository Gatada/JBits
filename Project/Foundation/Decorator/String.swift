//
//  String.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

public extension String {
    
    /// Returns a string that has the first character capitalized, and the
    /// remaining string unchanged.
    func capitalizedFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    
    /// Returns a upper camel case formatted string.
    ///
    /// This means removing spaces and capitalizing the
    /// first letter of every word.
    ///
    /// ## Example
    /// ```
    /// "HEllo I -, AM".upperCamelCased
    /// // HelloI-,Am"
    ///
    /// "Custom Table 25".upperCamelCased
    /// // CustomTable25
    /// ```
    var upperCamelCased: String {
        return self.lowercased()
            .split(separator: " ")
            .map { return $0.lowercased().capitalizedFirstLetter() }
            .joined()
    }
    
    
    /// Returns a lower camel case formatted string.
    ///
    /// This means removing spaces and capitalizing all
    /// but the first letter of every word.
    ///
    /// ## Example
    /// ```
    /// "HEllo I -, AM".lowerCamelCased
    /// // helloI-,Am"
    ///
    /// "Custom Table 25".lowerCamelCased
    /// // customTable25
    /// ```
    var lowerCamelCased: String {
        let upperCased = self.upperCamelCased
        return upperCased.prefix(1).lowercased() + upperCased.dropFirst()
    }
        
    
    /// Returns the percent encoded equivalent of a string, used for encoding URL query parameters in an URL object.
    var urlEncoded: String {
        var allowedCharacters: CharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacters.remove(charactersIn: "!*'();:@&=-~+$,/?%#[]")
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            assertionFailure("Failed to URL encode the string")
            return self
        }
        return encodedString
    }
    
    
    /// Easy w
    subscript (i: Int) -> Character {
        return Array(self)[i]
    }
}
