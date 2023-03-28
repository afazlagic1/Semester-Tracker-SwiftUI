//
//  Event.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Event: Identifiable, Decodable, Hashable {
    private(set) var id: Int
    private(set) var date: String
    private(set) var generalEvent: GeneralEvent
    var dateParse: Date {
        date.dateParsed()
    }
}
