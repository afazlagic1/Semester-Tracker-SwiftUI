//
//  SubjectsTable.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 3. 2023..
//

import SwiftUI

struct SubjectsTable: View {
    @EnvironmentObject var subjectListViewModel: SubjectListViewModel
    var body: some View {
        VStack {
            ForEach(Array(subjectListViewModel.subjectList.enumerated()), id: \.element)
            {
                index, subject in
                SubjectRow(subject: subject)
            }
        }
    }
}

struct SubjectsTable_Previews: PreviewProvider {
    static let subjs: SubjectListViewModel = {
        var s = SubjectListViewModel()
        s.subjectList = subjectPreviewDataList
        return s
    }()
    static var previews: some View {
        SubjectsTable()
            .environmentObject(SubjectListViewModel())
            .environmentObject(StatusListViewModel())
    }
}
