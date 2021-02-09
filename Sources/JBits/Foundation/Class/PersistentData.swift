//
//  PersistentData.swift
//  Utility
//
//  Created by Monteverde, Pedro on 24/07/2019.
//  Modified by Basberg, Johan.
//

import Foundation

public enum PersistentDataError: Error {
    case failedToEncodeData
}

extension PersistentDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToEncodeData:
            return NSLocalizedString("Failed to encode data needed for save operation; no file was created.", bundle: .module, comment: "The localized error returned when PersistentData.save(_:as:saveInDocumentDirectory:) failed to encode data needed for file.")
        }
    }
}

public enum PersistentData {
    
    /// Saves Encodables to the Caches directory, or optionally to the documents folder.
    ///
    /// - Parameters:
    ///   - object: Encodable to save
    ///   - fileName: what to name the file where the encodable data will be saved
    ///   - isDocument: Set to true so save file to documents directory. By default the caches directory is used.
    @discardableResult
    public static func save<T: Encodable>(_ object: T, as fileName: String, saveInDocumentDirectory isDocument: Bool = false) throws -> Bool {
        
        let fileFolder: FileManager.SearchPathDirectory = isDocument ? .documentDirectory : .cachesDirectory
        
        guard let url = FileManager.default.urls(for: fileFolder, in: .userDomainMask).first else {
            return false
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(object)
            return FileManager.default.createFile(atPath: "\(url.path)/\(fileName)", contents: data, attributes: nil)
        } catch {
            throw PersistentDataError.failedToEncodeData
        }
    }
    
    /// Loads Decodables from the Caches directory (default) or optionally to the user document directory.
    ///
    /// - Parameters:
    ///   - fileName: name of the file where the decodable data is saved
    ///   - type: Decodable type (e.g. Table.self)
    ///   - isDocument: Set to true so save file to documents directory. By default the caches directory is used.
    /// - Returns: Decoded Decodable model(s) of data
    public static func load<T: Decodable>(_ fileName: String, as type: T.Type, fromDocumentDirectory isDocument: Bool = false) -> T? {
        let fileFolder: FileManager.SearchPathDirectory = isDocument ? .documentDirectory : .cachesDirectory
        guard let url = FileManager.default.urls(for: fileFolder, in: .userDomainMask).first else {
            return nil
        }
        
        let path = "\(url.path)/\(fileName)"
        
        if !FileManager.default.fileExists(atPath: path) {
            return nil
        }
        
        if let data = FileManager.default.contents(atPath: path), !data.isEmpty {

            let decoder = JSONDecoder()
            let model = try? decoder.decode(type, from: data)
            return model

        } else {
            // Missing or empty file
            return nil
        }
    }
    
    @discardableResult
    public static func removeFile(_ filename: String, fromDocumentDirectory isDocument: Bool = false) -> Bool {
        let fileFolder: FileManager.SearchPathDirectory = isDocument ? .documentDirectory : .cachesDirectory
        guard var url = FileManager.default.urls(for: fileFolder, in: .userDomainMask).first else {
            assertionFailure("Failed to locate folder for filename \(filename)")
            return false
        }
        
        url.appendPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
}
