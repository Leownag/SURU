//
//  TagsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class TagsCell: UICollectionViewCell {

    @IBOutlet var tagLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20 / 2.0
//        self.backgroundColor = .C4
        self.tagLabel.textColor = .B6
    }

}
class Row {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    func tagLayout(collectionViewWidth: CGFloat) {
        let padding = 10
        var offset = padding
        for attribute in attributes {
            
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}

class TagFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var rows = [Row]()
        var currentRowY: CGFloat = -1
        self.scrollDirection = .horizontal
        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                rows.append(Row(spacing: 10))
            }
            rows.last?.add(attribute: attribute)
        }

        rows.forEach {
            $0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? 0)
        }
        return rows.flatMap { $0.attributes }
    }
}
