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

struct Week: Identifiable {
    var id: Int
    var week_i: Int
    var start: Date
    var end: Date

    var ended: Bool {
        return end < Date()
    }

    var isCurrentWeek: Bool {
        let currDate = Date()
        return start <= currDate && currDate <= end
    }
}

struct SubjectsTable: View {
    var semester: Event
    var fr = Firestore.firestore()
    private let calendar = Calendar.current
    @State var eventTypeSelection = "lecture"

    @FirestoreQuery(collectionPath: "events", predicates: [
        .whereField("type", isEqualTo: "subject")
    ], decodingFailureStrategy: .raise) private var subjects: [Event]

    @FirestoreQuery(collectionPath: "events", predicates: [
            .whereField("type", isNotIn: ["subject", "semester"])
    ], decodingFailureStrategy: .raise) private var events: [Event]

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
                    id: i, week_i: week_i, start: week_start_date,
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

    private func changeSemesterPredicates() {
        if let id = semester.id {
            let parentRef = "/events/\(id)"
            let parent = parentRef

            NSLog("Changed semester filtering to '\(semester.name)' parentRef=\(parentRef) type=subject")

            if ($subjects.error != nil) {
                NSLog($subjects.error!.localizedDescription);
                NSLog($subjects.error.debugDescription)
                return;
            }

            $subjects.predicates = [
                .whereField("type", isEqualTo: "subject"),
                .whereField("parent", isEqualTo: parent)
            ]
        }
    }

    private func changeSubjectPredicates() {
        var parentSubjects = [String]()
        for subject in subjects {
            if let id = subject.id {
                parentSubjects.append("/events/\(id)")
            }
        }

        NSLog("Changed event filtering to subjects '\(subjects.map { $0.shortcut })'")

        if !parentSubjects.isEmpty {
            $events.predicates = [
                .whereField("parentSubject", isIn: parentSubjects)
            ]
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                //MARK: Filter bars by lecture & by attendence
                FilterBar(selection: $eventTypeSelection).padding([.bottom], 10)

                if $subjects.error != nil {
                    Text("Error loading subjects: \($subjects.error.debugDescription)")
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        SubjectsTableHeader(weeks: weeks)

                        ForEach(subjects) { subject in
                            viewForSubjectRow(subject: subject)
                        }
                    }
                }
            }.onChange(of: semester.id) { _ in
                changeSemesterPredicates()
            }.onChange(of: subjects) { _ in
                changeSubjectPredicates()
            }
            .task(id: semester.id) {
                changeSemesterPredicates()
                changeSubjectPredicates()
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
        }

//        VStack {
//            Text("DEBUG Event count: \(events.count)").bold()
//            ForEach(events) { event in
//                Text("\(event.shortcut) \(event.parentSubject!.documentID)")
//            }
//        }.border(Color.black, width: 1)
    }

    @ViewBuilder
    private func viewForSubjectRow(subject: Event) -> some View {
        let filteredEvents = events.filter {
            $0.parentSubject == "/events/\(subject.id!)"
            && $0.type == eventTypeSelection
        }

        if filteredEvents.count > 0 {
            SubjectRow(subject: subject, weeks: weeks, events: filteredEvents)
        }
    }
}

struct SubjectsTableHeader: View {
    var weeks: [Week]

    var body: some View {
        HStack {
            Spacer()
            ForEach(weeks) { week in
                CellRectangle(
                    backgroundColor: Color.white,
                    content: Text("W\(week.id + 1)").bold().font(.body)
                        .foregroundColor(week.isCurrentWeek ? .purple : .text)
                ).opacity(week.ended ? 0.5 : 1).strikethrough(week.ended)
            }
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
