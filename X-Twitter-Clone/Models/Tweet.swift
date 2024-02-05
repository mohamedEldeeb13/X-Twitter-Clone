//
//  Tweet.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 31/01/2024.
//

import Foundation

struct Tweet : Codable {
    
    var id = UUID().uuidString
    let author: TwitterUser
    let authorId: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
