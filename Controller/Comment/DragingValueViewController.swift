//
//  DragingValueViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit

enum SelectionType: String {
    case noodle = "麵條喜好度"
    case soup = "湯頭喜好度"
    case happy = "幸福感"
}
enum SelectionSubTitle: String {
    case text = "拖曳後記得按下儲存"
}

class DragingValueViewController: UIViewController {
    //    let backButton = UIButton()
    //    let uiview = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let liquilBarview = LiquidBarViewController()
    var selectionType: SelectionType = .noodle
    
    func setupLayout() {
        switch selectionType {
        case .noodle :
            titleLabel.text = selectionType.rawValue
        case .soup :
            titleLabel.text = selectionType.rawValue
        case .happy :
            titleLabel.text = selectionType.rawValue
        }
        let spacing = (UIScreen.height * 0.9 - 480) / 2
        titleLabel.font = UIFont.regular(size: 30)
        titleLabel.characterSpacing = 2.5
        titleLabel.textColor = UIColor.B1
        subTitleLabel.font = UIFont.regular(size: 18)
        subTitleLabel.characterSpacing = 2.5
        subTitleLabel.textColor = UIColor.B2
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: liquilBarview.view.leadingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: spacing).isActive = true
        //        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: liquilBarview.view.topAnchor, constant: -20).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        //        subTitleLabel.text = SelectionSubTitle.text.rawValue
        initDashBar(position: [96, 144, 192, 240, 288, 336, 384], value: [80, 70, 60, 50, 40, 30, 20])
    }
    func initDashBar(position: [CGFloat], value: [Int]) {
        for line in 0..<position.count {
            let positionOfDashBar = position[line]
            let valueOfDashBar = value[line]
            let dashBar = UIView()
            self.view.addSubview(dashBar)
            dashBar.translatesAutoresizingMaskIntoConstraints = false
            dashBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 135).isActive = true
            dashBar.centerYAnchor.constraint(equalTo: liquilBarview.view.topAnchor, constant: positionOfDashBar).isActive = true
            dashBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
            dashBar.backgroundColor = UIColor.B5
            if valueOfDashBar % 20 == 0 {
                dashBar.widthAnchor.constraint(equalToConstant: 70).isActive = true
                let valueLabel = UILabel()
                self.view.addSubview(valueLabel)
                valueLabel.textColor = UIColor.B6
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.leadingAnchor.constraint(equalTo: dashBar.trailingAnchor, constant: 5).isActive = true
                valueLabel.centerYAnchor.constraint(equalTo: dashBar.centerYAnchor, constant: 0).isActive = true
                valueLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                valueLabel.text = String(valueOfDashBar)
            } else {
                dashBar.widthAnchor.constraint(equalToConstant: 25).isActive = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackButton()
        setLiquidView()
        setupLayout()
    }
    
    func setLiquidView() {
        
        
        self.addChild(liquilBarview)
        self.view.addSubview(liquilBarview.view)
        liquilBarview.selectionType = selectionType
        liquilBarview.view.translatesAutoresizingMaskIntoConstraints = false
        liquilBarview.view.layer.cornerRadius = 40
        liquilBarview.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.height/10).isActive = true
        liquilBarview.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        liquilBarview.view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        liquilBarview.view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        liquilBarview.view.backgroundColor = UIColor.white
    }
    func setBackButton() {
        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.backgroundColor = UIColor.red
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
    
    @objc func dismissSelf() {
        self.view.removeFromSuperview()
    }
}
