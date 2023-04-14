//
//  Teacher.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Teacher: Identifiable, Decodable, Hashable, ModelEntity {
    private(set) var id: Int
    private(set) var name: String
    private(set) var surname: String
    private(set) var role: RoleType.RawValue
    
    func dictionary() -> [String : Any] {
        return [
            "id": id,
            "name": name,
            "surname": surname,
            "role": role
        ]
    }
}

enum RoleType: String {
    case professor = "professor"
    case assistant = "assistant"
}
