//
//  String.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

public extension String {
    
    /// Returns the address pointer for the provided instance as a string.
    ///
    /// - Parameter object: The instance to obtain the address pointer from.
    static func pointerFor(_ object: AnyObject?) -> String {
        
        guard let object = object else {
            return "nil"
        }
        
        let pointer: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: pointer)
    }
    
    
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
    
    
    /// Mutates string to a percent encoded string suitable for encoding URL query parameters in an URL object.
    mutating func percentEncoded(allowing characters: CharacterSet? = nil) {
        
        var allowedCharacters: CharacterSet

        if characters != nil {
            allowedCharacters = characters!
        } else {
            // Making a default character set that is valid for query parameters:
            var querySet = NSCharacterSet.urlQueryAllowed
            querySet.remove(charactersIn: "+&")
            allowedCharacters = querySet
        }
        
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            assertionFailure("Failed to encode string using allowed characters.")
            
            // The safest fallback is to simply the parameter to an empty string:
            self = ""
            return
        }
        
        self = encodedString
    }
    
    
    /// Access each character of a string using the desired index.
    subscript (i: Int) -> Character {
        return Array(self)[i]
    }
    
    
    /// Returns the approximate time required to read the text.
    ///
    /// If the text is technical and considered hard to process set `ìsTechnicalText` to `true`
    /// to reduce the reading time to about half.
    ///
    /// - Parameter isTechnicalText: `true` if the text is considered complicated or technical.
    func readingTime(isTechnicalText: Bool = false) -> TimeInterval {
    
        // Based on the following facts we get about 0.3 seconds per word:
        //
        //   * an adult reads about 250 words per minute on an average.
        //   * a slow reader usually reads about 150 to 200 words per minute.
        //   * for technical contents, the average reading speed is about 50-75 words per minute.
        //
        // Split the text into words (using punctuation, whitespaces and lines) to calculate the
        // duration it will take to read the text.
        
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = self.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        
        let timeNoticingTheText = TimeInterval(1)
        
        let averageTimeReadingEachWord: TimeInterval
        if isTechnicalText {
            averageTimeReadingEachWord = 0.7
        } else {
            averageTimeReadingEachWord = words.count > 10 ? 0.3 : 0.2
        }
        
        return timeNoticingTheText + (Double(words.count) * averageTimeReadingEachWord)
    }
}
