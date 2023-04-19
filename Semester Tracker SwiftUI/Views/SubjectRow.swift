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
            SubjectTitle(subject: subject)
                .padding(.horizontal, 5);
            Spacer()
            //            //MARK: attendance check cells
            HStack {
                ForEach(weeks, id: \.i) { week in
                    StatusCell()
                }
            }
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
