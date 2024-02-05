//
//  FollowTableViewCell.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    static let identifire = String(describing: FollowTableViewCell.self)

    // MARK: - UI Components
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userNameLabel)
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func configureTweet(displayName: String, userName: String, avatarPath: String){
        nameLabel.text = displayName
        userNameLabel.text = "@\(userName)"
        avatarImageView.sd_setImage(with: URL(string: avatarPath), placeholderImage: UIImage(systemName: "person.circle.fill"))
    }
    
    private func configureConstraints(){
        let avaterImageViewConstaints = [
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40)
        ]
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(avaterImageViewConstaints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
    }

}
