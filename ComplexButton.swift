//
//  ComplexButton.swift
//  UltimateGuitar
//
//  Created by Bogdan Manshilin on 3/18/17.
//
//

import UIKit

class ComplexButton: UIControl {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initOverlayButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initOverlayButton()
    }
    
    lazy var nestedButtons: [UIButton] = {
        var buttons = [UIButton]()
        let count = self.subviews.count - 1 > 0 ? self.subviews.count - 1 : 0
        let sbviews = Array(self.subviews[0..<1])
        self.recursive(subviews: sbviews) {
            if let button = $0 as? UIButton {
                buttons.append(button)
            }
        }
        return buttons
    }()
    
    private weak var overlay: UIButton!
    
    private func initOverlayButton() {
        let overlay = UIButton()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlay)
        overlay.addConstraintsToSuperviewBounds()
        overlay.addObserver(self, forKeyPath: "highlighted", options: .new, context: nil)
        overlay.addObserver(self, forKeyPath: "selected", options: .new, context: nil)
        overlay.addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
        
        self.overlay = overlay
    }
    
    override var isEnabled: Bool { didSet {
        self.nestedButtons.forEach { $0.isEnabled = isEnabled }
    }}

    override var isSelected: Bool { didSet {
        self.nestedButtons.forEach { $0.isSelected = isSelected }
    }}

    override var isHighlighted: Bool { didSet {
        let count = subviews.count - 1 > 0 ? subviews.count - 1 : 0
        let alpha: CGFloat = isHighlighted ? 0.3 : 1
        for subview in subviews[0..<count] {
            subview.alpha = alpha
        }
    }}
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.bringSubview(toFront: overlay)
    }
    
    override func addSubview(_ view: UIView) {
        if let overlay = overlay {
            insertSubview(view, belowSubview: overlay)
        } else {
            super.addSubview(view)
        }
    }
    
    override var contentVerticalAlignment: UIControlContentVerticalAlignment { didSet {
        self.nestedButtons.forEach { $0.contentVerticalAlignment = contentVerticalAlignment }
    }}
    
    override var contentHorizontalAlignment: UIControlContentHorizontalAlignment{ didSet {
        self.nestedButtons.forEach { $0.contentHorizontalAlignment = contentHorizontalAlignment }
    }}
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.nestedButtons.forEach { $0.beginTracking(touch, with: event) }
        return super.beginTracking(touch, with: event)
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.nestedButtons.forEach { $0.continueTracking(touch, with: event) }
        return super.continueTracking(touch, with: event)
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.nestedButtons.forEach { $0.endTracking(touch, with: event) }
        return super.endTracking(touch, with: event)
    }

    override func cancelTracking(with event: UIEvent?) {
        self.nestedButtons.forEach { $0.cancelTracking(with: event) }
        super.cancelTracking(with: event)
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        overlay.addTarget(target, action: action, for: controlEvents)
    }
    
    override func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        overlay.removeTarget(target, action: action, for: controlEvents)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let newValue = change![.newKey] as! Bool
        switch keyPath {
        case "highlighted"?: isHighlighted = newValue
        case "selected"?: isSelected = newValue
        case "enabled"?: isEnabled = newValue
        default:()
        }
    }
    
    deinit {
        overlay.removeObserver(self, forKeyPath: "highlighted")
        overlay.removeObserver(self, forKeyPath: "selected")
        overlay.removeObserver(self, forKeyPath: "enabled")
    }
}
