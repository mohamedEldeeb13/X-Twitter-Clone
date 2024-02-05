//
//  AuthenticationViewModel.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 26/01/2024.
//

import Foundation
import Firebase
import Combine


 class AuthenticationViewModel : ObservableObject {
    @Published var email : String?
    @Published var password : String?
    @Published var isRegistrationFormValid : Bool = false
    @Published var users : User?
    @Published var error : String?
    private var subscription : Set<AnyCancellable> = []
    
    func validateRegisterForm(){
        guard let email = email ,let password = password else {
            return  isRegistrationFormValid = false
        }
        isRegistrationFormValid = isValidEmail(email) && password.count >= 8
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createAccount() {
        guard let email = email , let password = password else { return }
        AuthManager.shared.registerUser(email: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.users = user
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscription)
        
    }
    
    func createRecord(for user : User){
        DataBaseManager.shared.setCollectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Add user record to database \(state)")
            }
            .store(in: &subscription)

        
    }
    
    func signIn(){
        guard let email = email , let password = password else {return}
        AuthManager.shared.login(email: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.users = user
            }
            .store(in: &subscription)
        
    }
    
    
}
