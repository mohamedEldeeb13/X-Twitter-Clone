//
//  ProfileViewViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 30/01/2024.
//

import Foundation
import Combine
import FirebaseAuth



final class ProfileViewViewModel : ObservableObject {
    
    @Published var user : TwitterUser?
    @Published var error : String?
    @Published var tweets : [Tweet] = []
    private var subscription : Set<AnyCancellable> = []
    
    
    func retriveUser(id: String){
        DataBaseManager.shared.getCollectionUser(retrevie: id)
            .handleEvents(receiveOutput: {[weak self] user in
                self?.user = user
                self?.fetchtweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)
    }
    
    func fetchtweets(){
        guard let userId = user?.id else { return }
        DataBaseManager.shared.getCollectionTweets(retrevie: userId)
            .sink { [weak self] completion in
                if case.failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] retriveTweet in
                self?.tweets = retriveTweet
            }
            .store(in: &subscription)

    }
    
    func getFormattedDate() -> String{
        let date: Date = user?.createdDate ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: date)
    }
    
}
