//
//  RealmManager.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init() {}
    
    func saveToRealm<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .all)
                //                realm.delete(object)
            }
        } catch {
            print("Error saving realm Object ", error.localizedDescription)
        }
    }
}
