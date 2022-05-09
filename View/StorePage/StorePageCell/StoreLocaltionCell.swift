//
//  StoreLocaltionCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StoreLocaltionCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var label: UILabel!
    
    func layoutCell(localtion: String? = "",seat: String? = "") {
        guard let localtion = localtion, let seat = seat else {
            return
        }
        if localtion != "" {
            label.text = localtion
            iconImageView.image = UIImage(named: "pin")
        } else {
            iconImageView.image = UIImage(named: "chair")
            if seat.count >= 5 {
                label.text = seat
            } else {
                label.text = "座位數共約\(seat)席"
            }
        }
    }
}
