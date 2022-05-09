//
//  Account.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AccountRequestProvider {
    static let shared = AccountRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
    func fetchAccount(currentUserID: String, completion: @escaping (Result<Account?, Error>) -> Void) {
        database.collection("accounts").whereField("userID", isEqualTo: currentUserID as Any).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let snapshot = querySnapshot else { return }
                if snapshot.isEmpty {
                    completion(.success(nil))
                } else {
                    for document in snapshot.documents {
                        do {
                            let account = try document.data(as: Account.self, decoder: Firestore.Decoder())
                            completion(.success(account))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
        
    }
    //    func fetchAccount(userID: String, completion: @escaping (Result<Account, Error>) -> Void) {
    //        let doc = database.collection("accounts").document(userID)
    //        doc.getDocument { (document, error) in
    //            if let document = document {
    //                do {
    //                    if let data = try document.data(as: Account.self, decoder: Firestore.Decoder()) {
    //                        completion(.success(data))
    //                    }
    //                } catch {
    //                    completion(.failure(error))
    //                }
    //            }
    //        }
    //    }
    
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
    func followAccount(currentUserID: String, tagertUserID: String) {
        let targetDocment = database.collection("accounts").document(tagertUserID)
        let currentDocment = database.collection("accounts").document(currentUserID)
        
        targetDocment.updateData([
            "follower": FieldValue.arrayUnion([currentUserID])
        ])
        currentDocment.updateData([
            "followedUser": FieldValue.arrayUnion([tagertUserID])
        ])
    }
    
    func unfollowAccount(currentUserID: String, tagertUserID: String) {
        let targetDocment = database.collection("accounts").document(tagertUserID)
        let currentDocment = database.collection("accounts").document(currentUserID)
        
        targetDocment.updateData([
            "follower": FieldValue.arrayRemove([currentUserID])
        ])
        currentDocment.updateData([
            "followedUser": FieldValue.arrayRemove([tagertUserID])
        ])
    }
    func blockAccount(currentUserID: String, tagertUserID: String) {
        let currentDocment = database.collection("accounts").document(currentUserID)
        
        currentDocment.updateData([
            "blockUserList": FieldValue.arrayUnion([tagertUserID])
        ])
    }
    
    func unblockAccount(currentUserID: String, tagertUserID: String) {
        let currentDocment = database.collection("accounts").document(currentUserID)
        
        
        currentDocment.updateData([
            "blockUserList": FieldValue.arrayRemove([tagertUserID])
        ])
    }
    func addLoginHistroy(date: Date, currentUserID: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let weekDay = dateFormatter.string(from: date)
        let currentDocment = database.collection("accounts").document(currentUserID)
        currentDocment.updateData([
            "loginHistory": FieldValue.arrayUnion([weekDay])
        ])
    }
    func changeBadgeStatus(status: String, currentUserID: String) {
       
        let currentDocment = database.collection("accounts").document(currentUserID)
        currentDocment.updateData([
            "badgeStatus": status
        ])
    }
    func updateDataAccount(currentUserID: String, type: [String], content: [String]) {
        let currentDocment = database.collection("accounts").document(currentUserID)
        if type.count == content.count {
            
            for i in 0..<type.count {
                currentDocment.updateData([
                    type[i]: content[i]
                ])
            }
        }
    }
    func listenAccount(currentUserID: String, completion: @escaping () -> Void) {
            // [START listen_document]
        database.collection("accounts").document(currentUserID)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                      print("Error fetching document: \(error!)")
                      return
                    }
                    guard let data = document.data() else {
                      print("Document data was empty.")
                      return
                    }
                    completion()
                  }
            // [END listen_document]
        }
    
}
