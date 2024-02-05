//
//  SearchViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 24/01/2024.
//

import UIKit
import Combine
import FirebaseAuth

class SearchViewController: UIViewController {

    private var originalArray: [TwitterUser] = []
    private var filteredArray: [TwitterUser] = []
    var selectedUser: TwitterUser?
    var myId: String?
    var header = ProfileTabelViewHeader()

    private var viewModel = SearchViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    private let searchTableView: UITableView = {
           let tableView = UITableView()
            tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifire)
            return tableView
        }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        bindView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        myId = Auth.auth().currentUser?.uid
        viewModel.retreiveAllUser()
    }
    @objc private func editDidTap() {
        let vc = UINavigationController(rootViewController: EditProfileViewController(user: selectedUser ?? TwitterUser(from: Auth.auth().currentUser!)))
        self.present(vc, animated: true)
    }
    @objc func followUser(){
        UIView.animate(withDuration: 0.3) {
            self.header.editButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.header.editButton.transform = CGAffineTransform.identity
            }
        }
        guard let myId = self.myId else { return }
        guard let selectedUser = selectedUser else { return }
        guard !(selectedUser.followers.contains(myId)) else { return }
        let myData: [TwitterUser] = originalArray.filter{ $0.id == myId}
        
        viewModel.updateUserData(selectedUser: selectedUser, myData: myData[0])
        
        self.header.editButton.setTitle("Following", for: .normal)
        self.header.editButton.backgroundColor = .systemBackground
        self.header.editButton.tintColor = .label
        viewModel.retreiveAllUser()
        
        
    }
    private func bindView(){
        viewModel.$users.sink { [weak self] users in
            self?.originalArray = users ?? []
            self?.filteredArray = []
            self?.searchTableView.reloadData()
        }.store(in: &subscriptions)
        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.PresentAlert(msg: error, form: self!)
        }.store(in: &subscriptions)
    }

}

// MARK: - + tableView and searchBar
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search----")
        searchTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = originalArray.filter { $0.displayName.lowercased().contains(searchText.lowercased()) }
        searchTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.identifire, for: indexPath) as? FollowTableViewCell else { return UITableViewCell() }
        let userModel = filteredArray[indexPath.row]
        cell.configureTweet(displayName: userModel.displayName, userName: userModel.userName, avatarPath: userModel.avatarPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedUser = filteredArray[indexPath.row]
        guard let myId = self.myId else { return }
        guard let selectedUser = selectedUser else {return}
        if (selectedUser.id == myId) {
            print("edit bottonnn")
            header.editButton.setTitle("Edit profile", for: .normal)
            header.editButton.backgroundColor = .systemBackground
            header.editButton.tintColor = .label
            header.editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        }else{
            header.editButton.addTarget(self, action: #selector(followUser), for: .touchUpInside)
            if selectedUser.followers.contains(myId) {
                header.editButton.setTitle("Following", for: .normal)
                header.editButton.backgroundColor = .systemBackground
                header.editButton.tintColor = .label
            }else{
                
                header.editButton.setTitle("Follow", for: .normal)
                header.editButton.backgroundColor = .label
                header.editButton.tintColor = .systemBackground
            }
        }
        
        let vc = ProfileViewController(user: selectedUser)
        vc.headerView = self.header
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}
