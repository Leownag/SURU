//
//  Comment.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestore
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
    func    likeComment(currentUserID: String, tagertComment: Comment) {
        let commentID = tagertComment.commentID
        let authorID = tagertComment.userID
        
        let targetCommentDocment = database.collection("comments").document(commentID)
        let currentUserDocment = database.collection("accounts").document(currentUserID)
        let authorDocment = database.collection("accounts").document(authorID)
        targetCommentDocment.updateData([
            "likedUserList": FieldValue.arrayUnion([currentUserID])
        ])
        currentUserDocment.updateData([
            "likedComment": FieldValue.arrayUnion([commentID])
        ])
        authorDocment.updateData([
                    "myCommentLike": FieldValue.increment(Int64(1))
                ])
    }
    
    func unLikeComment(currentUserID: String, tagertComment: Comment) {
        let commentID = tagertComment.commentID
        let authorID = tagertComment.userID
        
        let targetCommentDocment = database.collection("comments").document(commentID)
        let currentUserDocment = database.collection("accounts").document(currentUserID)
        let authorDocment = database.collection("accounts").document(authorID)
        targetCommentDocment.updateData([
            "likedUserList": FieldValue.arrayRemove([currentUserID])
        ])
        currentUserDocment.updateData([
            "likedComment": FieldValue.arrayRemove([commentID])
        ])
        authorDocment.updateData([
                    "myCommentLike": FieldValue.increment(Int64(-1))
                ])
    }
}
