//
//  UIView+Extensions.swift
//  UltimateGuitar
//
//  Created by Bogdan Manshilin on 1/14/17.
//
//

import Foundation

//MARK: - Инициализация
extension UIView {
    /**
     Загружает и возвращает UIView из Xib
     */
    open class func instantiateFromXib<T: UIView>(_ named: String = String(describing: T.self), bundle: Bundle = Bundle(for: T.self)) -> T! {
        return bundle.loadNibNamed(named, owner: nil, options: nil)?.first as? T
    }
    
    /**
     Загружает вьюху с кастомным сабклассом из ксибаT
     */
    open func fromNib<T : UIView>() -> T? {
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            return nil
        }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsToSuperviewBounds()
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

    func recursive(subviews: [UIView], map: (UIView)-> Void) {
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
public extension UIView {
    fileprivate enum ShakeConstants {
        static let animationRotateDeg = 0.5
        static let animationTranslateX: CGFloat = 0.0
        static let animationTranslateY: CGFloat = 0.0
    }
    
    public func startJiggling() {
        let degreesToRadians = { (x: Double) -> CGFloat in
            return CGFloat(M_PI * x / 180)
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

