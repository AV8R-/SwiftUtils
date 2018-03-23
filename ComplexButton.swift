//
//  ComplexButton.swift
//  UltimateGuitar
//
//  Created by Bogdan Manshilin on 3/18/17.
//
//

import UIKit

open class ComplexButton: UIControl {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initOverlayButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initOverlayButton()
    }
    
    public var onPress: (()->Void)? {
        didSet {
            if let _ = onPress {
                overlay.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
            } else {
                overlay.removeTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
            }
        }
    }
    
    public var shouldMakeTranclucentOnHiglhlight = true
    
    lazy var nestedButtons: [UIButton] = {
        var buttons = [UIButton]()
        let count = self.subviews.count - 1
        guard count > 0 else {
            return []
        }
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
    
    override open var isEnabled: Bool { didSet {
        self.nestedButtons.forEach { $0.isEnabled = isEnabled }
    }}

    override open var isSelected: Bool { didSet {
        self.nestedButtons.forEach { $0.isSelected = isSelected }
    }}

    override open var isHighlighted: Bool { didSet {
        guard shouldMakeTranclucentOnHiglhlight else {
            return
        }
        let count = subviews.count - 1 > 0 ? subviews.count - 1 : 0
        let alpha: CGFloat = isHighlighted ? 0.3 : 1
        for subview in subviews[0..<count] {
            subview.alpha = alpha
        }
    }}
    
    override open func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.bringSubview(toFront: overlay)
    }
    
    override open func addSubview(_ view: UIView) {
        if let overlay = overlay {
            insertSubview(view, belowSubview: overlay)
        } else {
            super.addSubview(view)
        }
    }
    
    override open var contentVerticalAlignment: UIControlContentVerticalAlignment { didSet {
        self.nestedButtons.forEach { $0.contentVerticalAlignment = contentVerticalAlignment }
    }}
    
    override open var contentHorizontalAlignment: UIControlContentHorizontalAlignment{ didSet {
        self.nestedButtons.forEach { $0.contentHorizontalAlignment = contentHorizontalAlignment }
    }}
    
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.nestedButtons.forEach { $0.beginTracking(touch, with: event) }
        return super.beginTracking(touch, with: event)
    }

    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.nestedButtons.forEach { $0.continueTracking(touch, with: event) }
        return super.continueTracking(touch, with: event)
    }

    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.nestedButtons.forEach { $0.endTracking(touch, with: event) }
        return super.endTracking(touch, with: event)
    }

    override open func cancelTracking(with event: UIEvent?) {
        self.nestedButtons.forEach { $0.cancelTracking(with: event) }
        super.cancelTracking(with: event)
    }
    
    override open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        overlay.addTarget(target, action: action, for: controlEvents)
    }
    
    override open func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        overlay.removeTarget(target, action: action, for: controlEvents)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
    
    @objc func touchUpInside(_ sender: Any) {
        onPress?()
    }
}
