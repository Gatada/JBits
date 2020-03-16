//
//  URL.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation

public extension URL {
    
    /// Will append the query item and value to the URL.
    ///
    /// No HTML entity formatting is done to the received strings.
    /// - Parameters:
    ///   - queryItem: The percent encoded query string that will hold a value.
    ///   - value: A percent encoded string assigned to the query item.
    mutating func append(_ queryItem: String, value: String? = nil) {
        
        guard var urlComponents = URLComponents(string: absoluteString) else {
            assertionFailure("Provided URL does not have an absolute string")
            return
        }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        self = urlComponents.url!
    }
}
