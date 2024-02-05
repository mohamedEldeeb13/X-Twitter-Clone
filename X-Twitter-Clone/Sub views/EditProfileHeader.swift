//
//  EditProfileHeader.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import UIKit



class EditProfileHeader: UIView {
    
    var delegete : EditProfileDelegte!
    
    var coverHeaderImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "camera",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.backgroundColor = .darkGray
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var avaterProfileHeaderImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 30
        imageView.tintColor = .white
        imageView.backgroundColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(coverHeaderImageView)
        self.addSubview(avaterProfileHeaderImageView)
        coverHeaderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCoverImageView)))
        avaterProfileHeaderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvaterImageView)))
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    @objc private func didTapCoverImageView(){
        delegete?.coverImageDidTap()
        
    }
    @objc private func didTapAvaterImageView(){
        delegete?.avatarImageDidTap()
    }
    
    private func configureConstraints(){
        let coverHeaderImageViewConstraint = [
            coverHeaderImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverHeaderImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverHeaderImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverHeaderImageView.heightAnchor.constraint(equalToConstant: 140)
        ]
        
        let avaterProfileHeaderImageViewConstraint = [
            avaterProfileHeaderImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            avaterProfileHeaderImageView.centerYAnchor.constraint(equalTo: coverHeaderImageView.bottomAnchor, constant: 10),
            avaterProfileHeaderImageView.widthAnchor.constraint(equalToConstant: 60),
            avaterProfileHeaderImageView.heightAnchor.constraint(equalToConstant: 60)
            
        ]
        NSLayoutConstraint.activate(coverHeaderImageViewConstraint)
        NSLayoutConstraint.activate(avaterProfileHeaderImageViewConstraint)
    }
}
