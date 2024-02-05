//
//  EditProfileViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import UIKit
import PhotosUI
import Combine


protocol EditProfileDelegte {
    func coverImageDidTap()
    func avatarImageDidTap()
}

enum EditProfileImagesTap{
    case coverImageTap
    case avatarImageTap
}


class EditProfileViewController: UIViewController {
    
    var imageTap: EditProfileImagesTap?
    var headerView : EditProfileHeader!
    private var viewModel = EditProfileViewViewModel()
    private var subscrition : Set<AnyCancellable>  = []
    var user : TwitterUser
    
    init(user: TwitterUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifer)
        tableView.allowsSelection = false
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private let leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Cancel"
        button.style = .done
        button.tintColor = .label
        return button
    }()
    private let rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Save"
        button.style = .done
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
    
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        configureConstraints()
        congigureNavigationBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        headerView = EditProfileHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 210))
        tableView.tableHeaderView = headerView
        headerView.delegete = self
        
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(tapToDismiss)))
        
        viewModel.user = self.user
        bindView()
    }
    override func viewDidAppear(_ animated: Bool) {
        configureUserData()
    }
    
    private func congigureNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationItem.title = "Edit profile"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        leftBarButton.target = self
        leftBarButton.action = #selector(cancelBtnTap)
        rightBarButton.target = self
        rightBarButton.action = #selector(saveBtnTap)
    }
    
    private func configureUserData(){
        self.setUserDataAsDefualtData(row: 0, updatedData: user.displayName)
        self.setUserDataAsDefualtData(row: 1, updatedData: user.userName)
        self.setUserDataAsDefualtData(row: 2, updatedData: user.bio)
        self.headerView.avaterProfileHeaderImageView.sd_setImage(with: URL(string: user.avatarPath))
        self.viewModel.avatarImageData = self.headerView.avaterProfileHeaderImageView.image
        self.viewModel.displayName = user.displayName
        self.viewModel.userName = user.userName
        self.viewModel.bio = user.bio
        self.viewModel.validateUserProfileForm()
    }
    
    private func setUserDataAsDefualtData(row: Int, updatedData: String){
        let indexPath = IndexPath(row: row, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell{
            cell.textField.text = updatedData
        }
    }

    
    private func bindView(){
        viewModel.$isFormValid.sink { [weak self] buttomState in
            if buttomState {
                self?.rightBarButton.isHidden = false
            }else{
                self?.rightBarButton.isHidden = true
            }
        }
        .store(in: &subscrition)
        
        viewModel.$isOnboarding.sink { [weak self] suceess in
            if suceess {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscrition)
        
        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.PresentAlert(msg: error, form: self!)
        }
        .store(in: &subscrition)
        
    }
    
    @objc private func cancelBtnTap(){
        self.dismiss(animated: true)
    }
    @objc private func saveBtnTap(){
        viewModel.uploadAvaterImage()
    }
    @objc private func tapToDismiss(){
        view.endEditing(true)
    }
    @objc private func didUpdateDisplayName(){
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.displayName = cell.textField.text
        }
        viewModel.validateUserProfileForm()
    }
    @objc private func didUpdateUsername(){
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.userName = cell.textField.text
        }
        viewModel.validateUserProfileForm()
    }
    @objc private func didUpdateBio(){
        let indexPath = IndexPath(row: 2, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.bio = cell.textField.text
        }
        viewModel.validateUserProfileForm()
    }
    @objc private func didUpdateLocation(){
        let indexPath = IndexPath(row: 3, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.location = cell.textField.text
        }
    }
    @objc private func didUpdateBirthDate(){
        let indexPath = IndexPath(row: 5, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.birthDate = cell.textField.text
        }
    }
    @objc private func didUpdateWebsite(){
        let indexPath = IndexPath(row: 4, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.website = cell.textField.text
        }
    }

    
    
    private func configureConstraints(){
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }

}


extension EditProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifer, for: indexPath) as? EditProfileTableViewCell else {return UITableViewCell()}
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Name"
            cell.textField.placeholder = "Add your name"
            cell.textField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        case 1:
            cell.titleLabel.text = "Username"
            cell.textField.placeholder = "Add your username"
            cell.textField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        case 2:
            cell.titleLabel.text = "Bio"
            cell.textField.placeholder = "Add a Bio to your profile"
            cell.textField.addTarget(self, action: #selector(didUpdateBio), for: .editingChanged)
        case 3:
            cell.titleLabel.text = "Location"
            cell.textField.placeholder = "Add your location"
            cell.accessoryType = .disclosureIndicator
            cell.textField.addTarget(self, action: #selector(didUpdateLocation), for: .editingChanged)
        case 4:
            cell.titleLabel.text = "Website"
            cell.textField.placeholder = "Add your website"
            cell.accessoryType = .disclosureIndicator
            cell.textField.addTarget(self, action: #selector(didUpdateWebsite), for: .editingChanged)
        case 5:
            cell.titleLabel.text = "Birth date"
            cell.textField.placeholder = "Add your birth date"
            cell.textField.addTarget(self, action: #selector(didUpdateBirthDate), for: .editingChanged)
        case 6:
            cell.textLabel?.text = "Switch to Professional"
            cell.titleLabel.isHidden = true
            cell.textField.isHidden = true
            cell.accessoryType = .disclosureIndicator
        case 7:
            cell.titleLabel.isHidden = true
            cell.textField.isHidden = true
        case 8:
            cell.titleLabel.text = "Tips"
            cell.textField.isHidden = true
            cell.accessoryType = .disclosureIndicator
            
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 2:
            return 80
        case 6:
            return 30
        default:
            return 40
        }
    }
}


extension EditProfileViewController : EditProfileDelegte , PHPickerViewControllerDelegate {
    func coverImageDidTap() {
        var configration = PHPickerConfiguration()
        configration.filter = .images
        configration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configration)
        imageTap = .coverImageTap
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func avatarImageDidTap() {
        var configration = PHPickerConfiguration()
        configration.filter = .images
        configration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configration)
        imageTap = .avatarImageTap
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        
                        switch self?.imageTap {
                            
                        case .coverImageTap:
                            self?.headerView.coverHeaderImageView.image = image
                            self?.viewModel.coverImageData = image
                        case .avatarImageTap:
                            self?.headerView.avaterProfileHeaderImageView.image = image
                            self?.viewModel.avatarImageData = image
                            self?.viewModel.validateUserProfileForm()
                        case .none : break
                        }
                    }
                }
            }
        }
    }
}
