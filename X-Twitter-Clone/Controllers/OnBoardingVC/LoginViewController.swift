//
//  LoginViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 26/01/2024.
//

import UIKit
import Combine
class LoginViewController: UIViewController {
    
    private var viewModel = AuthenticationViewModel()
    private var subscription : Set<AnyCancellable> = []
    
    
    private func configrationBar(){
        let size : CGFloat = 28
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageView.image = UIImage(named: "twitterLogo")
        imageView.contentMode = .scaleAspectFit
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(imageView)
        navigationItem.titleView = middleView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
    }
    
    
    private let loginButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.setTitle("Log in", for: .normal)
        buttom.backgroundColor = .lightGray
        //        UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        buttom.tintColor = .label
        buttom.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        buttom.layer.cornerRadius = 25
        buttom.clipsToBounds = true
        buttom.layer.masksToBounds = true
        buttom.isEnabled = false
        return buttom
    }()
    
    private let emailTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        //        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)])
        //        textField.borderStyle = .none
        return textField
    }()
    
    private let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        //        textField.placeholder = "Password"
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray , NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)])
        //        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Log in to X"
        label.tintColor = .white
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButtom)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismissForKeyboard)))
        loginButtom.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configrationConstraint()
        configrationBar()
        bindView()
    }
    private func bindView(){
        emailTextField.addTarget(self, action: #selector(didTapChangeEmailText), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTapChangePasswordText), for: .editingChanged)
        
        viewModel.$isRegistrationFormValid.sink { [weak self] validateStore in
            self?.loginButtom.isEnabled = validateStore
        }
        .store(in: &subscription)
        
        viewModel.$users.sink { [weak self] user in
            guard user != nil else{return}
            guard let vc = self?.navigationController?.viewControllers.first as? OnBoardingViewController else{return}
            vc.dismiss(animated: true)
        }
        .store(in: &subscription)
        viewModel.$error.sink { [weak self] stringError in
            guard let error = stringError else{return}
            UIAlertController.PresentAlert(msg: error, form: self!)
            
        }
        .store(in: &subscription)
    }
    
    @objc private func didTapLogin(){
        viewModel.signIn()
    }
    
    @objc private func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapChangeEmailText(){
        viewModel.email = emailTextField.text
        viewModel.validateRegisterForm()
    }
    @objc private func didTapChangePasswordText(){
        viewModel.password = passwordTextField.text
        viewModel.validateRegisterForm()
    }
    
    @objc private func didTapDismissForKeyboard(){
        view.endEditing(true)
    }
    
    private func configrationConstraint(){
        let loginTitleLabelConstraint = [
            loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        ]
        let emailTextFieldConstraint =  [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 20),
            emailTextField.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let passwordTextFieldConstraint =  [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let loginButtomConstraint = [
            loginButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            loginButtom.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButtom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            loginButtom.widthAnchor.constraint(equalToConstant: 120),
            loginButtom.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        NSLayoutConstraint.activate(loginTitleLabelConstraint)
        NSLayoutConstraint.activate(emailTextFieldConstraint)
        NSLayoutConstraint.activate(passwordTextFieldConstraint)
        NSLayoutConstraint.activate(loginButtomConstraint)
    }
    

    

}
