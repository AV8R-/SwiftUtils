//
//  UIView+Extensions.swift
//  UltimateGuitar
//
//  Created by Bogdan Manshilin on 1/14/17.
//
//

import UIKit

//MARK: - Инициализация
extension UIView {
    enum UIViewLoadingError: Error {
        case notFound
    }
    
    /**
     Загружает и возвращает UIView из Xib
     */
    open class func instantiateFromXib<T: UIView>(_ named: String = String(describing: T.self), bundle: Bundle = Bundle(for: T.self)) throws -> T {
        guard let view = bundle.loadNibNamed(named, owner: nil, options: nil)?.first as? T else {
            throw UIViewLoadingError.notFound
        }
        return view
    }
    
    /**
     Загружает вьюху с кастомным сабклассом из ксибаT
     */
    open func addNib<T : UIView>() throws -> T {
        let view: T = try T.instantiateFromXib()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        try view.constrainSuperview()
        return view
    }
    
    /// Делает background прозразчным фон для всей иерархии view, начиная с этой.
    open func clearBackgrounds() {
        backgroundColor = UIColor.clear
        clearizeBackgrounds(subviews: subviews)
    }
    
    private func clearizeBackgrounds(subviews: [UIView]) {
        recursive(subviews: subviews) {
            $0.backgroundColor = UIColor.clear
        }
    }

    public func recursive(subviews: [UIView], map: (UIView)-> Void) {
        subviews.forEach {
            map($0)
            recursive(subviews: $0.subviews, map: map)
        }
    }
}

//MARK: – Создание constraints
extension UIView {
    /**
     Создает constraints к супервьюхе, чтобы растянуться на весь экран
    */
    open func addConstraintsToSuperviewBounds() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}

//MARK: - Анимации
public extension CATransition {
    public convenience init(fadeDuration:TimeInterval) {
        self.init()
        duration = fadeDuration
        timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        type = kCATransitionFade
    }
}

public extension UIView {
    public func runFade (_ duration: TimeInterval = 0.2) {
        layer.add(CATransition(fadeDuration: duration), forKey: nil)
    }
    public func runShakeAnimation(_ duration: TimeInterval) {
        runShakeAnimation(duration, repeatCount: 2, xCenterOffset: 6.0)
    }
    public func runShakeAnimation(_ duration: TimeInterval, repeatCount: Float, xCenterOffset: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - xCenterOffset, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + xCenterOffset, y: center.y))
        layer.add(animation, forKey: "shake")
    }
    public func startFadeInFadeOutAnimation(_ duration: TimeInterval = 0.75, repeatCount: Float = Float.infinity, fromValue: Float = 1, toValue: Float = 0, autoreverses: Bool = true) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = NSNumber(value: fromValue as Float)
        animation.toValue = NSNumber(value: toValue as Float)
        animation.duration = duration
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        layer.add(animation, forKey:"fadeInOut")
    }
    public func opacityPulseAnimation(_ duration: TimeInterval = 30) {
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = duration
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        self.layer.add(pulseAnimation, forKey: nil)
    }
    public func scalePulseAnimation(_ duration: TimeInterval = 30) {
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        self.layer.add(pulseAnimation, forKey: nil)
    }
    
    fileprivate enum ShakeConstants {
        static let animationRotateDeg = 0.5
        static let animationTranslateX: CGFloat = 0.0
        static let animationTranslateY: CGFloat = 0.0
        
    }
    
    public func startJiggling() {
        let degreesToRadians = { (x: Double) -> CGFloat in
            return CGFloat(Double.pi * x / 180)
        }
        
        let isEven = { (x: Int) -> Bool in
            return x % 2 == 0
        }
        
        //Shaking prepare
        let count = 1
        var rads = degreesToRadians( ShakeConstants.animationRotateDeg * ( isEven(count) ? -1 : 1) )
        let x = frame.size.width/8.0
        let y = frame.size.height/8.0
        let leftWobble = CGAffineTransform(a: cos(rads),b: sin(rads),c: -sin(rads),d: cos(rads),tx: x-x*cos(rads)+y*sin(rads),ty: y-x*sin(rads)-y*cos(rads))
        rads = degreesToRadians( ShakeConstants.animationRotateDeg * ( isEven(count) ? 1 : -1) )
        let rightWobble = CGAffineTransform(a: cos(rads),b: sin(rads),c: -sin(rads),d: cos(rads),tx: x-x*cos(rads)+y*sin(rads),ty: y-x*sin(rads)-y*cos(rads))
        let moveTransform = rightWobble.translatedBy(x: -ShakeConstants.animationTranslateX, y: -ShakeConstants.animationTranslateY)
        let conCatTransform = rightWobble.concatenating(moveTransform);
        
        transform = leftWobble
        
        let randomDelay = Double(arc4random_uniform(14)) / 100.0
        UIView.animate(withDuration: 0.15,
                       delay: randomDelay,
                       options: [.allowUserInteraction, .repeat, .autoreverse],
                       animations: { [weak self] in
                        self?.transform = conCatTransform
            }, completion: nil)
    }
    
    public func stopJiggling() {
        layer.removeAllAnimations()
        transform = CGAffineTransform.identity
    }
}

//MARK: - Containers
extension UIViewController {
    
    func setContentOfViewController(_ vc: UIViewController, toView view:UIView) {
        view.setContentOfViewController(vc)
        
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
    
}

extension UIView {
    func setContentOfViewController(_ vc:UIViewController) {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vc.view)
        
        _ = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[content]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["content" : vc.view]
        ).map { $0.isActive = true }
        
        _ = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[content]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["content" : vc.view]
        ).map { $0.isActive = true }
        
        layoutIfNeeded()
    }
}

