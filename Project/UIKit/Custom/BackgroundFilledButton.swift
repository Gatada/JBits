//
//  BackgroundFilledButton.swift
//  TugOfWords
//
//  Created by Johan Basberg on 25/07/2019.
//  Copyright © 2019 Basberg, Johan. All rights reserved.
//

import UIKit


/// A button that makes the background fill color appear as if it was
/// an image; i.e. highlighting works as is commonly expected in iOS.
class BackgroundFilledButton: UIButton {
    
    override var buttonType: UIButton.ButtonType {
        return .custom
    }
    
    private var backgroundFill: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            if backgroundFill == nil {
                self.backgroundFill = backgroundColor
            }
            
            guard oldValue != isHighlighted else {
                // No change, bailing early
                return
            }
            
            let fill = isHighlighted ? backgroundFill?.withShadowComponent(0.3) : backgroundFill
            self.backgroundColor = fill
        }
    }

}
