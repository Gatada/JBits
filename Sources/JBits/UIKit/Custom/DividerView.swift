//
//  DividerView.swift
//  JBits
//
//  Created by Johan H. W. L. Basberg on 17/08/2017.
//  Copyright © 2017 Johan Basberg. All rights reserved.
//

import UIKit

/// Creates a view with an optional hairline at the top, and optional hairline at the bottom.
class DividerView: UIView {

    @IBInspectable var hairlineColor: UIColor? = nil
    
    @IBInspectable var showLineTop: Bool = false
    @IBInspectable var showLineBottom: Bool = true
    
    @IBInspectable var weightTop: CGFloat = 1 / UIScreen.main.scale
    @IBInspectable var weightBottom: CGFloat = 1 / UIScreen.main.scale
    
    var dividerTop, dividerBottom: UIView?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = UIColor(named: "Dark")?.withAlphaComponent(0.1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        var constraints = [NSLayoutConstraint]()
        
        let color = (hairlineColor ?? UIColor.systemGray).withAlphaComponent(0.5)
        
        if showLineTop && dividerTop == nil {
            let topHairline = UIView()
            topHairline.backgroundColor = color
            topHairline.translatesAutoresizingMaskIntoConstraints = false
            addSubview(topHairline)
            dividerTop = topHairline

            let views: [String: UIView] = ["divider": topHairline]
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "|[divider]|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[divider(height)]", options: [], metrics: ["height": weightTop], views: views)
        }
        
        if showLineBottom && dividerBottom == nil {
            dividerBottom = UIView()
            dividerBottom!.backgroundColor = color
            dividerBottom!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dividerBottom!)

            let views: [String: UIView] = ["divider": dividerBottom!]
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "|[divider]|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[divider(height)]|", options: [], metrics: ["height": weightBottom], views: views)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
