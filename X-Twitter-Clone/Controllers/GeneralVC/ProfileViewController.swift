//
//  ProfileViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 24/01/2024.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden : Bool = true
    private var viewModel = ProfileViewViewModel()
    var user : TwitterUser
    var headerView = ProfileTabelViewHeader()
    private var subscription : Set<AnyCancellable> = []
    
    init( user: TwitterUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private var StatusBar : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    private let profileTabelView : UITableView = {
        let tabelview = UITableView()
        tabelview.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifer)
        tabelview.translatesAutoresizingMaskIntoConstraints = false
        return tabelview
        
        
    }()
    private let backButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        buttom.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        buttom.tintColor = .white
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.layer.masksToBounds = true
        buttom.layer.cornerRadius = 15
        return buttom
    }()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.title = "Profile"
        
        view.addSubview(profileTabelView)
        view.addSubview(StatusBar)
        view.addSubview(backButtom)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        profileTabelView.refreshControl = refreshControl
        
        headerView.frame = CGRect(x: 0, y: 0, width: profileTabelView.frame.width, height: 370)
        profileTabelView.tableHeaderView = headerView
        headerView.delegate = self
        profileTabelView.delegate = self
        profileTabelView.dataSource = self
        profileTabelView.contentInsetAdjustmentBehavior = .never
       
        backButtom.addTarget(self, action: #selector(didTapToDismiss), for: .touchUpInside)
        
        configrationConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.beginRefreshing()
        navigationController?.navigationBar.isHidden = true
        bindView()
        viewModel.user = self.user
        viewModel.fetchtweets()
    }
    override func viewDidLayoutSubviews() {
        profileTabelView.frame = view.frame
    }
    
    @objc func refreshData() {
        viewModel.retriveUser(id: user.id)
        bindView()
        profileTabelView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func bindView(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else {return}
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.userNameLabel.text = "@\(user.userName)"
            self?.headerView.followerCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBiolabel.text = user.bio
            self?.headerView.profileHeaderImage.sd_setImage(with: URL(string: user.avatarPath), placeholderImage: UIImage(systemName: "person.circle.fill"))
            self?.headerView.joinDataLabel.text = "Joined \(self?.viewModel.getFormattedDate() ?? "")"
            self?.refreshControl.endRefreshing()
        }
        .store(in: &subscription)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTabelView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        .store(in: &subscription)
        
        viewModel.$error.sink { [weak self] error in
            guard let error = error else{return}
            UIAlertController.PresentAlert(msg: error, form: self!)
        }
        .store(in: &subscription)
    }
    
    @objc private func didTapToDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func configrationConstraint(){
        let statusBarConstraint = [
            StatusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            StatusBar.topAnchor.constraint(equalTo: view.topAnchor),
            StatusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            StatusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        let backButtomConstaraint = [
            backButtom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButtom.widthAnchor.constraint(equalToConstant: 30),
            backButtom.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(statusBarConstraint)
        NSLayoutConstraint.activate(backButtomConstaraint)
    }
}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.tweets.count <= 6 {
            return viewModel.tweets.count
        }else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifer, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweet = viewModel.tweets[indexPath.row]
        cell.configrationTweet(displayName: tweet.author.displayName,
                               userName: tweet.author.userName,
                               tweetContent: tweet.tweetContent,
                               avatarPath: tweet.author.avatarPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
                self?.StatusBar.layer.opacity = 1
                
            } completion: { _ in }
            
        }else if yPosition < 0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
                self?.StatusBar.layer.opacity = 0
                
            } completion: { _ in }
        }
    }
}


extension ProfileViewController : ProfileFollowDelegateTap {
    func followersTap() {
        let vc = FollowViewController()
        vc.followUsersId = user.followers
        vc.title = "Follower"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func followingsTap() {
        let vc = FollowViewController()
        vc.followUsersId = user.followings
        vc.title = "Following"
        navigationController?.pushViewController(vc, animated: true)
    }
}
