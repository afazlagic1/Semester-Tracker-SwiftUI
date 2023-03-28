//
//  Teacher.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Teacher: Identifiable, Decodable, Hashable {
    private(set) var id: Int
    private(set) var name: String
    private(set) var surname: String
    private(set) var role: RoleType.RawValue
}

enum RoleType: String {
    case professor = "professor"
    case assistant = "assistant"
}
