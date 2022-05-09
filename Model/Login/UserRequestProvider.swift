//
//  UserProvider.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/26.
//

import Foundation
import FirebaseAuth

class UserRequestProvider {
    
    static let shared = UserRequestProvider()
    // Native
    lazy var currentUserID = firebaseAuth.currentUser?.uid
    lazy var firebaseAuth = Auth.auth()
    
    func nativeSignIn(withEmail email: String, withPassword password: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("登入成功"))
            }
            
        }
    }
    
    func nativeSignUp(withEmail email: String, withPassword password: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let user = authResult?.user else { return }
            var account = self.mappingNativeUser(user: user)
            AccountRequestProvider.shared.publishRegistedAccount(account: &account) { result in
                switch result {
                case .success(let string):
                    completion(.success(string))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
    }
    func mappingNativeUser(user: User) -> Account {
        let account = Account(userID: user.uid, provider: user.providerID)
        return account
    }
    
    func logOut() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func nativeDeleteAccount(password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let user = firebaseAuth.currentUser
        
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: password)
        user?.reauthenticate(with: credential) { _, error in
          if let error = error {
              completion(.failure(error))
          } else {
              user?.delete(completion: { error in
                  if let error = error {
                      completion(.failure(error))
                  } else {
                      completion(.success("刪除帳號成功"))
                  }
              })
          }
        }
        
    }
    
    
    
}
