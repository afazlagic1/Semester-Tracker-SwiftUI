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
    var subject: Event
    var weeks: [Week]
    var events: [Event]? = []
    
    var body: some View {
        HStack {
            NavigationLink(destination: DetailView(subject: subject)) {
                SubjectTitle(subject: subject).padding(.horizontal, 5)
            }
            Spacer()
            HStack {
                ForEach(weeks, id: \.i) { week in
                    viewForStatusCell(week: week)
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewForStatusCell(week: Week) -> some View {
        let weekEvents = events!.filter {
            $0.start >= week.start && $0.start < week.end
        }

        if weekEvents.count > 0 {
            StatusCell(attendance: "presence")
        } else {
            StatusCell()
        }
    }
}

//struct SubjectRow_Previews: PreviewProvider {
////    static let statusListForPreview: StatusListViewModel = {
////        var s = StatusListViewModel()
////        //rewrite the init method with preview data
////        //s.statusList = statusListPreviewData
////        return s
////    }()
//    static var previews: some View {
////        SubjectRow(subject: subjectPreviewData)
////            .environmentObject(StatusListViewModel()) //read from statuses.json
////            .environmentObject(SubjectListViewModel())
//    }
//}

struct Previews_SubjectRow_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
