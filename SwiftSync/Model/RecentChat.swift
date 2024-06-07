//
//  RecentChat.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 02/04/24.
//

import FirebaseFirestoreSwift
import Foundation

struct RecentChat: Codable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
}
