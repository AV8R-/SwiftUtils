//
//  UITextViewFixed.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 11.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero;
        textContainer.lineFragmentPadding = 0;
        
        // fix "space at bottom" insanity
        var b = bounds
        let h = sizeThatFits(CGSize(
            width: bounds.size.width,
            height: CGFloat.greatestFiniteMagnitude)
            ).height
        b.size.height = h
        bounds = b
    }
}
