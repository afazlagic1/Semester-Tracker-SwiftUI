//
//  Semester.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Semester: Identifiable, Decodable, Hashable, ModelEntity {
    private(set) var id: Int
    private(set) var academicYear: Int
    private(set) var semesterType: SemesterType.RawValue
    
    func dictionary() -> [String : Any] {
        return [
            "id": id,
            "academicYear": academicYear,
            "semesterType": semesterType
        ]
    }
}

enum SemesterType: String {
    case spring = "spring"
    case fall = "fall"
}
