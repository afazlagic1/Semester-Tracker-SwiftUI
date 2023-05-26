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
    var subjects: [Event]
    var events: [Event]
    var eventStatus: [EventStatus]
    
    @State private var eventTypeSelection = "lecture"

    private var weeks: [Week] {
        get {
            return TimeUtils.getWeeks(event: semester)
        }
    }

    private var selectableEventTypes: [String] {
        get {
            return Array(Set(events.map { $0.type })).filter{ $0 != "subject" }.sorted().reversed()
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
                Text("🤔📚 No subjects for selected semester")
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
            $0.parentSubject == "/events/\(subject.id!)" || $0.id ?? "" == subject.id ?? ""
        }

        let filteredEventStatus = eventStatus.filter {
            filteredEvents.map { "/events/\($0.id ?? "")"
            }.contains($0.parent)
        }

        if filteredEvents.count > 0 {
            let filteredEventsFinal = EventUtils.filterEventsByType(events: filteredEvents, eventTypeSelection: eventTypeSelection)
            let filteredEventStatusFinal = EventUtils.filterEventStatus(events: filteredEventsFinal, eventStatus: filteredEventStatus)

            let estimatedCompletion = EventUtils.getEstimatedCompletion(events: filteredEventsFinal,
                                                                        eventStatus: filteredEventStatusFinal)

            SubjectRow(subject: subject, weeks: weeks,
                       events: filteredEvents, displayedEvents: filteredEventsFinal, eventStatus: filteredEventStatus,
                       eventTypeSelection: eventTypeSelection, estimatedCompletion: estimatedCompletion)
        }
    }
}
