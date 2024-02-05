//
//  RegisterViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 25/01/2024.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
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
    
    private let licenseLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "By signing up. you agree to the Terms of Service and Privacy Policy. including Cookie use. X may use your contact information, including your email adress and phone number for purposes outlined in our Privacy Policy, like Keeping your account secure and personalizing our services, including ads. Learn more. Others will be able to find you by email or phone number, when provided, unless you choose otherwise here."
        label.textColor = .lightGray
        return label
    }()
    
    private let registerButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.setTitle("Sign up", for: .normal)
        buttom.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        buttom.tintColor = .white
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
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)])
        return textField
    }()
    
    private let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray , NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)])
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registerTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your account"
        label.tintColor = .white
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(registerTitleLabel)
        view.addSubview(licenseLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButtom)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismissForKeyboard)))
        configrationConstraint()
        registerButtom.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        configrationBar()
        bindView()
    }
    @objc private func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapDismissForKeyboard(){
        view.endEditing(true)
    }
    @objc private func createAccount() {
        viewModel.createAccount()
    }
    
    private func bindView(){
        emailTextField.addTarget(self, action: #selector(didTapChangeEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTapChangePassword), for: .editingChanged)
        viewModel.$isRegistrationFormValid.sink { [weak self] validateStore in
            self?.registerButtom.isEnabled = validateStore
        }
        .store(in: &subscription)
        
        viewModel.$users.sink { [weak self] user in
            guard user != nil else{return}
            guard let vc = self?.navigationController?.viewControllers.first as? OnBoardingViewController else{return}
            vc.dismiss(animated: true)
        }.store(in: &subscription)
        
        viewModel.$error.sink { [weak self] stringError in
            guard let error = stringError else{return}
            UIAlertController.PresentAlert(msg: error, form: self!)
            
        }
        .store(in: &subscription)
    }
    
    @objc private func didTapChangeEmail(){
        viewModel.email = emailTextField.text
        viewModel.validateRegisterForm()
    }
    @objc private func didTapChangePassword(){
        viewModel.password = passwordTextField.text
        viewModel.validateRegisterForm()
    }
    
    private func configrationConstraint(){
        let registerTitleLabelConstraint = [
            registerTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
//            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ]
        let emailTextFieldConstraint =  [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 20),
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
        let licenseLabelConstraint = [
            licenseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            licenseLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            licenseLabel.bottomAnchor.constraint(equalTo: registerButtom.topAnchor, constant: -15)
        ]
        let registerButtomConstraint = [
            registerButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerButtom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButtom.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(registerTitleLabelConstraint)
        NSLayoutConstraint.activate(emailTextFieldConstraint)
        NSLayoutConstraint.activate(passwordTextFieldConstraint)
        NSLayoutConstraint.activate(licenseLabelConstraint)
        NSLayoutConstraint.activate(registerButtomConstraint)
    }

}
