//
//  BackgroundFilledButton.swift
//  TugOfWords
//
//  Created by Johan Basberg on 25/07/2019.
//  Copyright © 2019 Basberg, Johan. All rights reserved.
//

import UIKit


class BackgroundFilledButton: UIButton {
    
    override var buttonType: UIButton.ButtonType {
        return .custom
    }
    
    var backgroundFill: UIColor?
    
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
