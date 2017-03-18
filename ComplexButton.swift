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
    
    @IBOutlet var nestedButtons: [UIButton] = [] {
        didSet {
            self.bringSubview(toFront: overlay)
        }
    }
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
        self.nestedButtons.forEach { $0.isHighlighted = isHighlighted }
    }}
    
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
}