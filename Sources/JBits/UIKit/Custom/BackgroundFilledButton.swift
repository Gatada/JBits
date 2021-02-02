//
//  BackgroundFilledButton.swift
//  TugOfWords
//
//  Created by Johan Basberg on 25/07/2019.
//  Copyright © 2019 Basberg, Johan. All rights reserved.
//

import UIKit


/// A button that makes the background fill color behave as if it was
/// an image; i.e. highlighting works as is commonly expected in iOS.
///
/// When the button is disabled the fill color will be desaturated, which will very likely result in different
/// shades of gray. If this is not desired, ie. you want the same gray color for all disabled buttons,
/// you will need to set `useDesaturation` to `false`.
public class BackgroundFilledButton: UIButton {
    
    @IBInspectable public var useDesaturation = true
    
    /// This is a custom button that will not  behave as expected without
    /// being a `.custom` button type.
    override public var buttonType: UIButton.ButtonType {
        return .custom
    }
    
    /// Used to retain original background color.
    private var backgroundFill: UIColor?
    
    public var fillColor: UIColor? {
        set {
            backgroundFill = newValue
            updateButtonState()
        }
        get {
            return backgroundFill
        }
    }
    
    /// While the button is higlighted a 30% shadow is added to the
    /// background color.
    override public var isHighlighted: Bool {
        didSet {
            
            guard isEnabled else {
                return
            }
            
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
    
    /// The enabled state of the button.
    ///
    /// While the button is disabled the background color will be desaturated.
    override public var isEnabled: Bool {
        didSet {
            updateButtonState()
        }
    }
    

    // MARK: - Life Cycle
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateButtonState()
    }    
    
    // MARK: - Helper
    
    private func updateButtonState() {
        if backgroundFill == nil {
            backgroundFill = backgroundColor
        }
        
        let disabledColor: UIColor? = useDesaturation ? backgroundFill?.withSaturation(0) : UIColor.systemGray
        backgroundColor = isEnabled ? backgroundFill : disabledColor
    }


}
