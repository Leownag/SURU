//
//  Store.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestoreSwift

class StoreRequestProvider {
    static let shared = StoreRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
    func fetchStores(completion: @escaping (Result<[Store], Error>) -> Void) {
        database.collection("stores").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var stores = [Store]()
                guard let snapshot = querySnapshot else { return }
                for document in snapshot.documents {
                    do {
                        if let store = try document.data(as: Store.self, decoder: Firestore.Decoder()) {
                            stores.append(store)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(stores))
            }
        }
    }
    func adminPublishNewStore(store: inout Store, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("stores").document()
        store.storeID = docment.documentID
        do {
            try docment.setData(from: store)
        } catch {
            completion(.failure(error))
        }
        completion(.success(docment.documentID))
    }
}
