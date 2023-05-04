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

struct Week {
    var i: Int
    var week_i: Int
    var start: Date
    var end: Date
}

struct SubjectsTable: View {
    var semester: Event
    var fr = Firestore.firestore()
    private let calendar = Calendar.current

    @FirestoreQuery(collectionPath: "events", predicates: [
        .whereField("type", isEqualTo: "subject")
    ]) private var subjects: [Event]

    @FirestoreQuery(collectionPath: "events", predicates: [
        .whereField("parentSubject", isLessThan: "")
    ]) private var events: [Event]
    
    func get_week_start(date: Date) -> Date? {
        if let newDate = calendar.date(
            from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)) {
            return newDate
        }
        return nil
    }

    private var weeks: [Week] {
        get {
            var weeks: [Week] = []
            var date = get_week_start(date: semester.start)!
            var i = 0

            while date < semester.end {
                let week_i = calendar.component(.weekOfYear, from: date)
                
                guard let week_start_date = get_week_start(date: date) else {
                    continue
                }
                
                guard let week_end_date = calendar.date(byAdding: DateComponents(day: 6), to: week_start_date) else {
                    continue
                }

                weeks.append(Week(
                    i: i, week_i: week_i, start: week_start_date,
                    end: week_end_date
                ))
                
                if let nextStartDate = calendar.date(byAdding: .weekOfYear, value: 1, to: date) {
                    date = nextStartDate
                } else {
                    break
                }
                i += 1
            }
            return weeks
        }
    }

    var body: some View {
        //TODO: Search bar
        //TODO: Filter by (show all/lectures only/seminars only)
        //TODO: Sort by date asc/dsc, subject name...
        //TODO: labels week1, week2...
        //MARK: Subject List
        NavigationStack {
            ScrollView {
                Text(semester.name).bold()
                
                if $subjects.error != nil {
                    Text("Error loading subjects")
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ForEach(subjects) { subject in
                            NavigationLink(destination: DetailView(subject: subject)) {
                                SubjectRow(subject: subject, weeks: weeks)
                            }
                        }
                    }
                }
            }.task(id: semester.id) {
                if let id = semester.id {
                    let parent = fr.document("/events/\(id)")
                    
                    var parentSubjects = [DocumentReference]()
                    for subject in subjects {
                        if let id = subject.id {
                            parentSubjects.append(fr.document("/events/\(id)"))
                        }
                    }
                    
                    $subjects.predicates = [
                        .whereField("type", isEqualTo: "subject"),
                        .whereField("parent", isEqualTo: parent)
                    ]
                    
                    if !parentSubjects.isEmpty {
                        $events.predicates = [
                            .whereField("parentSubject", isIn: parentSubjects)
                        ]
                    }
                }
            }
            .frame(height: 370)
            .padding([.top, .bottom, .horizontal])
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
        }
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
