//
//  DataManager.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 10. 5. 2023..
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var subjects: [Event] = [Event(shortcut: "", name: "name", description: "description", type: "subject", start: Date(), end: Date())]
    
    init() {
        //
        fetchSubjects()
    }
    
    func fetchSubjects() {
        let db = Firestore.firestore()
        let ref = db.collection("events")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                self.subjects = []
                for document in snapshot.documents {
                    let data = document.data()
                    
                    if(data["type"] as? String ?? "" == "subject") {
                        let description = data["description"] as? String ?? ""
                        let shortcut = data["shortcut"] as? String ?? ""
                        let start = data["start"] as? Date ?? Date()
                        let end = data["end"] as? Date ?? Date()
                        let name = data["name"] as? String ?? ""
                        
                        self.subjects.append(Event(shortcut: shortcut, name: name, description: description, type: "subject", start: start, end: end))
                    }
                }
            }
        }
    }
    
    func addAttendance(event: Event) {
//        print(event.name)
//        let db = Firestore.firestore()
//        let ref = db.collection("events").document("new")
//        ref.setData([""])
    }
}
