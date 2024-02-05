//
//  TwitterUser.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import Foundation
import Firebase

struct TwitterUser : Codable {
    let id: String
    var displayName: String = ""
    var userName: String = ""
    var followersCount: Int = 0
    var followingCount: Int = 0
    var followers: [String] = []
    var followings: [String] = []
    var createdDate: Date = Date()
    var bio: String = ""
    var avatarPath: String = "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png"
    var isUserOnboarded: Bool = false
    
    init(from user: User){
        self.id = user.uid
    }
}
