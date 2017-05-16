//
//  UINavigationBar+BorderColor.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 16.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setBottomBorder(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
