//
//  FirebaseConnection.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 14.04.2023.
//

import Foundation
import FirebaseFirestore

class FirebaseConnection {
    private var db = Firestore.firestore()
    
    func addDocument(collection: String, document: ModelEntity) {
        db.collection(collection).document(String(document.id)).setData(document.dictionary())
    }
        
//    private func collectionExists(collection: String) -> Bool {
//        db.collection(collection).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot else {
//                return
//            }
//
//            return snapshot.documents.isEmpty
//        };
//    }
    
//    private func getDocument<T>(collection: String) -> T {
//        db.collection
//    }
}
