//
//  SubjectPreviewData.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import Foundation
import SwiftUI

var semester = Semester(id: 1, academicYear: 2023, semesterType: "spring")
var subjectPreviewData = Subject(id: 1, name: "Defence Against the Dark Arts", subjectCode: "PA111", semester: semester)
var subjectPreviewData2 = Subject(id: 2, name: "Theory of magic", subjectCode: "PA123", semester: semester)

var subjectPreviewDataList = [Subject](repeating: subjectPreviewData, count: 10)
//var subjectPreviewDataList = [subjectPreviewData, subjectPreviewData2]
