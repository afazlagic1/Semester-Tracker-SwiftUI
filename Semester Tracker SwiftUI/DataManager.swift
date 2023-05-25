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
    
    func setEventStatus(event: Event, attributes: [String: Any]) {
        guard let eventId = event.id else {
            NSLog("Cannot set event status for event")
            return
        }
        
        guard let parentSubject = event.parentSubject else {
            NSLog("Event has no parent subject")
            return
        }

        var eventStatus = [String: Any]()
        eventStatus["parent"] = "/events/\(eventId)"
        eventStatus["parentSubject"] = parentSubject
        eventStatus["attributes"] = attributes

        db.collection("event_status").document(eventId).setData(eventStatus) { error in
            if let error = error {
                NSLog("Error creating event status: \(error.localizedDescription)")
            }
        }
    }

    func addEvent(event: Event) {
        // TODO: this create a document with id "new" in firestore
        let ref = db.collection("events").document("anesa")
        ref.setData(["attributes": [String: Field](), "description": event.description, "end": event.end, "name": event.name, "parent": event.parent ?? "", "parentSubject": event.parentSubject ?? "", "shortcut": event.shortcut, "start": event.start, "type": event.type]) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
