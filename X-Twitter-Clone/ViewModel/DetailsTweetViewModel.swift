//
//  DetailsTweetViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import Foundation
import Combine
import FirebaseAuth

class DetailsTweetViewModel: TweetViewViewModel {
    
    var tweetID: String = ""
    @Published var comments: [Comment] = []
    
    override func addTweet(){
        guard let user = user else {return}
        let comment = Comment(tweetId: tweetID, authorId: user.id, author: user, commentContent: tweetContent)
        DataBaseManager.shared.setCollectionComment(add: comment)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.isTweeted = state
            }.store(in: &subscription)
    }
    func retriveComments(tweetId: String){
        DataBaseManager.shared.getCollectionComments(tweetId: tweetId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: {[weak self] comments in
                self?.comments = comments
            }.store(in: &subscription)

    }
}
