//
//  SubjectsTable.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 3. 2023..
//

import SwiftUI
import Introspect

struct SubjectsTable: View {
    @EnvironmentObject var subjectListViewModel: SubjectListViewModel
    var body: some View {
        //TODO: Search bar
        //TODO: Filter by (show all/lectures only/seminars only)
        //TODO: Sort by date asc/dsc, subject name...
        //TODO: labels week1, week2...
        //MARK: Subject List
        ScrollView {
            ForEach(Array(subjectListViewModel.subjectList.enumerated()), id: \.element)
            {
                index, subject in
                SubjectRow(subject: subject)
            }
        }
        .frame(height: 370)
        .padding([.top, .bottom])
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
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
