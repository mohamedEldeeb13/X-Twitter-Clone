//
//  FollowViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import UIKit
import Combine

class FollowViewController: UIViewController {

    private let followTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifire)
        return tableView
    }()
    var followUsersId: [String] = []
    var usersArray: [TwitterUser] = []
    var viewModel = FollowViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        view.addSubview(followTableView)
        
        followTableView.delegate = self
        followTableView.dataSource = self
        
        viewModel.usersId = followUsersId
        viewModel.retreiveUsers()
        bindViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        followTableView.frame = view.frame
    }
    private func bindViews(){
        viewModel.$users.sink { [weak self] users in
            self?.usersArray = users
            self?.followTableView.reloadData()
        }.store(in: &subscriptions)
        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.PresentAlert(msg: error, form: self!)
        }.store(in: &subscriptions)
    }

}


// MARK: - + tableView
extension FollowViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.identifire, for: indexPath) as? FollowTableViewCell else {return UITableViewCell()}
        let userModel = usersArray[indexPath.row]
        cell.configureTweet(displayName: userModel.displayName, userName: userModel.userName, avatarPath: userModel.avatarPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
      
}
