//
//  CommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {
    @IBOutlet weak var noodleValueView: UIView!
    @IBOutlet weak var soupValueView: UIView!
    @IBOutlet weak var happyValueView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var soupLabel: UILabel!
    @IBOutlet weak var noodleLabel: UILabel!
    @IBOutlet weak var oveallLabel: UILabel!
    
    
    func layoutCell(data: Comment, store: Store) {
        initValueView(on: noodleValueView, value: data.contentValue.noodle, color: UIColor.systemYellow.cgColor)
        initValueView(on: soupValueView, value: data.contentValue.soup, color: UIColor.systemBlue.cgColor)
        initValueView(on: happyValueView, value: data.contentValue.happiness, color: UIColor.systemPink.cgColor)
        contentLabel.text = data.contenText.replacingOccurrences(of: "\\n", with: "\n")
        mealLabel.text = data.meal
        storeNameLabel.text = store.name
        mainImageView.kf.setImage(with: URL(string: data.mainImage))
        soupLabel.text = "\(data.contentValue.noodle)"
     noodleLabel.text = "\(data.contentValue.soup)"
     oveallLabel.text = "\(data.contentValue.happiness)"
    }
    private func initValueView(on view: UIView, value: Double, color: CGColor) {
        // round view
            let roundView = UIView(
                frame: CGRect(
                    x: view.bounds.origin.x,
                    y: view.bounds.origin.y,
                    width: view.bounds.size.width - 4,
                    height: view.bounds.size.height - 4
                )
            )
            roundView.backgroundColor = .B5
            roundView.layer.cornerRadius = roundView.frame.size.width / 2
            
            // bezier path
            let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
                                          radius: roundView.frame.size.width / 2,
                                          startAngle: CGFloat(-0.5 * .pi),
                                          endAngle: CGFloat(1.5 * .pi),
                                          clockwise: true)
            // circle shape
            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            circleShape.strokeColor = color
            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.lineWidth = 4
            // set start and end values
            circleShape.strokeStart = 0.0
        circleShape.strokeEnd = value*0.1
            
            // add sublayer
            roundView.layer.addSublayer(circleShape)
            // add subview
            view.addSubview(roundView)
        view.backgroundColor = .clear
    }
}
