//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 27. 4. 2023..
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class EventRepository: ObservableObject {
    private let path = "events"
    private let store = Firestore.firestore()
    @Published var events: [Event] = []
    
    init() {
        get()
    }
    
    func get() {
        store.collection(path).addSnapshotListener{ (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.events = snapshot?.documents.compactMap {
                try? $0.data(as: Event.self)
            } ?? []
        }
    }
    
    func add(_ event: Event) {
        do {
           _ = try store.collection(path).addDocument(from: event)
            
        }
        catch {
            fatalError("Adding event failed")
        }
    }
}
