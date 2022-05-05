//
//  JGProgressHUD+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/28.
//

import JGProgressHUD

enum HUDType {

    case success(String)

    case failure(String)
}

class LKProgressHUD {

    static let shared = LKProgressHUD()

    private init() { }

    let hud = JGProgressHUD(style: .dark)

    var view: UIView {
        let viewController = UIApplication.shared.windows.last!.rootViewController
        return (viewController?.view)!
    }

    static func show(type: HUDType) {

        switch type {

        case .success(let text):

            showSuccess(text: text)

        case .failure(let text):

            showFailure(text: text)
        }
    }

    static func showSuccess(text: String = "success") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showSuccess(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 2)
    }

    static func showFailure(text: String = "Failure") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 2)
    }

    static func show(text: String = "Loading") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                show()
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = text

        shared.hud.show(in: shared.view)
    }

    static func dismiss() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                dismiss()
            }

            return
        }

        shared.hud.dismiss()
    }
}
