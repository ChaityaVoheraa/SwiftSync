//
//  UserTableViewCell.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 30/03/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: User) {
        usernameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { avatarImage in
                self.avatarImageView.image = avatarImage?.circleMasked
            }
        } else {
            avatarImageView.image = UIImage(named: "avatar")
        }
    }
}
