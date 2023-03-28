//
//  Subject.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Subject: Identifiable, Decodable, Hashable {
    private(set) var id: Int
    private(set) var name: String
    private(set) var subjectCode: String
    private(set) var semester: Semester
}
