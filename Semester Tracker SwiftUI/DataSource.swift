//
//  DataSource.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 14.04.2023.
//

import Foundation
import Firebase

final class DataSource: ObservableObject {
    @Published var subjects = [Int]();
    
    var frb: FirebaseConnection
    
    init() {
        frb = FirebaseConnection()
//        generate_sample_data()
    }
    
    internal func generate_sample_data() {
        let sample_data_gen = FirebaseSampleDataGenerator(frb: frb)
        sample_data_gen.generate()
    }
}


class FirebaseSampleDataGenerator {
    var frb: FirebaseConnection;
    
    init(frb: FirebaseConnection = FirebaseConnection()) {
        self.frb = frb
    }
    
    func generate() {
//        var spring_semester = Event(id: "fall2023", name: "Fall 2023", description: "Fall semester 2023", type: "semester", start: Date.now, end: Date.now, attributes: [:]);
//        
//        var subject1 = Event(id: "fall2023-PA333", )
//        
//        var student1 = Person(username: "xharryp01", name: "Harry", surname: "Potter", roles: ["student": ""])
    
//        var spring_semester = Semester(id: 0, academicYear: 2023, semesterType: "spring")
//        var fall_semester = Semester(id: 1, academicYear: 2023, semesterType: "fall")
//
//        var teacher_dumbledore = Teacher(id: 0, name: "Albus", surname: "Dumbledore", role: "professor")
//
//        var subject1 = Subject(id: 0, name: "History of Magic", subjectCode: "PA333", semester: spring_semester)
//
//        var student1 = Student(
//            id: 0, name: "Harry", surname: "Potter", username: "teamgriff1",
//            subjects: [subject1], password: "12345"
//        )
//
//        var event = Event(id: 0, date: "2023-01-01", subject: subject1, eventType: "lecture")
//
//        var status = Status(id: 0, student: student1, event: event, attendance: "mandatory", points: 0, rating: "3")
//
//        frb.addDocument(collection: "semesters", document: spring_semester)
//        frb.addDocument(collection: "semesters", document: fall_semester)
//
//        frb.addDocument(collection: "teachers", document: teacher_dumbledore)
//
//        frb.addDocument(collection: "statuses", document: status)
//
//        frb.addDocument(collection: "students", document: student1)
//        frb.addDocument(collection: "subjects", document: subject1)
//        frb.addDocument(collection: "events", document: event)
    }
}
