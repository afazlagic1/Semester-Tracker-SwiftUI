//
//  SubjectRow.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import SwiftUIFontIcon
import Introspect

enum DisplayMode {
    case subject
    case eventType
}

struct SubjectRow: View {
    var subject: Event
    var weeks: [Week]
    var events: [Event] = []
    var displayedEvents: [Event] = []
    var eventStatus: [EventStatus] = []
    var eventTypeSelection: String
    var displayMode: DisplayMode = .subject
    var estimatedCompletion: Double
    @EnvironmentObject var dataManager: DataManager

    private var weekEvents: [(Week, [Event])] {
        get {
            return weeks.map { week in
                (week, displayedEvents.filter {event in
                    event.start >= week.start && event.start < week.end})
            }
        }
    }
    
    private var eventTypeEmote: String {
        get {
            switch eventTypeSelection {
            case "lecture":
                return "📚"
            case "exercise":
                return "🔬"
            case "exam":
                return "📝"
            default:
                return "📚"
            }
        }
    }

    var body: some View {
        HStack {
            // TODO: this should show the estimated completion for all event types, not just the
            // one currently filtered
            switch displayMode {
            case .subject:
                NavigationLink(destination: DetailView(subject: subject, events: events,
                                                       eventStatus: eventStatus, weeks: weeks)) {
                    SubjectTitle(title: Text(subject.shortcut).underline(), icon: Text(eventTypeEmote),
                                 progress: estimatedCompletion).padding(.horizontal, 5)
                }
            case .eventType:
                SubjectTitle(title: Text(eventTypeSelection.capitalized), icon: Text(eventTypeEmote),
                             progress: estimatedCompletion).padding(.horizontal, 5)
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
                let eventStatus = EventUtils.filterEventStatus(events: [weekEvents[0]], eventStatus: eventStatus)

                var origData = [String: String ]()
                if (!eventStatus.isEmpty) {
                    origData = eventStatus[0].attributes
                }

                origData["attendance"] = newAttendance

                dataManager.setEventStatus(event: weekEvents[0], attributes: origData)
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

        if let eventStatus = eventStatus.first(where: { $0.parent == "/events/\(event.id ?? "")"}) {
            return eventStatus.attributes["attendance"] ?? "unfilled"
        }

        return "unfilled"
    }
}
