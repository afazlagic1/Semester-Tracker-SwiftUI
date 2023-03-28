//
//  StatusPreviewData.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 27. 3. 2023..
//

import Foundation
import SwiftUI

var student = Student(id: 1, name: "Harry", surname: "Potter", username: "teamgriff1", password: "12345")
var teacher = Teacher(id: 1, name: "Albus", surname: "Dumbledore", role: "professor")
var generalEvent = GeneralEvent(id: 1, eventType: "lecture", subject: subjectPreviewData, teacher: teacher, maxPoints: 0)
var event = Event(id: 1, date: "02/02/2023", generalEvent: generalEvent)
var status = Status(id: 1, studentId: 1, eventId: 1, attendance: "presence", points: 0, raiting: "1")

var statusPreviewData = status
var statusListPreviewData = [Status](repeating: status, count: 4)
