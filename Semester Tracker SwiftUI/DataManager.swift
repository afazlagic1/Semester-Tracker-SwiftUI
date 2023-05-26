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

        var eventStatus = [String: Any]()
        eventStatus["parent"] = "/events/\(eventId)"
        eventStatus["parentSubject"] = event.parentSubject ?? ""
        eventStatus["attributes"] = attributes

        let containsKey = attributes.contains { $0.key == "attendance" }

        if containsKey {
            db.collection("event_status").document(eventId).setData(eventStatus) { error in
                if let error = error {
                    NSLog("Error creating event status: \(error.localizedDescription)")
                }
            }
        }
        else {
            db.collection("event_status").document("\(eventId)").setData(eventStatus) { error in
                if let error = error {
                    NSLog("Error creating event status: \(error.localizedDescription)")
                }
            }
        }
    }

    func addEvent(semester: Event, subject: Event, event: Event) {
        let ref = db.collection("events").document("\(semester.shortcut)_\(subject.shortcut)_\(event.shortcut)")

        ref.setData(["attributes": [String: Field](), "description": event.description, "end": event.end, "name": event.name, "parent": event.parent ?? "",
                     "parentSubject": event.parentSubject ?? "", "shortcut": event.shortcut, "start": event.start, "type": event.type]) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
