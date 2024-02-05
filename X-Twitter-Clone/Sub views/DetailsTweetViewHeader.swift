//
//  DetailsTweetViewHeader.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import UIKit
import FirebaseAuth

class DetailsTweetViewHeader: UIView {

    
    private let actionSpacing: CGFloat = 55
    
    // MARK: - UI Components
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textContentlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    var replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let repostNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    private let repostLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Reposts", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let quotesNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    private let quotesLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Quotes", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let likesNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    var likesLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Likes", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let bookmarksNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    private let bookmarksLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Bookmarks", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    private let indicator2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    private let indicator3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(userNameLabel)
        self.addSubview(textContentlabel)
        self.addSubview(replyButton)
        self.addSubview(retweetButton)
        self.addSubview(likeButton)
        self.addSubview(bookmarkButton)
        self.addSubview(shareButton)
        self.addSubview(repostNumberLabel)
        self.addSubview(repostLabel)
        self.addSubview(quotesNumberLabel)
        self.addSubview(quotesLabel)
        self.addSubview(likesNumberLabel)
        self.addSubview(likesLabel)
        self.addSubview(bookmarksNumberLabel)
        self.addSubview(bookmarksLabel)
        self.addSubview(indicator)
        self.addSubview(indicator2)
        self.addSubview(indicator3)
        
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func configureTweet(tweet: Tweet){
        guard let myId = Auth.auth().currentUser?.uid else {return}
        nameLabel.text = tweet.author.displayName
        userNameLabel.text = "@\(tweet.author.userName)"
        textContentlabel.text = tweet.tweetContent
        avatarImageView.sd_setImage(with: URL(string: tweet.author.avatarPath), placeholderImage: UIImage(systemName: "person.circle.fill"))
        likesNumberLabel.text = "\(tweet.likesCount)"
        if tweet.likers.contains(myId){
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .red
        }else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .systemGray
        }
    }
    
    private func configureConstraints(){
        let avaterImageViewConstaints = [
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor)
        ]
        let userNameLabelConstraints = [
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ]
        let textContentLabelConstraints = [
            textContentlabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            textContentlabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            textContentlabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ]
        let repostNumberLabelConstraints = [
            repostNumberLabel.leadingAnchor.constraint(equalTo: textContentlabel.leadingAnchor),
            repostNumberLabel.bottomAnchor.constraint(equalTo: replyButton.topAnchor, constant: -11)
        ]
        let repostLabelConstraints = [
            repostLabel.leadingAnchor.constraint(equalTo: repostNumberLabel.trailingAnchor, constant: 2),
            repostLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        let quotesNumberLabelConstraints = [
            quotesNumberLabel.leadingAnchor.constraint(equalTo: repostLabel.trailingAnchor, constant: 10),
            quotesNumberLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        let quotesLabelConstraints = [
            quotesLabel.leadingAnchor.constraint(equalTo: quotesNumberLabel.trailingAnchor, constant: 2),
            quotesLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        let likesNumberLabelConstraints = [
            likesNumberLabel.leadingAnchor.constraint(equalTo: quotesLabel.trailingAnchor, constant: 10),
            likesNumberLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        let likesLabelConstraints = [
            likesLabel.leadingAnchor.constraint(equalTo: likesNumberLabel.trailingAnchor, constant: 2),
            likesLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        let bookmarksNumberLabelConstraints = [
            bookmarksNumberLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 10),
            bookmarksNumberLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        let bookmarksLabelConstraints = [
            bookmarksLabel.leadingAnchor.constraint(equalTo: bookmarksNumberLabel.trailingAnchor, constant: 2),
            bookmarksLabel.centerYAnchor.constraint(equalTo: repostNumberLabel.centerYAnchor)
        ]
        
        let replyButtonConstraints = [
            replyButton.leadingAnchor.constraint(equalTo: textContentlabel.leadingAnchor),
            replyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ]
        let retweetButtonConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        let bookmarkButtonConstraints = [
            bookmarkButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: actionSpacing),
            bookmarkButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        let indicatorConstraints = [
            indicator.bottomAnchor.constraint(equalTo: repostNumberLabel.topAnchor, constant: -5),
            indicator.heightAnchor.constraint(equalToConstant: 0.6),
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ]
        let indicatorConstraints2 = [
            indicator2.bottomAnchor.constraint(equalTo: replyButton.topAnchor, constant: -5),
            indicator2.heightAnchor.constraint(equalToConstant: 0.6),
            indicator2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            indicator2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ]
        let indicatorConstraints3 = [
            indicator3.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indicator3.heightAnchor.constraint(equalToConstant: 0.6),
            indicator3.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indicator3.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        
        NSLayoutConstraint.activate(avaterImageViewConstaints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(textContentLabelConstraints)
        NSLayoutConstraint.activate(replyButtonConstraints)
        NSLayoutConstraint.activate(retweetButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(bookmarkButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
        NSLayoutConstraint.activate(repostNumberLabelConstraints)
        NSLayoutConstraint.activate(repostLabelConstraints)
        NSLayoutConstraint.activate(quotesNumberLabelConstraints)
        NSLayoutConstraint.activate(quotesLabelConstraints)
        NSLayoutConstraint.activate(likesNumberLabelConstraints)
        NSLayoutConstraint.activate(likesLabelConstraints)
        NSLayoutConstraint.activate(bookmarksNumberLabelConstraints)
        NSLayoutConstraint.activate(bookmarksLabelConstraints)
        NSLayoutConstraint.activate(indicatorConstraints)
        NSLayoutConstraint.activate(indicatorConstraints2)
        NSLayoutConstraint.activate(indicatorConstraints3)
        
    }


}
