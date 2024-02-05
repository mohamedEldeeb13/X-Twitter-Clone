//
//  SearchViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import Foundation
import Combine
import FirebaseAuth

final class SearchViewModel: ObservableObject{
    @Published var users: [TwitterUser]?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveAllUser(){
        DataBaseManager.shared.getCollectionAllUser()
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }.store(in: &subscriptions)
    }
    func updateUserData(selectedUser: TwitterUser, myData: TwitterUser){
        var selectedUser = selectedUser
        var myData = myData
        
        guard !(myData.followings.contains(selectedUser.id)) else {return}
        
        let userFollowersNumber = (selectedUser.followersCount) + 1
        selectedUser.followers.append(myData.id)
        let myFollowingNumber = (myData.followingCount) + 1
        myData.followings.append(selectedUser.id)
        
        let updatedSelectedUserFields: [String: Any] = [
            "followersCount": userFollowersNumber,
            "followingCount": selectedUser.followingCount,
            "followers": selectedUser.followers,
            "followings": selectedUser.followings
        ]
        let updatedMyDataFields: [String: Any] = [
            "followersCount": myData.followersCount,
            "followingCount": myFollowingNumber,
            "followers": myData.followers,
            "followings": myData.followings
        ]
        DataBaseManager.shared.updateCollectionUser(updateFields: updatedSelectedUserFields, id: selectedUser.id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { _ in
            }).store(in: &subscriptions)
        DataBaseManager.shared.updateCollectionUser(updateFields: updatedMyDataFields, id: myData.id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { _ in
            }).store(in: &subscriptions)

    }
    
}
