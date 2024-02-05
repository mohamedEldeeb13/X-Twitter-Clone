//
//  EditProfileViewViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import Foundation
import Combine
import Firebase
import FirebaseStorage



 class EditProfileViewViewModel : ObservableObject {
    
    @Published var avatarPath: String?
    @Published var coverPath: String?
    @Published var displayName: String?
    @Published var userName: String?
    @Published var bio: String?
    @Published var location: String?
    @Published var website: String?
    @Published var birthDate: String?
    @Published var avatarImageData: UIImage?
    @Published var coverImageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String?
    @Published var isOnboarding: Bool = false
    
    var user: TwitterUser?
    
    private var subscription : Set<AnyCancellable> = []
    
    func validateUserProfileForm(){
        
        guard let displayName = displayName ,
              displayName.count > 2 ,
              let userName = userName ,
              userName.count > 2 ,
              avatarImageData != nil else {
            isFormValid = false
            return
        }
        isFormValid =  true
        
    }
    
    func uploadAvaterImage(){
        let randomID = UUID().uuidString
        guard let image = avatarImageData?.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageManager.shared.uploadProfileImage(with: randomID, image: image, metaData: metaData)
            .flatMap({ metaData in
                storageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.updateUserdata()
                    self?.updateTweetData()
                    self?.updateCommentData()
                case .failure(let error):
                    print(error)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] url in
                self?.avatarPath = url.absoluteString
            }
            .store(in: &subscription)
    }
    
    private func updateUserdata(){
        guard let displayName = displayName , let userName = userName , let avatarPath = avatarPath , let id = user?.id else { return }
        let updateFeilds : [String : Any] = [
            "displayName" : displayName,
            "userName" : userName,
            "bio" : bio ?? "",
            "avatarPath" : avatarPath,
            "isUserOnboarded" : true
        ]
        
        DataBaseManager.shared.updateCollectionUser(updateFields: updateFeilds, id: id)
            .sink { [weak self] completion in
                if case.failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] onboardingState in
                self?.isOnboarding = onboardingState
            }
            .store(in: &subscription)
    }
    
    private func updateTweetData(){
        guard let name = displayName,
              let username = userName,
              let avatarPath = avatarPath,
              let user = user
        else { return }
        let updatedFields: [String: Any] = [
            "author": [
                "avatarPath": avatarPath,
                "bio": bio ?? "",
                "createdDate": user.createdDate,
                "displayName": name,
                "followersCount": user.followersCount,
                "followingCount": user.followingCount,
                "followings": user.followings,
                "followers": user.followers,
                "id": user.id,
                "isUserOnboarded": user.isUserOnboarded,
                "userName" : username
            ] as [String : Any]
        ]
        DataBaseManager.shared.updateCollectionSpecificTweets(updateFields: updatedFields, id: user.id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: {_ in}).store(in: &subscription)
        
    }
    
    private func updateCommentData() {
        guard let name = displayName,
              let username = userName,
              let avatarPath = avatarPath,
              let user = user
        else { return }
        let updatedFields: [String: Any] = [
            "author": [
                "avatarPath": avatarPath,
                "bio": bio ?? "",
                "createdDate": user.createdDate,
                "displayName": name,
                "followersCount": user.followersCount,
                "followingCount": user.followingCount,
                "followings": user.followings,
                "followers": user.followers,
                "id": user.id,
                "isUserOnboarded": user.isUserOnboarded,
                "userName" : username
            ] as [String : Any]
        ]
        DataBaseManager.shared.updateCollectionComments(updateFields: updatedFields, id: user.id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: {_ in}).store(in: &subscription)

    }
    
    
}
