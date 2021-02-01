//
//  UIApplicationDelegate.swift
//  TugOfWar
//
//  Created by Basberg, Johan on 22/03/2019.
//  Copyright © 2019 Basberg, Johan. All rights reserved.
//

import UIKit

public extension UIApplicationDelegate {

    
    /// Returns current version and build number as a string.
    ///
    /// It fetches the information from the info dictionary from
    /// the main bundle.
    ///
    static var versionBuild: String {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        var build: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as! String
        
        // A simple sanity check that hides a build number constisting of more
        // than five digits. I need this for my projects as the build script
        // isn't always executed - leaving me with the build numer placeholder.
        
        if build.count <= 5 {
            build = " (\(build))"
        } else {
            build = ""
        }
        
        return "\(version)\(build)"
    }    
}
