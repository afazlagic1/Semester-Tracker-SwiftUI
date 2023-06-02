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
    @State private var showSubjectsWithoutEvents: Bool = false
    
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

                SubjectsTableView().padding([.bottom], 10)
                Toggle(isOn: $showSubjectsWithoutEvents) {
                    Text("Show subjects without events")
                }.disabled(subjects.isEmpty)
            }.frame(minHeight: 300)
            .padding()
            .background(Color.systemBackground)
            .cornerRadius(20)
            .shadow(radius: .pi)
        }

//        #if DEBUG
//        ScrollView {
//            Text("DEBUG Event count: \(events.count)").bold()
//            ForEach(events) { event in
//                Text("shortcut=\(event.shortcut) parent=\(event.parentSubject ?? "unknown parent")")
//            }
//        }.border(Color.black, width: 1).frame(height: 100)
//        #endif
    }

    @ViewBuilder
    private func SubjectsTableView() -> some View {
        VStack {
        if (subjects.isEmpty) {
                Text("📚🤔 No subjects for selected semester")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    SubjectsTableHeader(weeks: weeks)

                    ForEach(subjects) { subject in
                        viewForSubjectRow(subject: subject)
                    }
                }.padding(.leading, 5).overlay(
                    GradientOverlay()
                )
            }
        }
    }

    @ViewBuilder
    private func viewForSubjectRow(subject: Event) -> some View {
        let filteredEvents = events.filter {
            $0.parentSubject == "/events/\(subject.id!)" ||
            $0.id ?? "" == subject.id ?? ""  // To include the Event for the subject itself
        }

        let filteredEventStatus = eventStatus.filter {
            filteredEvents.map { "/events/\($0.id ?? "")"
            }.contains($0.parent)
        }

        let eventView = EventUtils.getFilteredEventView(
            events: filteredEvents, eventStatus: filteredEventStatus, eventTypeSelection: eventTypeSelection)

        if eventView.filteredEvents.count > 0 || showSubjectsWithoutEvents {
            SubjectRow(
                subject: subject, weeks: weeks,
                events: filteredEvents, displayedEvents:
                eventView.filteredEvents,
                eventStatus: eventView.filteredEventStatus,
                eventTypeSelection: eventTypeSelection,
                estimatedCompletion: eventView.estimatedCompletion
            )
        }
    }
}
