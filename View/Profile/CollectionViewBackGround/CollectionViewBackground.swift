//
//  CollectionViewBackground.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/7.
//

import Foundation
import UIKit

class UICollectionViewSectionColorReusableView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let att = layoutAttributes as? UICollectionViewSectionColorLayoutAttributes {
            backgroundColor = att.sectionBgColor
            layer.cornerRadius = 10
            self.makeShadow(shadowOpacity: 0.3, shadowRadius: 10)
        }
    }
}
class UICollectionViewSectionColorLayoutAttributes: UICollectionViewLayoutAttributes {
    var sectionBgColor: UIColor?
}
class UICollectionViewSectionColorFlowLayout: UICollectionViewFlowLayout {

    var decorationViewAttrs = [UICollectionViewSectionColorLayoutAttributes]()

    override init() {
        super.init()
        
        register(UICollectionViewSectionColorReusableView.self, forDecorationViewOfKind: "UICollectionViewSectionColorReusableView")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {

        super.prepare()
        
        //Section Number
        guard let collectionView = collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        guard let delegate = collectionView.delegate as? UICollectionViewSectionColorDelegateFlowLayout
        else {
            return
        }
        decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            guard numberOfItems > 0,
                  let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                  let lastItem = layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                      continue
                   }
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 20
            sectionFrame.origin.y -= sectionInset.top
            if scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right - 40
                sectionFrame.size.height = collectionView.frame.height
            } else {
                sectionFrame.size.width = collectionView.frame.width - 40
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }

            // 2、 Define view properties
            let attr = UICollectionViewSectionColorLayoutAttributes(forDecorationViewOfKind: "UICollectionViewSectionColorReusableView", with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.sectionBgColor = delegate.collectionView?(collectionView, layout: self, backgroundColor: section)
            decorationViewAttrs.append(attr)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var allAttributes = [UICollectionViewLayoutAttributes]()
        allAttributes.append(contentsOf: attributes)
        for att in decorationViewAttrs {
            if rect.intersects(att.frame) {
                allAttributes.append(att)
            }
        }
        return allAttributes
    }
}
@objc protocol UICollectionViewSectionColorDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColor section: Int) -> UIColor
}

