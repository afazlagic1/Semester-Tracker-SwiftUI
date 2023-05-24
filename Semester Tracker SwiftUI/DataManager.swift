//
//  DataManager.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 10. 5. 2023..
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    let db = Firestore.firestore()

    init() {
    }
    
    func getDocumentReference(documentId: String) -> DocumentReference {
        let db = Firestore.firestore()
        let collectionRef = db.collection("events")

        // Get a reference to the document with the given ID
        let documentRef = collectionRef.document(documentId)
        return documentRef
    }
    
    func setEventStatus(event: Event, attributes: [String: Any]) {
        guard let eventId = event.id else {
            NSLog("Cannot set event status for event")
            return
        }

        var eventStatus = [String: Any]()
        eventStatus["event"] = eventId
        eventStatus["attributes"] = attributes

        db.collection("event_status").document(eventId).setData(eventStatus) { error in
            if let error = error {
                NSLog("Error creating event status: \(error.localizedDescription)")
            }
        }
    }

    func addEvent(event: Event) {
        print("attendance adding")
        do {
            let _ = try db.collection("events").addDocument(from: event)
        }
        catch {
            print(error)
        }
        let ref = db.collection("events").document("new")
        ref.setData(["attributes": event.attributes ?? "", "description": event.description, "end": event.end, "name": event.name, "parent": event.parent ?? "", "parentSubject": event.parentSubject ?? "", "shortcut": event.shortcut, "start": event.start, "type": event.type]) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
