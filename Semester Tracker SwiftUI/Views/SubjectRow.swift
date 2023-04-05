//
//  SubjectRow.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import SwiftUIFontIcon
import Introspect

struct SubjectRow: View {
    var subject: Subject
    @EnvironmentObject var statusListViewModel: StatusListViewModel
    @EnvironmentObject var subjectListViewModel: SubjectListViewModel
    var body: some View {
        HStack {
            HStack {
                //MARK: icon
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.icon.opacity(0.2))
                    .frame(width: 46, height: 46)
                    .overlay {
                        FontIcon.text(.awesome5Solid(code: .book_open), fontsize: 24, color: Color.icon)
                    }
                VStack(spacing: 4) {
                    //MARK: title subject
                    Text(subject.subjectCode)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(1)
                    //MARK: semester
                    Text(subject.semester.semesterType)
                        .font(.footnote)
                        .opacity(0.7)
                    //MARK: year
                    Text("\(subject.semester.academicYear.description)")
                        .font(.footnote)
                        .opacity(0.7)
                    
                }
            }
            .padding(.horizontal, 5)
            Spacer()
            //MARK: attendance check cells
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(statusListViewModel.statusList.enumerated()), id: \.element)
                    {
                         index, status in
                        StatusCell(status: status)
                        
                    }
                }
                .padding([.horizontal])
            }
        }
    }
}

struct SubjectRow_Previews: PreviewProvider {
//    static let statusListForPreview: StatusListViewModel = {
//        var s = StatusListViewModel()
//        //rewrite the init method with preview data
//        //s.statusList = statusListPreviewData
//        return s
//    }()
    static var previews: some View {
        SubjectRow(subject: subjectPreviewData)
            .environmentObject(StatusListViewModel()) //read from statuses.json
            .environmentObject(SubjectListViewModel())
    }
}
