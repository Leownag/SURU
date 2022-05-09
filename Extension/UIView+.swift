//
//  UIView+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import Foundation
import UIKit

extension UIView {
    /// 部分圓角
    ///   - corners: 需要實現爲圓角的角，可傳入多個
    ///   - radii: 圓角半徑
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    func makeShadow(shadowOpacity: Float? = 0.4, shadowRadius: CGFloat? = 15, color: CGColor? = UIColor.black.cgColor) {
        guard let shadowRadius = shadowRadius, let shadowOpacity = shadowOpacity else {
            return
        }
        self.layer.shadowColor = color
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = shadowRadius
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    func cornerForAll(radii: CGFloat) {
        corner(byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radii: radii)
    }
    // 註冊用
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func stickSubView(_ objectView: UIView) {
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func stickSubView(_ objectView: UIView, inset: UIEdgeInsets) {
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
    }
    
        enum GlowEffect: Float {
            case small = 15, normal = 20, mid = 25, big = 30
        }

        func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
            layer.masksToBounds = false
            layer.shadowColor = color.cgColor
            layer.shadowRadius = 0
            layer.shadowOpacity = 0.8
            layer.shadowOffset = .zero

            let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
            glowAnimation.fromValue = 0
            glowAnimation.toValue = effect.rawValue
            glowAnimation.fillMode = .removed
            glowAnimation.repeatCount = .infinity
            glowAnimation.duration = 2
            glowAnimation.autoreverses = true
            layer.removeAllAnimations()
            
            layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
        }
    
}
