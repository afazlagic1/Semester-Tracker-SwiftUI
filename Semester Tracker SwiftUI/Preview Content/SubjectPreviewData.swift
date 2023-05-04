//
//  SubjectPreviewData.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import Foundation
import SwiftUI
import Introspect
//
//var semester = Semester(id: 1, academicYear: 2023, semesterType: "spring")
//var subjectPreviewData = Subject(id: 1, name: "Defence Against the Dark Arts", subjectCode: "PA111", semester: semester)
//var subjectPreviewData2 = Subject(id: 2, name: "Theory of magic", subjectCode: "PA123", semester: semester)
//
//var subjectPreviewDataList = [Subject](repeating: subjectPreviewData, count: 10)
//var subjectPreviewDataList = [subjectPreviewData, subjectPreviewData2]
//events/A1CfHJtB3CGXYtUw8Nyk
var eventPreviewData = Event(id: "ZpZrWs47NGQtRQ7safBq", shortcut: "PA1100", name: "History of Magic", description: "History of Magic was the study of the history of the Wizarding world. The lessons in this class were only lectures about significant names, dates and events in wizarding history. Topics had included the Goblin Rebellions, the Witch-hunts, the Giant wars and the origin of the International Statute of Wizarding Secrecy. The class was considered very boring due to Binns' droning voice.", type: EventType.subject.rawValue, start: Date(), end: Date(), attributes: nil, parent: nil, parentSubject: nil)
var eventPreviewDataList = [Event](repeating: eventPreviewData, count: 10)
