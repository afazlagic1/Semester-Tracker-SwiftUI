//
//  Semester.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Semester: Identifiable, Decodable, Hashable {
    private(set) var id: Int
    private(set) var academicYear: Int
    private(set) var semesterType: SemesterType.RawValue
}

enum SemesterType: String {
    case spring = "spring"
    case fall = "fall"
}
