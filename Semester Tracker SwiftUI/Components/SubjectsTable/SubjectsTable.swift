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
            .background(.white)
            .cornerRadius(frameCornerRadius)
            .shadow(radius: shadowRadius)
        }
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
                }.padding(.leading, 5).overlay(GradientOverlay().allowsHitTesting(false))
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
                eventStatus: filteredEventStatus,
                eventTypeSelection: eventTypeSelection,
                estimatedCompletion: eventView.estimatedCompletion
            )
        }
    }
}

struct FilterBar: View {
    @Binding var selection: String
    var items: [String]
    
    var body: some View {
        VStack {
            Picker("Pick event type.", selection: $selection) {
                ForEach(items, id: \.self) {
                    Text($0.capitalized)
                }
            }.pickerStyle(.segmented)
        }
    }
}
