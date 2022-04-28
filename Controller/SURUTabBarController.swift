//
//  SURUTabBarController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import FirebaseAuth


private struct StoryboardCategory {

    static let waterfalls = "WaterfaillsViewController"

    static let mapping = "MappingViewController"

    static let report = "ReportViewController"

    static let comment = "CommentViewController"

    static let profile = "ProfileViewController"

//    static let auth = "Auth"
}
private enum Tab {
    case waterfalls

    case mapping

    case report

    case comment
    
    case profile

    func controller() -> UIViewController {
        var controller: UIViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        switch self {
        case .waterfalls: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.waterfalls)

        case .mapping: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.mapping)

        case .report: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.report)

        case .comment: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.comment)
            
        case .profile: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.profile)
        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {
        switch self {
        case .waterfalls:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Home_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Home_Selected)
            )

        case .mapping:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Catalog_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Catalog_Selected)
            )

        case .comment:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Cart_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Cart_Selected)
            )

        case .report:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Profile_Selected)
            )
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Profile_Selected)
            )
        }
    }
}


class SURUTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private let tabs: [Tab] = [.waterfalls, .mapping, .report, .comment, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = tabs.map({ $0.controller() })
        delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser {
            print("Login success, id: \(user.uid), email: \(user.email)")
        }else {
            presentWelcomePage()
        }
    }

    func presentWelcomePage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.present(controller, animated: true, completion: nil)
    }
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        true
    }
}
