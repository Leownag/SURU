//
//  LoginViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/26.
//

import Foundation
import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

enum SignPageState {
    case sighUp
    case signIn
}
class SignInAndOutViewController: UIViewController {
    fileprivate var currentNonce: String?
    var pageState: SignPageState?
    let signInAndOutView: SignInAndOutView = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.stickSubView(signInAndOutView)
        signInAndOutView.delegate = self
    }
    func layoutSignView() {
        guard let state = pageState else { return }
        switch state {
        case .sighUp:
            signInAndOutView.layoutSignUpPage()
        case .signIn:
            signInAndOutView.layoutSignInPage()
        }
    }
}

// login function
extension SignInAndOutViewController {
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
@available(iOS 13.0, *)
extension SignInAndOutViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
        UserRequestProvider.shared.appleLogin(credential: credential) { result in
            switch result {
            case .failure(let error):
                print("apple登入失敗", error)
                LKProgressHUD.showFailure(text: "登入失敗")
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
                print("apple登入成功", message)
            }
        }
    }
  }
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
extension SignInAndOutViewController: SignInAndOutViewDelegate {
    func didTapSendButton(_ view: UIView, email: String, password: String) {
        guard let state = pageState else { return }
        switch state {
        case .sighUp:
            signUP(email: email, password: password)
        case .signIn:
            signIn(email: email, password: password)
        }
    }
    
    func didTapAppleButton(_ view: UIView) {
        startSignInWithAppleFlow()
    }
    
    func didTapForgotPasswordButton(_ view: UIView) {
        print("ForgotPassword")
    }
    
    func signUP(email: String, password: String) {
        UserRequestProvider.shared.nativeSignUp(withEmail: email, withPassword: password) { result in
            switch result {
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            case .success(let message):
                self.showAddInfoAlert()
                LKProgressHUD.showSuccess(text: message)
                
            }
        }
    }
    
    func signIn(email: String, password: String) {
        
        UserRequestProvider.shared.nativeSignIn(withEmail: email, withPassword: password) { result in
            switch result {
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            case .success(let message):
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                LKProgressHUD.showSuccess(text: message)
                
            }
        }
    }
    
    func showAddInfoAlert() {
        let alert = UIAlertController(title: "提示", message: "現在就去編輯自己的個人資料嗎", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default) { _ in
           print("去個人頁面")
        }
        let cancelAction = UIAlertAction(title: "先去逛逛", style: .cancel) { _ in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func initInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignInAndOutViewController") as? SignInAndOutViewController else { return }
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
