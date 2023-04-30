//
//  EventListView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 4. 2023..
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var eventListViewModel: EventListViewModel
    var body: some View {
        Text("")
//        ScrollView {
//            Text(semester.name).bold()
//
//            if $subjects.error != nil {
//                Text("Error loading subjects")
//            } else {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    ForEach(subjects) { subject in
//                        SubjectRow(subject: subject, weeks: weeks)
//                    }
//                }
//            }
//        }.task(id: semester.id) {
//            if let id = semester.id {
//                let parent = fr.document("/events/\(id)")
//
//                var parentSubjects = [DocumentReference]()
//                for subject in subjects {
//                    if let id = subject.id {
//                        parentSubjects.append(fr.document("/events/\(id)"))
//                    }
//                }
//
//                $subjects.predicates = [
//                    .whereField("type", isEqualTo: "subject"),
//                    .whereField("parent", isEqualTo: parent)
//                ]
//
//                if !parentSubjects.isEmpty {
//                    $events.predicates = [
//                        .whereField("parentSubject", isIn: parentSubjects)
//                    ]
//                }
//            }
//        }
//        .frame(height: 370)
//        .padding([.top, .bottom, .horizontal])
//        .background(Color.systemBackground)
//        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(eventListViewModel: EventListViewModel())
    }
}
