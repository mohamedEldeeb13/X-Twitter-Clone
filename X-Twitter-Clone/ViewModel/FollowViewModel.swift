//
//  FollowViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import Foundation
import Combine
import FirebaseAuth

final class FollowViewModel: ObservableObject{
    @Published var users: [TwitterUser] = []
    @Published var error: String?
    var usersId: [String] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUsers(){
        for id in usersId{
            DataBaseManager.shared.getCollectionUser(retrevie: id)
                .sink { [weak self] completion in
                    if case .failure(let error) = completion{
                        self?.error = error.localizedDescription
                    }
                } receiveValue: { [weak self] user in
                    self?.users.append(user)
                }.store(in: &subscriptions)
        }
    }
}
