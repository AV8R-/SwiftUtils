//
//  UIView+Constrain.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 26.04.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

enum UIError: Error {
    case noSuperview
}

enum UIViewBounds {
    case top(CGFloat), left(CGFloat), bottom(CGFloat), right(CGFloat)
    
    func constrain(view: UIView, to: UIView) {
        switch self {
        case let .top(constant):    view.topAnchor.constraint(equalTo: to.topAnchor, constant: constant).isActive = true
        case let .left(constant):   view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: constant).isActive = true
        case let .bottom(constant): view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -constant).isActive = true
        case let .right(constant):  view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: -constant).isActive = true
        }
    }
}

extension UIViewBounds {
    static let topMargin = UIViewBounds.top(0)
    static let leftMargin = UIViewBounds.left(0)
    static let bottomMargin = UIViewBounds.bottom(0)
    static let rightMargin = UIViewBounds.right(0)
}

extension UIView {
    func constrainSuperview(bounds: UIViewBounds...) throws {
        guard let superview = superview else {
            throw UIError.noSuperview
        }
        var bounds = bounds
        if bounds.count == 0 {
            bounds = [.topMargin, .leftMargin, .bottomMargin, .rightMargin]
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        bounds.forEach { $0.constrain(view: self, to: superview) }
    }
}

