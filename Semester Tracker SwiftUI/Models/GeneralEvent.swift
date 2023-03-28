//
//  GeneralEvent.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct GeneralEvent: Identifiable, Decodable, Hashable {
    private(set) var id: Int
    private(set) var eventType: EventType.RawValue
    private(set) var subject: Subject
    private(set) var teacher: Teacher
    private(set) var maxPoints: Int
}

enum EventType: String {
    case lecture = "lecture"
    case excercise = "excercise"
    case exam = "exam"
}
