//
//  tweetViewViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 31/01/2024.
//

import Foundation
import Combine
import FirebaseAuth


 class TweetViewViewModel : ObservableObject {
    
    var subscription : Set<AnyCancellable> = []
    var user : TwitterUser?
    @Published var error : String?
    var tweetContent : String = ""
    @Published var isValidToTweet : Bool = false
    @Published var isTweeted: Bool = false
    
    func validateTweet(){
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func addTweet(){
        guard let user = user else { return }
        let tweet = Tweet(author: user, authorId: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DataBaseManager.shared.setCollectionTweets(add: tweet)
            .sink {[weak self] completion in
                if case.failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.isTweeted = state
            }
            .store(in: &subscription)

    }

}
