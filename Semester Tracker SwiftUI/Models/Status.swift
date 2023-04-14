//
//  Status.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Status: Identifiable, Decodable, Hashable, ModelEntity {
    private(set) var id: Int //Identifiable
    private(set) var student: Student
    private(set) var event: Event
    private(set) var attendance: AttendanceType.RawValue
    private(set) var points: Int
    private(set) var rating: Rating.RawValue
    
    func dictionary() -> [String: Any] {
        return [
            "id": id,
            "student": student.id,
            "event": event.id,
            "attendance": attendance,
            "points": points,
            "rating": rating
        ];
    }
}

enum AttendanceType: String {
    case presence = "presence"
    case absence = "absence"
    case distraction = "distraction"
}

enum Rating: String {
    case one1 = "1"
    case two2 = "2"
    case three3 = "3"
    case four4 = "4"
    case five5 = "5"
}
