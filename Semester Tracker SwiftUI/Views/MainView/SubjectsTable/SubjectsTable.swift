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

    var subjects: [Event]
    var events: [Event]

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
    
    private var selectableEventTypes: [String] {
        get {
            return Array(Set(events.map { $0.type })).sorted().reversed()
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                //MARK: Filter bars by lecture & by attendence
                FilterBar(selection: $eventTypeSelection, items: selectableEventTypes
                ).padding([.bottom], 10).disabled(subjects.isEmpty)

                SubjectsTableView()
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
        }

//        #if DEBUG
//        ScrollView {
//            Text("DEBUG Event count: \(events.count)").bold()
//            ForEach(events) { event in
//                Text("shortcut=\(event.shortcut) parent=\(event.parentSubject ?? "unknown parent")")
//            }
//        }.border(Color.black, width: 1)
//        #endif
    }

    @ViewBuilder
    private func SubjectsTableView() -> some View {
        VStack {
//            if subjects.error != nil {
//                Text("Error loading subjects: \(subjects.error.debugDescription)")
//            } else
        if (subjects.isEmpty) {
                Text("No subjects for selected semester")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    SubjectsTableHeader(weeks: weeks)

                    ForEach(subjects) { subject in
                        viewForSubjectRow(subject: subject)
                    }
                }
            }
        }
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
