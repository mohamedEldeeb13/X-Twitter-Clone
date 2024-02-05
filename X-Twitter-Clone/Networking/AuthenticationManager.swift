//
//  AuthenticationManager.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 26/01/2024.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine


class AuthManager {
    
    static let shared = AuthManager()
    
    func registerUser(email : String, password: String)-> AnyPublisher<User,Error> {
        Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func login(email : String, password : String)-> AnyPublisher<User,Error> {
        Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    
}
