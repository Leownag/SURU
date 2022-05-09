//
//  CommentWallViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip


class CommentWallViewController: ButtonBarPagerTabStripViewController {
    var accounts: [Account] = []
    var comments: [Comment] = []
    var stores: [Store] = []
    var currentAccount: Account?
    
    @IBOutlet weak var scrollerView: UIScrollView!
    override func viewDidLoad() {

        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0
        
        super.viewDidLoad()
        self.navigationItem.title = "探索食記"
//        navigationController?.navigationBar.isHidden = true
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // 全部
        guard let discoveryVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as? DiscoveryViewController else { return [] }
        // 追隨的
        guard let followedVC = storyboard.instantiateViewController(identifier: "FollowViewController") as? FollowViewController else { return [] }
        // 收藏的
        guard let collectedVC = storyboard.instantiateViewController(identifier: "CollectViewController") as? CollectViewController else { return [] }
  
        return [discoveryVC, followedVC, collectedVC]
    }
}

