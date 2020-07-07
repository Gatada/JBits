//
//  String.StringInterpolations.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation


public extension String.StringInterpolation {
    
    
    /// The display style of the currency amount.
    enum CurrencyDecimalStyle {
        
        /// Always show the fraction of the number, even when the fraction is zero.
        ///
        /// This type is needed when using the currency string interpolation extension.
        case always
        
        /// Shows the fraction of the amount only when the fraction is non-zero.
        ///
        /// This type is needed when using the currency string interpolation extension.
        case whenRequired
        
        /// Never shows the fraction of the amount, even when the fraction is non-zero.
        ///
        /// This type is needed when using the currency string interpolation extension.
        case never
    }
    
    /// Creates a number formatter specifically for currencies and formats
    /// the output according to the decimal style provided.
    ///
    /// The integer amount includes the fraction, which basically means
    /// multiplied by the number of digits needed by the fraction.
    ///
    /// # Example
    /// ```
    /// let amount = 120
    /// print("\(integerAmount: amount, forcedLocale: Locale(identifier: "en_GB"))")
    /// // £1.20
    /// ```
    ///
    /// - Parameters:
    ///   - amount: The integer value including the fraction.
    ///   - showDecimals: The `CurrencyDecimalStyle` which indicates how many digits are shown of the fraction.
    ///   - forcedLocale: The locale with a valid ISO identifier.
    mutating func appendInterpolation(integerAmount amount: Int, showDecimals: CurrencyDecimalStyle, forcedLocale: Locale = Locale.current) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = forcedLocale
        
        Log.da("Currency amount string interpolation is using locale: \(forcedLocale)", log: .info)
        assert(forcedLocale.currencySymbol != "¤", "Current device does not have a valid region set. Fix this on the device in Settings > Language & Region")
        
        if showDecimals == .never {
            formatter.roundingMode = .floor
        } else {
            formatter.roundingMode = .halfEven
        }
        
        let maximumFraction = formatter.maximumFractionDigits
        let decimalFactor = powf(10, Float(maximumFraction))
        let adjustedAmount = Float(amount) / decimalFactor
        
        switch showDecimals {
        case .always:
            formatter.minimumFractionDigits = maximumFraction
            formatter.maximumFractionDigits = maximumFraction
        case .whenRequired:
            if amount % Int(decimalFactor) > 0 {
                formatter.minimumFractionDigits = maximumFraction
                formatter.maximumFractionDigits = maximumFraction
            } else {
                // Fallthrough to zero decimals.
                fallthrough
            }
        case .never:
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        }
        
        if let result = formatter.string(from: adjustedAmount as NSNumber) {
            appendLiteral(result)
        }
    }
    
    /// Creates a number formatter specifically for currencies and formats
    /// the output according to the decimal style provided.
    ///
    /// The integer amount includes the fraction, which basically means
    /// multiplied by the number of digits needed by the fraction.
    ///
    /// # Example
    /// ```
    /// let amount = 120
    /// print("\(integerAmount: amount, forcedLocale: Locale(identifier: "en_GB"))")
    /// // £1.20
    /// ```
    ///
    /// - Parameters:
    ///   - amount: The float value of the amount.
    ///   - showDecimals: The `CurrencyDecimalStyle` which indicates how many digits are shown of the fraction.
    ///   - forcedLocale: The locale with a valid ISO identifier.
    mutating func appendInterpolation(floatAmount amount: Float, showDecimals: CurrencyDecimalStyle, forcedLocale: Locale = Locale.current) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = forcedLocale
        
        Log.da("Currency amount string interpolation is using locale: \(forcedLocale)", log: .info)
        assert(forcedLocale.currencySymbol != "¤", "Current device does not have a valid region set. Fix this on the device in Settings > Language & Region")
        
        if showDecimals == .never {
            formatter.roundingMode = .floor
        } else {
            formatter.roundingMode = .halfEven
        }
        
        let maximumFraction = formatter.maximumFractionDigits
        let decimalFactor = powf(10, Float(maximumFraction))
        
        switch showDecimals {
        case .always:
            formatter.minimumFractionDigits = maximumFraction
            formatter.maximumFractionDigits = maximumFraction
        case .whenRequired:
            if amount.truncatingRemainder(dividingBy: decimalFactor) > 0 {
                // Decimals are needed
                formatter.minimumFractionDigits = maximumFraction
                formatter.maximumFractionDigits = maximumFraction
            } else {
                // Fallthrough to zero decimals.
                fallthrough
            }
        case .never:
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        }
        
        if let result = formatter.string(from: amount as NSNumber) {
            appendLiteral(result)
        }
    }
    
    
    mutating func appendInterpolation(memoryLocationFor instance: AnyObject?) {
        guard let object = instance else {
            appendLiteral("nil")
            return
        }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        appendLiteral(String(describing: opaque))
    }
}

