//
//  EditProfileTableViewCell.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    
    static let identifer = String(describing: TweetTableViewCell.self)
    
    
    // MARK: - UI Components
     var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "text"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        return label
    }()
    
     var textField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.font = .systemFont(ofSize: 14)
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .default
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    // MARK: - Methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        configurationConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configurationConstraint(){
        let titleLabelConstraint = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(equalToConstant: 70)
        ]
        
        let textFieldConstraint = [
            textField.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            textField.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(titleLabelConstraint)
        NSLayoutConstraint.activate(textFieldConstraint)
        
    }

}
