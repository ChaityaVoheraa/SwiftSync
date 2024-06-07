//
//  FCollectionReference.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 09/02/24.
//

import FirebaseFirestore
import Foundation

enum FCollectionReference: String {
    case User
    case Recent
    case Messages
    case Typing
    case Channel
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
