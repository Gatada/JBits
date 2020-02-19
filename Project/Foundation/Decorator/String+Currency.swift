//
//  String+Currency.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import Foundation




public extension String.StringInterpolation {
    
    enum CurrencyDecimalStyle {
        case always
        case whenRequired
        case never
    }
    
    /// The default currency locale used when none is provided to the string interpolation below.
    static var currencyLocale = Locale(identifier: "en_GB")
    
    /// Creates a number formatter specifically for currencies and formats
    /// the output according to the decimal style provided.
    ///
    /// The integer amount includes the fraction, which basically means
    /// multiplied by the number of digits needed by the fraction.
    ///
    /// # Example
    /// ```
    /// let amount = 120
    /// print("\(amount, forcedLocale: Locale(identifier: "en_GB"))")
    /// // £1.20
    /// ```
    ///
    /// - Parameters:
    ///   - amount: The integer value including the fraction.
    ///   - showDecimals: The `CurrencyDecimalStyle` which indicates how many digits are shown of the fraction.
    ///   - forcedLocale: The locale with a valid ISO identifier.
    mutating func appendInterpolation(integerAmount amount: Int, showDecimals: CurrencyDecimalStyle, forcedLocale: Locale = currencyLocale) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = forcedLocale
        
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

}
