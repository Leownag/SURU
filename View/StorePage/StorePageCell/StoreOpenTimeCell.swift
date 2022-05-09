//
//  StoreOpenTimeCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StoreOpenTimeCell: UITableViewCell {

    @IBOutlet weak var openInfoLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var openTimeStackView: UIStackView!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var dinnerTimeLabel: UILabel!
    let weekday = Date().weekDay()
    
    func layoutCell(openTime: Opentime?) {
        guard let openTime = openTime else {
            return
        }
        menuButton.imageView?.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 22).isActive = true
        menuButton.setTitle("", for: .normal)
        if openTime.byPropertyName(weekDay: weekday).dinner == "close" && openTime.byPropertyName(weekDay: weekday).lunch == "close" {
            openInfoLabel.text = "本日公休"
            openInfoLabel.textColor = .red
            openTimeStackView.isHidden = true
        } else {
            configTime(opentime: openTime)
        }
        configButton(opentime: openTime)
    }
    
    private func configButton(opentime: Opentime) {
        if #available(iOS 14.0, *) {
            menuButton.showsMenuAsPrimaryAction = true
            menuButton.menu = UIMenu(children: [
                        UIAction(title: "週日:  午:\(opentime.sun.lunch) 晚:\(opentime.sun.dinner)", handler: { action in
                            print("Select Messages")
                        }),
                        UIAction(title: "週一:  午:\(opentime.mon.lunch) 晚:\(opentime.mon.dinner)", handler: { action in
                            print("Select Messages")
                        }),
                        UIAction(title: "週二:  午:\(opentime.tue.lunch) 晚:\(opentime.tue.dinner)", handler: { action in
                            print("Select Messages")
                        }),
                        UIAction(title: "週三:  午:\(opentime.wed.lunch) 晚:\(opentime.wed.dinner)", handler: { action in
                            print("Select Messages")
                        }),
                        UIAction(title: "週四:  午:\(opentime.thu.lunch)  晚:\(opentime.thu.dinner)", handler: { action in
                            print("Select Messages")
                        }),
                        UIAction(title: "週五:  午:\(opentime.fri.lunch) 晚:\(opentime.fri.dinner)", handler: { action in
                            print("Select Messages")
                        }),
                        UIAction(title: "週六:  午:\(opentime.sat.lunch) 晚:\(opentime.sat.dinner)", handler: { action in
                            print("Select Messages")
                        })
                    ])
        } else {
            print("not Done yeah.")
        }
    }
    private func configTime(opentime: Opentime) {
       
        openInfoLabel.text = weekday.uppercased()
        switch weekday {
        case "sun" :
            self.lunchTimeLabel.text = "中午: \(opentime.sun.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.sun.dinner)"
        case "mon" :
            self.lunchTimeLabel.text = "中午: \(opentime.mon.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.mon.dinner)"
        case "tue" :
            self.lunchTimeLabel.text = "中午: \(opentime.tue.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.tue.dinner)"
        case "wed" :
            self.lunchTimeLabel.text = "中午: \(opentime.wed.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.wed.dinner)"
        case "thu" :
            self.lunchTimeLabel.text = "中午: \(opentime.thu.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.thu.dinner)"
        case "fri" :
            self.lunchTimeLabel.text = "中午: \(opentime.fri.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.fri.dinner)"
        case "sat" :
            self.lunchTimeLabel.text = "中午: \(opentime.sat.lunch)"
            self.dinnerTimeLabel.text = "晚餐: \(opentime.sat.dinner)"
        default:
            return
        }
    }
    
}
