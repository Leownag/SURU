//
//  UICollectionView+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import Foundation
import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .B4
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .medium(size: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}
