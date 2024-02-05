//
//  ProfileTabelViewHeader.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 24/01/2024.
//

import UIKit


protocol ProfileFollowDelegateTap{
    func followersTap()
    func followingsTap()
}

class ProfileTabelViewHeader: UIView {
    
    private enum SectionTabs : String {
        case posts = "Posts"
        case replies = "Replies"
        case highlights = "Highlights"
        case media  = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self{
            case .posts:
                return 0
            case .replies:
                return 1
            case .highlights:
                return 2
            case .media:
                return 3
            case .likes:
                return 4
            }
        }
    }
    
    private var selectedTab : Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {[weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadinAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in
                    
                }

            }
        }
    }
    
    private var leadinAnchors : [NSLayoutConstraint] = []
    private var trailingAnchors : [NSLayoutConstraint] = []
    var delegate: ProfileFollowDelegateTap!
    
    // MARK: - UI Components
    
    
    private var indecator : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var tabs : [UIButton] = ["Posts", "Replies", "Highlights", "Media", "Likes"]
        .map { buttomTitle in
            let buttom = UIButton(type: .system)
            buttom.setTitle(buttomTitle, for: .normal)
            buttom.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            buttom.tintColor = .label
            buttom.translatesAutoresizingMaskIntoConstraints = false
            return buttom
        }
    
    private lazy var sectionStack : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
        
    }()
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.8
        button.layer.borderColor = CGColor(gray: 0.28, alpha: 1)
        return button
    }()
        
    private let followerTextButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Follower", for: .normal)
        buttom.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        buttom.setTitleColor(.secondaryLabel, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()
    
    var followerCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingTextButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Following", for: .normal)
        buttom.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        buttom.setTitleColor(.secondaryLabel, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()
    
    var followingCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var joinDataLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let joinDataImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var userBiolabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14 ,weight: .regular)
        label.textColor = .label
        return label
    }()
    
    var userNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    var displayNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let profileHeaderImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor =  UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return imageView
    }()
    
    var profileHeaderImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImageView)
        addSubview(profileHeaderImage)
        addSubview(displayNameLabel)
        addSubview(userNameLabel)
        addSubview(userBiolabel)
        addSubview(joinDataImageView)
        addSubview(joinDataLabel)
        addSubview(followingCountLabel)
        addSubview(followingTextButtom)
        addSubview(followerCountLabel)
        addSubview(followerTextButtom)
        addSubview(sectionStack)
        addSubview(indecator)
        addSubview(editButton)
        ConfigrationConstraint()
        configrationButton()
        
        self.followerTextButtom.addTarget(self, action: #selector(followersTap), for: .touchUpInside)
        self.followingTextButtom.addTarget(self, action: #selector(followingsTap), for: .touchUpInside)
        
    }
    
    private func configrationButton(){
        for(i , button) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button as? UIButton else { return  }
            if i == selectedTab {
                button.tintColor = .label
            }else {
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTap(_ sender : UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label{
        case SectionTabs.posts.rawValue:
            selectedTab = 0
        case SectionTabs.replies.rawValue:
            selectedTab = 1
        case SectionTabs.highlights.rawValue:
            selectedTab = 2
        case SectionTabs.media.rawValue:
            selectedTab = 3
        case SectionTabs.likes.rawValue:
            selectedTab = 4
        default:
            selectedTab = 0
        }
    }
    @objc func followersTap(){
        delegate.followersTap()
    }
    @objc func followingsTap(){
        delegate.followingsTap()
    }
    
    
    // MARK: - Constraints
    
    private func ConfigrationConstraint(){
        
        for i in 0..<tabs.count {
            let leadingAnchor = indecator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadinAnchors.append(leadingAnchor)
            let trailingAnchor = indecator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        let profileHeaderImageViewConstraint = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        let profileHeaderImageConstraint = [
            profileHeaderImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileHeaderImage.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor , constant: 10),
            profileHeaderImage.heightAnchor.constraint(equalToConstant: 80),
            profileHeaderImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        let displayNameLabelConstraint = [
            displayNameLabel.leadingAnchor.constraint(equalTo: profileHeaderImage.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileHeaderImage.bottomAnchor, constant: 20)
        ]
        let userNameLabelConstraint = [
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
        ]
        let userBioLabelConstraint = [
            userBiolabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userBiolabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            userBiolabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5)
        ]
        let joinedDataImageViewConstraint = [
            joinDataImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            joinDataImageView.topAnchor.constraint(equalTo: userBiolabel.bottomAnchor, constant: 5)
        ]
        let joinedDataLabelConstraint = [
            joinDataLabel.leadingAnchor.constraint(equalTo: joinDataImageView.trailingAnchor , constant: 2),
            joinDataLabel.bottomAnchor.constraint(equalTo: joinDataImageView.bottomAnchor)
        ]
        let followingCountLabelConstraint = [
            followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: joinDataLabel.bottomAnchor, constant: 10)
        ]
        let followingTextButtomConstraint = [
            followingTextButtom.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor , constant: 4),
            followingTextButtom.centerYAnchor.constraint(equalTo: followingCountLabel.centerYAnchor)
        ]
        let followerCountLabelConstraint = [
            followerCountLabel.leadingAnchor.constraint(equalTo: followingTextButtom.trailingAnchor , constant: 8),
            followerCountLabel.centerYAnchor.constraint(equalTo: followingTextButtom.centerYAnchor)
        ]
        let followerTextbuttomConstraint = [
            followerTextButtom.leadingAnchor.constraint(equalTo: followerCountLabel.trailingAnchor , constant: 4),
            followerTextButtom.centerYAnchor.constraint(equalTo: followingTextButtom.centerYAnchor)
        ]
        let sectionStackConstaint = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        let indcatorConstraint = [
            leadinAnchors[0],
            trailingAnchors[0],
            indecator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
            indecator.heightAnchor.constraint(equalToConstant: 4)
        ]
        let editButtomConstraint = [
            editButton.topAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(profileHeaderImageViewConstraint)
        NSLayoutConstraint.activate(profileHeaderImageConstraint)
        NSLayoutConstraint.activate(displayNameLabelConstraint)
        NSLayoutConstraint.activate(userNameLabelConstraint)
        NSLayoutConstraint.activate(userBioLabelConstraint)
        NSLayoutConstraint.activate(joinedDataImageViewConstraint)
        NSLayoutConstraint.activate(joinedDataLabelConstraint)
        NSLayoutConstraint.activate(followingCountLabelConstraint)
        NSLayoutConstraint.activate(followingTextButtomConstraint)
        NSLayoutConstraint.activate(followerCountLabelConstraint)
        NSLayoutConstraint.activate(followerTextbuttomConstraint)
        NSLayoutConstraint.activate(sectionStackConstaint)
        NSLayoutConstraint.activate(indcatorConstraint)
        NSLayoutConstraint.activate(editButtomConstraint)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
