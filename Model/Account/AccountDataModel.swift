//
//  AccountDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct Account: Codable {
    var userID: String
    var name: String = "SURU遊民"
    var mainImage: String = "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2F%E4%B8%8B%E8%BC%89.jpeg?alt=media&token=d75677f1-686f-4683-a5ec-658f9a63c0fc"
    var provider: String
    var commentCount: Int = 0
    var createdTime: Double = 0
    var likedComment: [String] = []
    var collectedStore: [String] = []
    var follower: [String] = []
    var followedUser: [String] = []
    var sendReportCount: Int? = 0
    var myCommentLike: Int? = 0
    var blockUserList: [String]? = []
    var bio: String? = "nothing here."
    var websideLink: String?
    var loginHistory: [String]? = []
    var badgeStatus: String? = ""
}
//struct LikeComment: Codable {
//    var likeComment: String
//    var createdTime: Double
//}
//struct CollectComment: Codable {
//    var collectComment: String
//    var createdTime: Double
//}
