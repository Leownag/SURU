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
    /// - Parameters:
    ///   - corners: 需要實現爲圓角的角，可傳入多個
    ///   - radii: 圓角半徑
    ///
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
    func cornerForAll(radii: CGFloat) {
        corner(byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radii: radii)
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
}