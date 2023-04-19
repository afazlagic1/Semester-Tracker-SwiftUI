//
//  Person.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 18.04.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Person: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var username: String
    var name: String
    var surname: String

    // Like roles = ["teacher": ["PA123"], "student": ["PA003"]]
    var roles: [String: [String]] = [
        "teacher": [], "student": []
    ]
}
