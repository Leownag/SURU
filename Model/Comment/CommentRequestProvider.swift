//
//  Comment.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestoreSwift

class CommentRequestProvider {
    static let shared = CommentRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
   
    func fetchComments(completion: @escaping (Result<[Comment], Error>) -> Void) {
        database.collection("comments").order(by: "createdTime", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var comments = [Comment]()
                guard let snapshot = querySnapshot else { return }
                for document in snapshot.documents {
                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            comments.append(comment)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(comments))
            }
        }
    }
    
    func fetchCommentsOfUser(useID: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        database.collection("comments").whereField("userID", isEqualTo: useID as Any).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var comments = [Comment]()
                guard let snapshot = querySnapshot else { return }
                for document in snapshot.documents {
                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            comments.append(comment)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(comments))
            }
        }
    }
    
    func publishComment(comment: inout Comment, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("comments").document()
        comment.commentID = docment.documentID
        comment.createdTime = Date().timeIntervalSince1970
        do {
            try docment.setData(from: comment)
        } catch {
            completion(.failure(error))
        }
        completion(.success(docment.documentID))
    }
}
