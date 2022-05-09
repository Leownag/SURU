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

}

extension UIStoryboard {
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    

    private static func stStoryboard(name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
