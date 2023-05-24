//
//  EventStatus.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 19.04.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct EventStatus: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var parent: String
    var parentSubject: String
    var attributes: [String: String]
}
