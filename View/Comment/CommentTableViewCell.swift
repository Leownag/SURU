//
//  CommentTableViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/25.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var noodleValueView: UIView!
    @IBOutlet weak var soupValueView: UIView!
    @IBOutlet weak var happyValueView: UIView!
    
    func layoutCommentCell(data: Comment, name: String) {
        mainImage.kf.setImage(with: URL(string: data.mainImage))
        storeNameLabel.text = name
        mealNameLabel.text = data.meal
        createTimeLabel.text = String(data.createdTime).toYYYYMMDDHHMM()
        
        initValueView(on: noodleValueView, value: data.contentValue.noodle, color: UIColor.systemYellow.cgColor)
        initValueView(on: soupValueView, value: data.contentValue.soup, color: UIColor.systemBlue.cgColor)
        initValueView(on: happyValueView, value: data.contentValue.happiness, color: UIColor.systemPink.cgColor)
    }
    func layoutDraftCell(data: CommentDraft, name: String) {
        guard let imageData = data.image else { return }
        mainImage.image = UIImage(data: imageData)
        storeNameLabel.text = name
        createTimeLabel.text = String(data.createTime).toYYYYMMDDHHMM()
        initValueView(on: noodleValueView, value: data.noodleValue, color: UIColor.systemYellow.cgColor)
        initValueView(on: soupValueView, value: data.soupValue, color: UIColor.systemBlue.cgColor)
        initValueView(on: happyValueView, value: data.happyValue, color: UIColor.systemPink.cgColor)
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
