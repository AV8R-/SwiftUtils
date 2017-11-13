//
//  String+Size.swift
//  Jobok
//
//  Created by Богдан Маншилин on 08/11/2017.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        return self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        return self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let targetContext = NSStringDrawingContext()
        return boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: targetContext).size
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGSize {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let targetContext = NSStringDrawingContext()
        return boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: targetContext).size
    }
}
