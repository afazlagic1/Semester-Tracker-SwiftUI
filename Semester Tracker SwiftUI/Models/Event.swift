//
//  Event.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Event: Identifiable, Decodable, Hashable, ModelEntity {
    private(set) var id: Int
    private(set) var date: String
    private(set) var subject: Subject
    private(set) var eventType: EventType.RawValue

    private(set) var teacher: Teacher?
    private(set) var maxPoints: Int?

    var dateParse: Date {
        date.dateParsed()
    }
    
    func dictionary() -> [String : Any] {
        var data: [String: Any] = [
            "id": id, "date": date, "subject": subject.id, "eventType": eventType
        ]
        
        if let teacher = teacher {
            data["teacher"] = teacher.id
        }
        
        if let maxPoints = maxPoints {
            data["maxPoints"] = maxPoints
        }
        
        return data
    }
}

enum EventType: String {
    case lecture = "lecture"
    case excercise = "excercise"
    case exam = "exam"
}
