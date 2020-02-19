//
//  TitleUnderImageButton.swift
//  JBits
//
//  Created by Johan Basberg on 18/02/2020.
//  Copyright © 2020 Johan Basberg. All rights reserved.
//

import UIKit

@IBDesignable
public class TitleUnderImageButton: UIButton {
    
    // MARK: - Properties
    
    let inset: CGFloat = 8
    
    // MARK: - Life Cycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerTitleLabel()
    }
    
    
    // MARK: - Setup

    private func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.2
    }
    
    
    // MARK: - Layout

    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        
        // FIXME: Adding an offset is very hacky
        return CGRect(x: (inset/2), y: contentRect.height - titleRect.height, width: contentRect.width - inset, height: titleRect.height)
    }

    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)

        return CGRect(x: contentRect.width/2.0 - rect.width/2.0, y: (contentRect.height - titleRect.height)/2.0 - rect.height/2.0, width: rect.width, height: rect.height)
    }
    
    
    // MARK: - Size Calculation

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize

        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0

            let labelSize = CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)
            if let size = titleLabel?.sizeThatFits(labelSize) {
                labelHeight = size.height
            }

            return CGSize(width: size.width + inset, height: image.size.height + labelHeight)
        }

        return size
    }

}
