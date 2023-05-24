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
    var eventStatus: [EventStatus]? = []
    @EnvironmentObject var dataManager: DataManager
    
    private var estimatedCompletion: Double {
        get {
            let eventCount = Double(events!.count)
            let eventStatus = eventStatus!.map {
                switch $0.attributes["attendance"] {
                case "presence":
                    return 1.0
                case "distraction":
                    return 0.5
                default:
                    return 0.0
                }
            }

            let totalStatus = eventStatus.reduce(0, +)
//            print("Event count: \(eventCount) eventStatus: \(eventStatus) -> \(totalStatus)")

            return (totalStatus / eventCount) * 100
        }
    }

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
            // TODO: this should show the estimated completion for all event types, not just the
            // one currently filtered
            NavigationLink(destination: DetailView(subject: subject, progress: estimatedCompletion)) {
                SubjectTitle(subject: subject, icon: Text("📚"), progress: estimatedCompletion).padding(.horizontal, 5)
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

        let attendance = getAttendance(events: weekEvents)

        if weekEvents.count > 0 {
            StatusCell(attendance: attendance, setAttendance: attendanceCallback, week: week)
        } else {
            StatusCell(setAttendance: attendanceCallback, week: week)
        }
    }

    private func getAttendance(events: [Event]) -> String {
        if (events.isEmpty) {
            return "unfilled"
        }

        let event = events[0]

        if let eventStatus = eventStatus?.first(where: { $0.parent == "/events/\(event.id ?? "")"}) {
            return eventStatus.attributes["attendance"] ?? "unfilled"
        }

        return "unfilled"
    }

    private func setAttendance(event: Event, newAttendance: String) {
        dataManager.setEventStatus(event: event, attributes: ["attendance": newAttendance])
        print("New attendance for event \(event.id ?? "") = \(newAttendance)")
    }
}
