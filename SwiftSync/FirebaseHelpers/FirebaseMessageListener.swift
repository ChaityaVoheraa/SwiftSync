//
//  FirebaseMessageListener.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class FirebaseMessageListener {
    static let shared = FirebaseMessageListener()
    var newChatListener: ListenerRegistration!
    var updatedChatListener: ListenerRegistration!
    
    private init() {}
    
    func listenForNewChats(_ documentId: String, collectionId: String, lastMessageDate: Date) {
        self.newChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else { return }
            
            for change in snapshot.documentChanges {
                if change.type == .added {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            if message.senderId != User.currentId {
                                RealmManager.shared.saveToRealm(message)
                            }
                        } else {
                            print("Document doesnt exist")
                        }
                        
                    case .failure(let error):
                        print("Error decoding local message: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ updatedMessage: LocalMessage) -> Void) {
        self.updatedChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionId).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else { return }
            
            for change in snapshot.documentChanges {
                if change.type == .modified {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            completion(message)
                        } else {
                            print("Document does not exist chat")
                        }
                        
                    case .failure(let error):
                        print("Error decoding local message: \(error)")
                    }
                }
            }
        }
    }
    
    func checkForOldChats(_ documentId: String, collectionId: String) {
        FirebaseReference(.Messages).document(documentId).collection(collectionId).getDocuments { querySnapshot, _ in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents for old chats")
                return
            }
            
            var oldMessages = documents.compactMap { queryDocumentSnapshot -> LocalMessage? in
                try? queryDocumentSnapshot.data(as: LocalMessage.self)
            }
            
            oldMessages.sort(by: { $0.date < $1.date })
            
            for message in oldMessages {
                RealmManager.shared.saveToRealm(message)
            }
        }
    }
    
    // MARK: - Add, Update, Delete
    
    func addMessage(_ message: LocalMessage, memberId: String) {
        do {
            _ = try FirebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("error saving message ", error.localizedDescription)
        }
    }
    
    func addChannelMessage(_ message: LocalMessage, channel: Channel) {
        do {
            _ = try FirebaseReference(.Messages).document(channel.id).collection(channel.id).document(message.id).setData(from: message)
        } catch {
            print("error saving message ", error.localizedDescription)
        }
    }
    
    // MARK: - UpdateMessageStatus

    func updateMessageInFireStore(_ message: LocalMessage, memberIds: [String]) {
        let values = [kSTATUS: kREAD, kREADDATE: Date()] as [String: Any]
        
        for userId in memberIds {
            FirebaseReference(.Messages).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        }
    }
    
    func removeListeners() {
        self.newChatListener.remove()
        
        if self.updatedChatListener != nil {
            self.updatedChatListener.remove()
        }
    }
}
