//
//  StorageManager.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 30/01/2024.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestorageError : Error {
    case invalidImageID
}

final class storageManager {
    static let shared = storageManager()
    
    let storage = Storage.storage()
    
    func uploadProfileImage(with randomID : String , image : Data , metaData: StorageMetadata) -> AnyPublisher<StorageMetadata , Error> {
        return storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image,metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
    func getDownloadURL(for id : String?)-> AnyPublisher<URL,Error> {
        guard let id = id else {
            return Fail(error: FirestorageError.invalidImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    
}
