//
//  ChannelDetailTableViewControllerDelegate.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 23/04/24.
//

import UIKit

protocol ChannelDetailTableViewControllerDelegate {
    func didClickFollow()
}

class ChannelDetailTableViewController: UITableViewController {
    // MARK: - IBActions
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var membersLabel: UILabel!
    @IBOutlet var aboutTextView: UITextView!
    
    // MARK: - Vars
    
    var channel: Channel!
    var delegate: ChannelDetailTableViewControllerDelegate?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        showChannelData()
        configureRightBarButton()
    }
    
    // MARK: - Configure
    
    private func showChannelData() {
        title = channel.name
        nameLabel.text = channel.name
        membersLabel.text = "\(channel.memberIds.count) Members"
        aboutTextView.text = channel.aboutChannel
        setAvatar(avatarLink: channel.avatarLink)
    }
    
    private func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(followChannel))
    }
    
    private func setAvatar(avatarLink: String) {
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { avatarImage in
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "avatar")
                }
            }
        } else {
            avatarImageView.image = UIImage(named: "avatar")
        }
    }
    
    // MARK: - Actions
    
    @objc func followChannel() {
        channel.memberIds.append(User.currentId)
        FirebaseChannelListener.shared.saveCannel(channel)
        delegate?.didClickFollow()
        navigationController?.popViewController(animated: true)
    }
}
