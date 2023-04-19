//
//  SubjectsTable.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 3. 2023..
//

import SwiftUI
import Introspect
import FirebaseFirestoreSwift
import Firebase

struct SubjectsTable: View {
    var semester: Event
    var fr = Firestore.firestore()

    @FirestoreQuery(collectionPath: "events", predicates: [
        .whereField("type", isEqualTo: "subject")
    ]) private var subjects: [Event]

    var body: some View {
        //TODO: Search bar
        //TODO: Filter by (show all/lectures only/seminars only)
        //TODO: Sort by date asc/dsc, subject name...
        //TODO: labels week1, week2...
        //MARK: Subject List
        ScrollView {
            Text(semester.name).bold()

            if $subjects.error != nil {
                Text("Error loading subjects")
            } else {
                ForEach(subjects) { subject in
                    Text(subject.name)
                }
            }
            
            //            ForEach(Array(subjectListViewModel.subjectList.enumerated()), id: \.element)
            //            {
            //                index, subject in
            //                SubjectRow(subject: subject)
            //            }
        }.task(id: semester.id) {
            if let id = semester.id {
                let parent = fr.document("/events/\(id)")

                $subjects.predicates = [
                    .whereField("type", isEqualTo: "subject"),
                    .whereField("parent", isEqualTo: parent)
                ]
            }
        }
        .frame(height: 370)
        .padding([.top, .bottom])
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

//struct SubjectsTable_Previews: PreviewProvider {
//    static let subjs: SubjectListViewModel = {
//        var s = SubjectListViewModel()
//        s.subjectList = subjectPreviewDataList
//        return s
//    }()
//    static var previews: some View {
//        SubjectsTable()
//            .environmentObject(SubjectListViewModel())
//            .environmentObject(StatusListViewModel())
//    }
//}
