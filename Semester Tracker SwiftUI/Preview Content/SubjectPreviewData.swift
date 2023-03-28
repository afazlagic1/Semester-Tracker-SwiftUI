//
//  SubjectPreviewData.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import Foundation
import SwiftUI

var subjectPreviewData = Subject(id: 1, name: "Defence Against the Dark Arts", subjectCode: "PA111", semester: Semester(id: 1, academicYear: 2023, semesterType: "spring"))

var subjectPreviewDataList = [Subject](repeating: subjectPreviewData, count: 10)
