//
//  TweetTableViewCell.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 24/01/2024.
//

import UIKit
import SDWebImage

protocol TweetTableViewCellDelegte : AnyObject {
    func TweetTableViewCellDidTapReplay()
    func TweetTableViewCellDidTapRetweet()
    func TweetTableViewCellDidTapLike(tag: Int)
    func TweetTableViewCellDidTapShare()
}

class TweetTableViewCell: UITableViewCell {
    
    static let identifer = String(describing: TweetTableViewCell.self)
    private let actionSpacing : CGFloat = 55
    weak var delegte : TweetTableViewCellDelegte?
    
    
    private let avaterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let displayNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18,weight: .bold)
        return label
    }()
    
    private let userNameLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let tweetTextContentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
        
    }()
    
    private let replayButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.setImage(UIImage(named: "replayIcon"), for: .normal)
        buttom.tintColor = .systemGray2
        return buttom
    }()
    
    private let retweetButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.setImage(UIImage(named: "retweetIcon"), for: .normal)
        buttom.tintColor = .systemGray2
        return buttom
    }()
    
    var likeButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.setImage(UIImage(named: "likeIcon"), for: .normal)
        buttom.tintColor = .systemGray2
        return buttom
    }()
    
    private let shareButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.setImage(UIImage(named: "shareIcon"), for: .normal)
        buttom.tintColor = .systemGray2
        return buttom
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avaterImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetTextContentLabel)
        contentView.addSubview(replayButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        ConfigurationButtom()
        ConfigrationConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapReplay(){
        UIView.animate(withDuration: 0.3) {
            self.replayButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.replayButton.transform = CGAffineTransform.identity
            }
        }
        delegte?.TweetTableViewCellDidTapReplay()
    }
    @objc func didTapRetweet(){
        UIView.animate(withDuration: 0.3) {
            self.retweetButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.retweetButton.transform = CGAffineTransform.identity
            }
        }
        delegte?.TweetTableViewCellDidTapRetweet()
    }
    @objc func didTapLike(_ sender: UIButton){
        UIView.animate(withDuration: 0.3) {
            self.likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeButton.tintColor = .red
            self.delegte?.TweetTableViewCellDidTapLike(tag: sender.tag)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.likeButton.transform = CGAffineTransform.identity
            }
        }
    }
    @objc func didTapShare(){
        UIView.animate(withDuration: 0.3) {
            self.shareButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.shareButton.transform = CGAffineTransform.identity
            }
        }
        delegte?.TweetTableViewCellDidTapShare()
    }
    
    private func ConfigurationButtom() {
        replayButton.addTarget(self, action: #selector(didTapReplay), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweet), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapLike(_:)), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    private func ConfigrationConstraint(){
        
        let avatarImageConstraint = [
            avaterImageView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor , constant: 20),
            avaterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avaterImageView.heightAnchor.constraint(equalToConstant: 50),
            avaterImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let displayNameLabelConstraint = [
            displayNameLabel.leadingAnchor.constraint(equalTo: avaterImageView.trailingAnchor, constant: 20),
            displayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
            
        ]
        let userNameLabelConstraint = [
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 20),
            userNameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ]
        
        let tweetTextContentLabelConstraint = [
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetTextContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 10),
            tweetTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
            
        ]
        
        let replayButtomConstraint = [
            replayButton.leadingAnchor.constraint(equalTo: tweetTextContentLabel.leadingAnchor),
            replayButton.topAnchor.constraint(equalTo: tweetTextContentLabel.bottomAnchor, constant: 10),
            replayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        let retweetButtomConstraint = [
            retweetButton.leadingAnchor.constraint(equalTo: replayButton.trailingAnchor,constant: actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replayButton.centerYAnchor)
        ]
        let likeButtomConstraint = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor,constant: actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: replayButton.centerYAnchor)
        ]
        let shareButtomConstraint = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor,constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replayButton.centerYAnchor)
        ]
        
        
        NSLayoutConstraint.activate(avatarImageConstraint)
        NSLayoutConstraint.activate(displayNameLabelConstraint)
        NSLayoutConstraint.activate(userNameLabelConstraint)
        NSLayoutConstraint.activate(tweetTextContentLabelConstraint)
        NSLayoutConstraint.activate(replayButtomConstraint)
        NSLayoutConstraint.activate(retweetButtomConstraint)
        NSLayoutConstraint.activate(likeButtomConstraint)
        NSLayoutConstraint.activate(shareButtomConstraint)
    }
    
    func configrationTweet(displayName: String, userName: String, tweetContent: String, avatarPath: String){
        displayNameLabel.text = displayName
        userNameLabel.text = "@\(userName)"
        tweetTextContentLabel.text = tweetContent
        avaterImageView.sd_setImage(with: URL(string: avatarPath), placeholderImage: UIImage(systemName: "person.circle.fill"))
    }
}
