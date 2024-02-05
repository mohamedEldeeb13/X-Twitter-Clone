//
//  NotaficationViewController.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 24/01/2024.
//

import UIKit

class NotaficationViewController: UIViewController {

    private let notificationTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(notificationTableView)
        navigationItem.title = "Notifications"
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notificationTableView.frame = view.frame
    }
}


// MARK: - + tableView
extension NotaficationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        return cell
    }
    
    
}
