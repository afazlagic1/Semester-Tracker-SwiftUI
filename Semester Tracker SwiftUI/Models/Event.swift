//
//  Event.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//
import Foundation
import FirebaseFirestoreSwift
import Firebase
import FirebaseFirestore

struct Event: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var shortcut: String
    var name: String
    var description: String
    var type: EventType.RawValue
    var start: Date
    var end: Date
    var attributes: [String: Field]?
    var parent: String?
    var parentSubject: String?
}

enum Field: Codable, Hashable {
    case rangeField(RangeField)
    case optionsField(OptionsField)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let data = try? container.decode(RangeField.self) {
            self = .rangeField(data)
            return
        }

        if let data = try? container.decode(OptionsField.self) {
            self = .optionsField(data)
            return
        }

        throw DecodingError.typeMismatch(Field.self, DecodingError.Context(
            codingPath: decoder.codingPath, debugDescription: "Unable to parse Field type"))
    }
}

struct RangeField: Codable, Hashable {
    var default_val: Int?
    var min: Int
    var max: Int
    var min_points_to_pass: Int?
}

struct OptionsField: Codable, Hashable {
    var default_val: String?
    var values: [String]?
}

enum EventType: String, CaseIterable, Identifiable {
    case semester = "semester"
    case subject = "subject"
    case lecture = "lecture"
    case excercise = "excercise"
    case exam = "exam"
    case project = "project"

    var id: Self { self }
}
