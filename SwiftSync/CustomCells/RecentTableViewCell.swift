//
//  RecentTableViewCell.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 02/04/24.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    // MARK: - IBActions
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var unreadCounterLabel: UILabel!
    @IBOutlet var unreadCounterBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unreadCounterBackgroundView.layer.cornerRadius = unreadCounterBackgroundView.frame.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(recent: RecentChat) {
        usernameLabel.text = recent.receiverName
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.9
        
        lastMessageLabel.text = recent.lastMessage
        lastMessageLabel.adjustsFontSizeToFitWidth = true
        lastMessageLabel.numberOfLines = 2
        lastMessageLabel.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            unreadCounterLabel.text = "\(recent.unreadCounter)"
            unreadCounterBackgroundView.isHidden = false
        } else {
            unreadCounterBackgroundView.isHidden = true
        }
        
        setAvatar(avatarLink: recent.avatarLink)
        dateLabel.text = timeElapsed(recent.date ?? Date())
        dateLabel.adjustsFontSizeToFitWidth = true
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
