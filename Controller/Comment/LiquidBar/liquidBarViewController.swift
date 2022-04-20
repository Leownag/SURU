//
//  liquidBarViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit
import Lottie

protocol SelectionValueManager: AnyObject {
    func getSelectionValue(type: SelectionType, value: Double)
}

class LiquidBarViewController: UIViewController {
    let mask = CALayer()
    var selectionType: SelectionType = .noodle
    weak var delegate: SelectionValueManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLottieView()
    }
    func setLottieView() {
        let animationView = settingLottieView()
        self.view.addSubview(animationView)
        setGesture(importView: animationView)
    }
    
    func setGesture(importView: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        importView.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let controledView = sender.view
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began, .changed:
            guard let positionY = controledView?.center.y, let positionX = controledView?.center.x else { return }
            let total = positionY + translation.y
            if total < 240 {
                controledView?.center = CGPoint(x: positionX, y: 240)
            } else if total > 680 {
                controledView?.center = CGPoint(x: positionX, y: 600)
            } else {
                controledView?.center = CGPoint(x: positionX, y: total)
            }
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            guard let positionY = controledView?.center.y else { return }
            let selectionValue = Double((positionY - 720) / -48).ceiling(toDecimal: 1)
            print("Get Value", selectionValue)
            delegate?.getSelectionValue(type: selectionType, value: selectionValue)
            print("end")
        default:
            print("end")
        }
    }
}
// setGradientView
extension LiquidBarViewController {
    func settingLottieView() -> UIView {
        var liqid: String
        switch selectionType {
        case .noodle :
            liqid = "orange"
        case .soup :
            liqid = "blue"
        case .happy :
            liqid = "orange"
        }
        let animationView = AnimationView(name: "orange")
        animationView.frame = CGRect(x: 0, y: 192, width: 80, height: 480)
        animationView.contentMode = .scaleAspectFill
        
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }
}
