//
//  Account.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestoreSwift

class AccountRequestProvider {
    static let shared = AccountRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
    func fetchAccounts(completion: @escaping (Result<[Account], Error>) -> Void) {
        database.collection("accounts").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var accounts = [Account]()
                guard let snapshot = querySnapshot else { return }
                for document in snapshot.documents {
                    do {
                        if let account = try document.data(as: Account.self, decoder: Firestore.Decoder()) {
                            accounts.append(account)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(accounts))
            }
        }
    }
    func fetchAccount(userID: String, completion: @escaping (Result<Account, Error>) -> Void) {
        let doc = database.collection("accounts").document(userID)
        doc.getDocument { (document, error) in
            if let document = document {
                do {
                    if let data = try document.data(as: Account.self, decoder: Firestore.Decoder()) {
                        completion(.success(data))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func publishRegistedAccount(account: inout Account, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("accounts").document(account.userID)
        account.createdTime = Date().timeIntervalSince1970
        do {
            try docment.setData(from: account)
        } catch {
            completion(.failure(error))
        }
        completion(.success("註冊成功"))
    }
    
    func deleteAccountInfo(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let docRef = database.collection("accounts").document(userID)
        docRef.updateData([
            "mainImage": "",
            "name": "刪除的帳號"
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("刪除資料庫成功"))
            }
        }
    }
    
}
