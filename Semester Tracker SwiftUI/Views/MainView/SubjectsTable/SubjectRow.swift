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

    private var weekEvents: [(Week, [Event])] {
        get {
            return weeks.map { week in
                (week, events!.filter {event in
                    event.start >= week.start && event.start < week.end})
            }
        }
    }

    var body: some View {
        HStack {
            NavigationLink(destination: DetailView(subject: subject)) {
                SubjectTitle(subject: subject, icon: Text("📚")).padding(.horizontal, 5)
            }
            Spacer()
            HStack {
                ForEach(weekEvents, id: \.0.id) { (week, weekEvents) in
                    viewForStatusCell(week: week, weekEvents: weekEvents)
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewForStatusCell(week: Week, weekEvents: [Event]) -> some View {
        // Partial specification of the callback for setting attendance in Firestore
        let attendanceCallback: (String) -> Void = { (newAttendance: String) in
            if (!weekEvents.isEmpty) {
                setAttendance(event: weekEvents[0], newAttendance: newAttendance)
            }
        }

        if weekEvents.count > 0 {
            StatusCell(attendance: "unfilled", setAttendance: attendanceCallback, week: week)
        } else {
            StatusCell(setAttendance: attendanceCallback, week: week)
        }
    }

    // TODO: connect callback to setting attendance in Firestore
    private func setAttendance(event: Event, newAttendance: String) {
        print("New attendance for event \(event.shortcut) = \(newAttendance)")
    }
}
 
