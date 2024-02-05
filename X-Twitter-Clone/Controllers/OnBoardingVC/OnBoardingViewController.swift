//
//  OnBoardingViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 25/01/2024.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    
    private let promotLabel : UILabel = {
        let label = UILabel()
        label.text = "Have an account Already?"
        label.tintColor = .gray
        label.font = .systemFont(ofSize: 14,weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var logInButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Log in", for: .normal)
        buttom.titleLabel?.font = .systemFont(ofSize: 14)
        buttom.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()

    private let WelcomeLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "See what's happening in the world right now"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        return label
    }()
    
    private let createAccountButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Create Account", for: .normal)
        buttom.tintColor = .white
        buttom.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        buttom.layer.cornerRadius = 30
        buttom.clipsToBounds = true
        buttom.layer.masksToBounds = true
        buttom.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(WelcomeLabel)
        view.addSubview(createAccountButtom)
        view.addSubview(promotLabel)
        view.addSubview(logInButtom)
        createAccountButtom.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        logInButtom.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configrationConstraint()
    }
    @objc private func didTapLogin(){
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCreateAccount(){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configrationConstraint() {
        let WelcomeLabelConstraint = [
            WelcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            WelcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            WelcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        let createAccountButtomConstraint = [
            createAccountButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButtom.topAnchor.constraint(equalTo: WelcomeLabel.bottomAnchor, constant: 20),
            createAccountButtom.widthAnchor.constraint(equalTo: WelcomeLabel.widthAnchor, constant: -20),
            createAccountButtom.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let promotLabelConstraint = [
            promotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            promotLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        let loginButtomConstraint = [
            logInButtom.centerYAnchor.constraint(equalTo: promotLabel.centerYAnchor),
            logInButtom.leadingAnchor.constraint(equalTo: promotLabel.trailingAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(WelcomeLabelConstraint)
        NSLayoutConstraint.activate(createAccountButtomConstraint)
        NSLayoutConstraint.activate(promotLabelConstraint)
        NSLayoutConstraint.activate(loginButtomConstraint)
    }
    

   

}
