//
//  PropertyList.swift
//  timewise
//
//  Created by Johan H. W. L. Basberg on 16/06/2018.
//  Copyright © 2018 Johan Basberg. All rights reserved.
//

import Foundation

public struct PropertyList {
    
    // MARK: - Properties
    
    static public func foundFile(_ filename: String) -> Bool {
        let fileManager = FileManager.default
        let path = documentPath(forFilename: filename)
        return fileManager.fileExists(atPath: path)
    }

    
    /// Reads the properties list from the bundle
    ///
    /// - Parameter filename: The name of the file to save to, excluding the file extension (file type).
    /// - Returns: The dictionary read from the bundled property list file.
    static public func fromBundle(filename: String) -> [String: Any]? {
        var bundledProperties: [String: Any]?
        if let path = Bundle.main.path(forResource: filename, ofType: "plist"), let properties: [String: Any] = NSDictionary(contentsOfFile: path) as? [String: Any] {
            bundledProperties = properties
        }
        return bundledProperties
    }
    
    
    /// Saves the dictionary to a file in the user documents folder.
    ///
    /// - Parameters:
    ///   - content: The dictionary to save.
    ///   - name: The name of the file to save to, excluding the file extension (file type).
    /// - Returns: A boolean, which is true iff dictionary was successfully saved.
    static public func save(dictionary content: [String: Any], toFilename name: String) -> Bool {
        let properties = NSDictionary(dictionary: content)
        let wasSuccessfullyWritten: Bool = properties.write(toFile: documentPath(forFilename: name), atomically: true)
        return wasSuccessfullyWritten
    }
    
    
    /// Loading from the user documents folder, or from the bundle if no file was found in the user documents folder.
    ///
    /// - Parameter name: Name of the file, excluding the file extension (file type).
    /// - Returns: An optional dictionary `[String: Any]?`
    static public func load(fromFile name: String) -> [String: Any]? {
        let fileManager = FileManager.default
        var loadedProperties: [String: Any]?
        
        if fileManager.fileExists(atPath: documentPath(forFilename: name)) {
            var savedProperties: [String: Any]?
            if let properties: [String: Any] = NSDictionary(contentsOfFile: documentPath(forFilename: name)) as? [String: Any] {
                savedProperties = properties
            }
            return savedProperties
        } else {
            loadedProperties = PropertyList.fromBundle(filename: name)
        }
        return loadedProperties
    }
    
    static public func removeFile(named name: String) {
        let fileManager = FileManager.default
        let path = documentPath(forFilename: name)
        try? fileManager.removeItem(atPath: path)
    }
    
    // MARK: - Helper
    
    
    /// The full default documents folder path. Use this path so read or write files to the user's documents folder.
    ///
    /// - Parameter name: Name of the file to be saved, excluding the file extension (file type).
    /// - Returns: Returns the full path to the file in the user documents folder, including file name and type.
    static public func documentPath(forFilename name: String) -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return documentDirectory.appending("/\(name).plist")
    }


}
