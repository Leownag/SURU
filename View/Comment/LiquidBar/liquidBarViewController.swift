//
//  liquidBarViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit
import Lottie

protocol LiquidViewDelegate: AnyObject {
    func didGetSelectionValue(view: LiquidBarViewController, type: SelectionType, value: Double)
}
protocol LiquidViewDrawValueDelegate: AnyObject {
    func didGetSelectionValue(view: LiquidBarViewController, type: SelectionType, value: Double)
}
protocol LiquidBarViewControllerTOValue: AnyObject {
    func didChangeValue(view: LiquidBarViewController, value: Double)
}

class LiquidBarViewController: UIViewController {
    let mask = CALayer()
    var selectionType: SelectionType?
    weak var valueDelegate: LiquidBarViewControllerTOValue?
    weak var delegate: LiquidViewDelegate?
    weak var drawDelegate: LiquidViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    func setLottieView(_ type: SelectionType) {
        selectionType = type
        view.clipsToBounds = true
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
                let selectionValue = Double((total - 720) / -48).ceiling(toDecimal: 1)
                self.valueDelegate?.didChangeValue(view: self, value: selectionValue)
                controledView?.center = CGPoint(x: positionX, y: 240)
            } else if total > 680 {
                let selectionValue = Double((total - 720) / -48).ceiling(toDecimal: 1)
                self.valueDelegate?.didChangeValue(view: self, value: selectionValue)
                controledView?.center = CGPoint(x: positionX, y: 600)
            } else {
                let selectionValue = Double((total - 720) / -48).ceiling(toDecimal: 1)
                self.valueDelegate?.didChangeValue(view: self, value: selectionValue)
                controledView?.center = CGPoint(x: positionX, y: total)
            }
            
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            guard let positionY = controledView?.center.y, let selectionType = selectionType else { return }
            let selectionValue = Double((positionY - 720) / -48).ceiling(toDecimal: 1)
            print("Get Value", selectionValue)
            
            delegate?.didGetSelectionValue(view: self, type: selectionType, value: selectionValue)
            drawDelegate?.didGetSelectionValue(view: self, type: selectionType, value: selectionValue)
            print("end")
        default:
            print("end")
        }
    }
}
// setGradientView
extension LiquidBarViewController {
    func settingLottieView() -> UIView {
        guard let selectionType = selectionType else { return UIView() }
        var liqid = ""
        switch selectionType {
        case .noodle :
            liqid = "orange"
        case .soup :
            liqid = "blue"
        case .happy :
            liqid = "orange"
        }
        let animationView = AnimationView(name: liqid)
        animationView.frame = CGRect(x: 0, y: 192, width: 80, height: 480)
        animationView.contentMode = .scaleAspectFill
        
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }
}
