//
//  Log.swift
//  JBits
//
//  Created by Johan Basberg on 16/12/2019.
//  Copyright © 2019 Johan Basberg. All rights reserved.
//

import Foundation
import os.log


/// Logging related helpers, details and types used by `xc_log()`.
public enum Log {
    
    // MARK: - Properties
    
    /// The logging category to be used for the log message.
    ///
    /// The category will determine if the message is printed only
    /// in the Xcode console or also output in the Terminal for the
    /// given process.
    public enum Category: String {
        
        /// The `default` log level used for general output.
        ///
        /// Logs of this kind are usually temporary, and are therefore
        /// removed after the feature has been completely implemented.
        case `default`
        
        /// The `info` log level used to output state information.
        ///
        /// Info logs will usually be left in the application even
        /// after the feature is fully implemented.
        case info
        
        /// The `debug` log level is used to log state expectations
        /// to prevent errors.
        ///
        /// An error marks the result of a bug. Errors are hard to catch,
        /// which is why debug logs are some times used.
        ///
        /// When the wrong variable is used or the design is incorrectly
        /// implemented by the developer the result is an error. If a variable
        /// is received with unexpected or invalid values an error occurs.
        ///
        /// Ideally messages using this log category should be self-contained and
        /// their validity verifiable. In other words, include your expectation and the
        /// actual value:
        ///
        /// `Expecting 5 == 4`
        ///
        /// Debug output will usually be removed after the feature has been
        /// fully implemented.
        case debug
        
        /// A `fault` indicates unintended behaviour usually as a result
        /// of an error.
        ///
        /// When an application executes code that were not suppose to be
        /// reached, you experience a fault. A fault could be a non-critical anomaly
        /// that emerges from refactoring.
        ///
        /// Fault logs are useful for the inevitable refactoring and should
        /// therefore not be removed.
        case fault
        
        /// A failure is the formal inability to fulfill performance requirements.
        ///
        /// Tests can be used to prevent failure. Assertions can also be
        /// used to catch or inform the developer about failures even
        /// before testing begins.
        case failure
        
        
        var emoji: StaticString {
            switch self {
            case .default:
                return "📎"
            case .info:
                return "ℹ️"
            case .debug:
                return "🧑🏼‍💻"
            case .fault:
                return "⁉️"
            case .failure:
                return "❌"
            }
        }
        
        var osLogEquivalent: OSLog {
            switch self {
            case .default:
                return OSLog.default
            case .info:
                return OSLog.info
            case .debug:
                return OSLog.debug
            case .fault:
                return OSLog.fault
            case .failure:
                return OSLog.failure
            }
        }
        
        var osLogTypeEquivalent: OSLogType {
            switch self {
            case .default, .info, .debug:
                return OSLogType.default
            case .fault:
                return OSLogType.fault
            case .failure:
                return OSLogType.error
            }
        }
    }

    /// The default subsystem used when logging.
    public static let mainBundle = Bundle.main.bundleIdentifier!


    // MARK: - Private Helpers

    /// Prints the message received in the Xcode debug area.
    private static func debugAreaPrint(_ messages: [String], terminator: String, log: Log.Category, subsystem: String) -> Bool {
        print("\(log.emoji) \(timestamp()) \(subsystem) –", terminator: "")
        for message in messages {
            print(" " + message, terminator: "")
        }
        print("", terminator: terminator)
        return true
    }
    
    /// Calling this will generate a log message that will be collected by the Console
    /// app on your Mac.
    ///
    /// To review the resulting log messages please launch the Console app on your Mac.
    /// Make sure you have selected the correct device when browsing the messages.
    ///
    /// - Note:
    /// To enable logging with the OS logging system the `OS_ACTIVITY_MODE` option found
    /// in the the build scheme cannot be disabled.
    private static func osPrint(_ messages: [String], terminator: String, log: Log.Category, subsystem: String) {
        for message in messages {
            os_log("%{private}@", log: log.osLogEquivalent, type: log.osLogTypeEquivalent, message)
        }
    }
    
    
    /// Creates a timestamp used as part of the temporary logging in the debug area.
    static func timestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: date)
    }
    

    /// Use to temporary log events in the Xcode debug area (the console).
    ///
    /// These calls will be completely removed for release or any non-debugging build.
    public static func tmp(_ messages: String..., terminator: String = "\n", log: Log.Category = .default, subsystem: String = Log.mainBundle) {
        assert(Log.debugAreaPrint(messages, terminator: terminator, log: log, subsystem: subsystem))
    }
    
    /// Use to send messages to the OS logging system.
    ///
    /// The messages received will be retained in a cyclic buffer managed
    /// by the operating system.
    ///
    /// - Note:
    /// To enable logging with the OS logging system the `OS_ACTIVITY_MODE` option found
    /// in the the build scheme cannot be disabled.
    public static func os(_ messages: String..., terminator: String = "\n", log: Log.Category = .default, subsystem: String = Log.mainBundle) {
        osPrint(messages, terminator: terminator, log: log, subsystem: subsystem)
    }
    
    /// Send a message to both the Xcode debug area and the OS logging system.
    /// - Note:
    /// To enable logging with the OS logging system the `OS_ACTIVITY_MODE` option found
    /// in the the build scheme cannot be disabled.
    public static func both(_ messages: String..., terminator: String = "\n", log: Log.Category = .default, subsystem: String = Log.mainBundle) {
        osPrint(messages, terminator: terminator, log: log, subsystem: subsystem)
        assert(Log.debugAreaPrint(messages, terminator: "\n", log: log, subsystem: subsystem))
    }

}


// MARK: - Custom OSLog Categories

/// This extension uses the bundle identifier of the app and
/// creates a static instance for each category.
extension OSLog {

    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// The `default` log level used for general output.
    ///
    /// Logs of this kind are usually temporary, and are therefore
    /// removed after the feature has been completely implemented.
    static let `default` = OSLog(subsystem: subsystem, category: "default")

    /// Used to log state information.
    ///
    /// This is useful to log details could help improve the application, like the
    /// range of values used in a graph.
    ///
    /// Ensure the logged information do not violate any privacy policies, terms or
    /// conditions.
    static let info = OSLog(subsystem: subsystem, category: "info")

    /// Used to log debug information, like state expectations and values.
    ///
    /// Ideally messages using this log category should be self-contained and
    /// their validity verifiable. In other words, include your expectation and the
    /// actual value:
    ///
    /// ```
    /// Expecting 5 - Received 4
    ///
    /// ```
    static let debug = OSLog(subsystem: subsystem, category: "debug")
    
    /// A `fault` indicates unintended behaviour usually as a result
    /// of an error.
    ///
    /// Use this category when the application executes code that were not suppose to be
    /// reached, you experience a fault. A fault could be a non-critical anomaly
    /// that emerges from refactoring.
    static let fault = OSLog(subsystem: subsystem, category: "fault")
     
    /// A failure is the formal inability to fulfill performance requirements.
    ///
    /// Tests can be used to prevent failure. Assertions can also be
    /// used to catch or inform the developer about failures even
    /// before testing begins.
    static let failure = OSLog(subsystem: subsystem, category: "failure")
    
}
