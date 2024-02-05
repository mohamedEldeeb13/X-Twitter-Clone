//
//  DetailsTweetViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 03/02/2024.
//

import UIKit
import Combine

class DetailsTweetViewController: UIViewController {
    
    private let tableView = UITableView()
    var headerView = DetailsTweetViewHeader()
    var tweet: Tweet
    var myData: TwitterUser
    var viewModel = DetailsTweetViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    init(tweet: Tweet, myData: TwitterUser){
        self.tweet = tweet
        self.myData = myData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 360)
        headerView.configureTweet(tweet: tweet)
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifer)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        headerView.likesLabel.addTarget(self, action: #selector(showLikers), for: .touchUpInside)
        headerView.replyButton.addTarget(self, action: #selector(replyTap), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.retriveComments(tweetId: tweet.id)
        bindView()
    }
    
    @objc private func showLikers(){
        let vc = FollowViewController()
        vc.title = "Liked by"
        vc.followUsersId = tweet.likers
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func replyTap(){
        viewModel.tweetID = tweet.id
        let vc = UINavigationController(rootViewController: TweetViewController(user: myData, viewModel: viewModel))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    private func bindView(){
        viewModel.$comments.sink { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.store(in: &subscriptions)
    }

}

// MARK: - + tableView
extension DetailsTweetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifer  , for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        let commentModel = viewModel.comments[indexPath.row]
        cell.configrationTweet(displayName: commentModel.author.displayName,
                            userName: commentModel.author.userName,
                            tweetContent: commentModel.commentContent,
                            avatarPath: commentModel.author.avatarPath)
        return cell
    }
      
}
