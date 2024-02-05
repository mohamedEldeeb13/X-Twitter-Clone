//
//  TweetViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 31/01/2024.
//

import UIKit
import Combine
class TweetViewController: UIViewController {
    
    private var viewModel : TweetViewViewModel
    private var subscription : Set<AnyCancellable> = []
    var user : TwitterUser
    init(user: TwitterUser, viewModel: TweetViewViewModel){
        self.user = user
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private lazy var leftBarButtomItem : UIBarButtonItem = {
        let buttom = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(didTapToDismiss))
        buttom.title = "Cancel"
        buttom.tintColor = .label
        return buttom
    }()
    
    private lazy var rightBarButtomItem : UIBarButtonItem = {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 36))
        customView.backgroundColor =  UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        customView.clipsToBounds = true
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 18
        
        let buttom = UIButton(frame: customView.bounds)
        buttom.setTitle("Post", for: .normal)
        buttom.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        buttom.addTarget(self, action: #selector(didTapToPostTweet), for: .touchUpInside)
        buttom.titleLabel?.textAlignment = .center
        buttom.titleLabel?.textColor = .white
        customView.addSubview(buttom)
        
        let customBarButtomItem = UIBarButtonItem(customView: customView)
        customBarButtomItem.isEnabled = false
        return customBarButtomItem
    }()
    
    private lazy var tweetTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .gray
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = "What's happening?"
        textView.font = .systemFont(ofSize: 16 ,weight: .semibold)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configrationBar()
        view.addSubview(tweetTextView)
        configrationConstraint()
        tweetTextView.delegate = self
        viewModel.user = user
        bindView()
    }
    
    private func bindView(){
        viewModel.$isValidToTweet.sink { [weak self] state in
            self?.rightBarButtomItem.isEnabled = state
        }
        .store(in: &subscription)
        
        viewModel.$isTweeted.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscription)
        
        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.PresentAlert(msg: error, form: self!)
        }.store(in: &subscription)
    }
    
    private func configrationBar(){
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = leftBarButtomItem
        navigationItem.rightBarButtonItem = rightBarButtomItem
    }
    
    @objc private func didTapToDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc private func didTapToPostTweet(){
        viewModel.addTweet()
        
    }
    
    private func configrationConstraint(){
        let tweetTextViewConstraint = [
            tweetTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tweetTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tweetTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(tweetTextViewConstraint)
    }
}

extension TweetViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray
            textView.text = "What's happening?"
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateTweet()
    }
}
