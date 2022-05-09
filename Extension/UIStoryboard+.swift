//
//  UIStoryboard+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import Foundation
import UIKit


private struct StoryboardCategory {
    static let main = "Main"

    static let lobby = "Lobby"

    static let product = "Product"

    static let trolley = "Trolley"

    static let profile = "Profile"

    static let auth = "Auth"
    
    static let chat = "Chat"
}

extension UIStoryboard {
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }

    static var lobby: UIStoryboard { return stStoryboard(name: StoryboardCategory.lobby) }

    static var product: UIStoryboard { return stStoryboard(name: StoryboardCategory.product) }

    static var trolley: UIStoryboard { return stStoryboard(name: StoryboardCategory.trolley) }

    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }

    static var auth: UIStoryboard { return stStoryboard(name: StoryboardCategory.auth) }
    
    static var chat: UIStoryboard { return stStoryboard(name: StoryboardCategory.chat)
    }

    private static func stStoryboard(name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
