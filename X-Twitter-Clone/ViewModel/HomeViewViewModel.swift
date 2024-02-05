//
//  HomeViewViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import Foundation
import Combine
import FirebaseAuth
class HomeViewViewModel : ObservableObject {
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var tweetId: String?
    @Published var likesCount: Int?
    @Published var likers: [String]?
    var likesTweetIds: [String] = []
    
    var isLoading: Bool = true{
        didSet{
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (()->())?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DataBaseManager.shared.getCollectionUser(retrevie: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { _ in}.store(in: &subscriptions)

    }
    
    func fetchTweets(){
        DataBaseManager.shared.getCollectionAllTweets()
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] receivedTweets in
                self?.tweets = receivedTweets
                self?.likesTweetIds = self?.getAllTweetsLikes(tweets: receivedTweets) ?? []
                self?.isLoading = false
            }.store(in: &subscriptions)

    }
    func updateTweet(){
        guard let userId = user?.id else { return }
        guard let tweetId = tweetId else { return }
        guard !(likers!.contains(userId)) else {return}
        likers?.append(userId)
        let updatedFields: [String: Any] = [
            "likesCount": (likesCount ?? 0) + 1,
            "likers": likers ?? []
        ]
        DataBaseManager.shared.updateCollectionTweet(updateFields: updatedFields, id: tweetId)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchTweets()
            }).store(in: &subscriptions)
    }
    func getSpecificTweet(){
        guard let id = tweetId else { return }
        DataBaseManager.shared.getCollectionSpecificTweet(tweetId: id)
            .handleEvents(receiveOutput: { [weak self] tweet in
                self?.likesCount = tweet.likesCount
                self?.likers = tweet.likers
                self?.updateTweet()
            })
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { _ in }).store(in: &subscriptions)
    }
    
    func getAllTweetsLikes(tweets: [Tweet]) -> [String]{
        guard let userId = user?.id else { return []}
        var likesTweets: [String] = []
        for tweet in tweets {
            if tweet.likers.contains(userId) {
                likesTweets.append(tweet.id)
            }
        }
        return likesTweets
    }
}


