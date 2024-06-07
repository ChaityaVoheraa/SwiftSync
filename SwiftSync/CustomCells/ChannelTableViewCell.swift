//
//  ChannelTableViewCell.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var memberCountLabel: UILabel!
    @IBOutlet var lastMessageDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(channel: Channel) {
        nameLabel.text = channel.name
        aboutLabel.text = channel.aboutChannel
        memberCountLabel.text = "\(channel.memberIds.count) members"
        lastMessageDateLabel.text = timeElapsed(channel.lastMessageDate ?? Date())
        lastMessageDateLabel.adjustsFontSizeToFitWidth = true
        setAvatar(avatarLink: channel.avatarLink)
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
}
