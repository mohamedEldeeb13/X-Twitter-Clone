//
//  Comment.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import Foundation

struct Comment: Codable{
    var id = UUID().uuidString
    let tweetId: String
    let authorId: String
    let author: TwitterUser
    let commentContent: String
}
