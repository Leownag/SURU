//
//  WelcomeViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit


class WelcomeViewController: UIViewController {
    let welcomeView: WelcomeView = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.stickSubView(welcomeView)
        welcomeView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func initSignView(state: SignPageState) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignInAndOutViewController") as? SignInAndOutViewController else { return }
        controller.pageState = state
        controller.layoutSignView()
        if #available(iOS 15.0, *) {
            if let sheet = controller.sheetPresentationController {
                       sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 20
                
            }
        }
            // Below iOS 15, change frame here
            self.present(controller, animated: true, completion: nil)
        
        
    }
}

extension WelcomeViewController: WelcomeViewDelegate {
    func didTapSignUp(_ view: WelcomeView) {
        
        initSignView(state: .sighUp)
        
    }
    
    func didTapLogIn(_ view: WelcomeView) {
        initSignView(state: .signIn)
    }
    func didTapVisetAsGuest(_ view: WelcomeView) {
        self.dismiss(animated: true, completion: nil)
    }
}
