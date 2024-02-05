//
//  HomeViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 24/01/2024.
//

import UIKit
import FirebaseAuth
import Combine
import SDWebImage

class HomeViewController: UIViewController {
    
    private lazy var viewModel : HomeViewViewModel = {
        return HomeViewViewModel()
    }()
    private var subscription : Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private lazy var addTweetButtom : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.layer.cornerRadius = 30
        buttom.clipsToBounds = true
        buttom.layer.masksToBounds = true
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,weight: .bold))
        buttom.setImage(plusSign, for: .normal)
        buttom.backgroundColor =  UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        buttom.tintColor = .white
        buttom.addTarget(self, action: #selector(didTapToAddTweet), for: .touchUpInside)
        return buttom
    }()
    
    private func configrationNavigationBar() {
        let size = 28
        let logoImage = UIImageView(frame : CGRect(x: 0 , y: 0, width: size, height: size))
        logoImage.contentMode = .scaleAspectFit
        logoImage.image = UIImage(named: "twitterLogo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImage)
        navigationItem.titleView = middleView
        let settingImage = UIImage(systemName: "gearshape")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingImage , style: .plain, target: self, action: #selector(didTapToSetting))
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(profileTap))
    }
    
    private func profileBarButtomItem(avatarPath : String)-> UIBarButtonItem {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 15
        let buttom = UIButton(frame: customView.bounds)
        buttom.addTarget(self, action: #selector(profileTap), for: .touchUpInside)
        buttom.sd_setImage(with: URL(string: avatarPath),for: .normal , placeholderImage: UIImage(systemName: "person"))
        customView.addSubview(buttom)
        let customBarButttomItem = UIBarButtonItem(customView: customView)
        return customBarButttomItem
    }
    
    private let timeLineTabelView : UITableView = {
        let tabelView = UITableView()
        tabelView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifer)
        return tabelView
    }()

    private let activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timeLineTabelView)
        view.addSubview(addTweetButtom)
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        
        timeLineTabelView.delegate = self
        timeLineTabelView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        timeLineTabelView.refreshControl = refreshControl
        
        configrationNavigationBar()
        configrationConstraint()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        activityIndicator.startAnimating()
        handelAuthentication()
        viewModel.retreiveUser()
        bindView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeLineTabelView.frame = view.frame
        
    }
    
    @objc func didTapRefresh(){
        viewModel.retreiveUser()
        bindView()
    }
    
    @objc private func profileTap(){
        let vc = ProfileViewController(user: viewModel.user ?? TwitterUser(from: Auth.auth().currentUser!))
        vc.headerView.editButton.addTarget(self, action: #selector(didTapToEdit), for: .touchUpInside)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func didTapToEdit(){
        let vc = UINavigationController(rootViewController: EditProfileViewController(user: viewModel.user ?? TwitterUser(from: Auth.auth().currentUser!)))
        self.present(vc, animated: true)
    }
    
    @objc private func didTapToAddTweet(){
        let vc = UINavigationController(rootViewController: TweetViewController(user: viewModel.user ?? TwitterUser(from: Auth.auth().currentUser!) , viewModel: TweetViewViewModel()))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func didTapToSetting(){
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handelAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnBoardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func completeUerOnboarding(){
        let vc = UINavigationController(rootViewController: EditProfileViewController(user: viewModel.user ?? TwitterUser(from: Auth.auth().currentUser!)))
        self.present(vc, animated: true)
    }
    
    private func bindView(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else{return}
            if !user.isUserOnboarded {
                self?.completeUerOnboarding()
            }
            self?.navigationItem.leftBarButtonItem = self?.profileBarButtomItem(avatarPath: user.avatarPath)
        }
        .store(in: &subscription)
    
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timeLineTabelView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        .store(in: &subscription)

        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.PresentAlert(msg: error, form: self!)
        }.store(in: &subscription)
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func configrationConstraint() {
        let addTweetButtomConstraint = [
            addTweetButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTweetButtom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            addTweetButtom.widthAnchor.constraint(equalToConstant: 60),
            addTweetButtom.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(addTweetButtomConstraint)
    }
    
    

}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifer , for: indexPath) as? TweetTableViewCell else{ return UITableViewCell() }
        cell.delegte = self
        let tweet = viewModel.tweets[indexPath.row]
        cell.configrationTweet(displayName: tweet.author.displayName,
                               userName: tweet.author.userName,
                               tweetContent: tweet.tweetContent,
                               avatarPath: tweet.author.avatarPath)
        cell.likeButton.tag = indexPath.row
        if viewModel.likesTweetIds.contains(tweet.id){

            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = .red
        }else{
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .systemGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsTweetViewController(tweet: viewModel.tweets[indexPath.row], myData: viewModel.user!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension HomeViewController : TweetTableViewCellDelegte {
   
    func TweetTableViewCellDidTapReplay() {
        print("replay")
    }
    
    func TweetTableViewCellDidTapRetweet() {
        print("retweet")
    }
    func TweetTableViewCellDidTapLike(tag: Int) {
        viewModel.tweetId = viewModel.tweets[tag].id
        viewModel.getSpecificTweet()
    }
    
    func TweetTableViewCellDidTapShare() {
        print("share")
    }
    
    
}
