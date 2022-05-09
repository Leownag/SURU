////
////  AuthorizationAppleIDButton.swift
////  SURU_Leo
////
////  Created by LEO W on 2022/4/27.
////
//import AuthenticationServices
//import UIKit
//
//class MyAuthorizationAppleIDButton: UIButton {
//    @IBInspectable
//    var cornerRadius: CGFloat = 6.0
//    @IBInspectable
//    var authButtonType: Int = ASAuthorizationAppleIDButton.ButtonType.default.rawValue
//
//    @IBInspectable
//    var authButtonStyle: Int = ASAuthorizationAppleIDButton.Style.black.rawValue
//    private var authorizationButton =  ASAuthorizationAppleIDButton()
//
//        override public init(frame: CGRect) {
//            super.init(frame: frame)
//        }
//
//        required public init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//        }
//    override public func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        // Create ASAuthorizationAppleIDButton
//
//        authorizationButton.cornerRadius = 10
//        let type = ASAuthorizationAppleIDButton.ButtonType.init(rawValue: authButtonType) ?? .default
//        let style = ASAuthorizationAppleIDButton.Style.init(rawValue: authButtonStyle) ?? .black
//        authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: type,
//                                                           authorizationButtonStyle: style)
//        // Show authorizationButton
//        addSubview(authorizationButton)
//
//        // Use auto layout to make authorizationButton follow the MyAuthorizationAppleIDButton's dimension
//        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            authorizationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
//            authorizationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
//            authorizationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
//            authorizationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
//        ])
//
//}
//}
