//
//  Channel.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Channel: Codable {
    var id = ""
    var name = ""
    var adminId = ""
    var memberIds = [""]
    var avatarLink = ""
    var aboutChannel = ""
    @ServerTimestamp var createdDate = Date()
    @ServerTimestamp var lastMessageDate = Date()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case adminId
        case memberIds
        case avatarLink
        case aboutChannel
        case createdDate
        case lastMessageDate = "date"
    }
}
