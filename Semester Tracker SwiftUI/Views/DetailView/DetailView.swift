//
//  DetailView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 4. 2023..
//

import SwiftUI

struct DetailView: View {
    var subject: Event
    var events: [Event]
    var eventStatus: [EventStatus]
    var weeks: [Week]
    let eventTypes = ["lecture", "exercise", "exam"]
    @State private var pointsP1 = 0
    @State private var pointsP2 = 0
    private var totalEstimatedAttendanceCompletion: Double {
        get {
            return EventUtils.getEstimatedCompletion(events: events, eventStatus: eventStatus)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical,  showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: TITLE
                    Text("\(subject.shortcut): \(subject.name)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.text)
                    // MARK: DESCRIPTION
                    Text(subject.description)
                        .font(.headline)
                    Text("Total completion: ").font(.title)
                    ProgressDisplay(progress: totalEstimatedAttendanceCompletion, maxValue: 100)

                    ScrollView(.horizontal, showsIndicators: false) {
                        SubjectsTableHeader(weeks: weeks)

                        ForEach(eventTypes.indices, id: \.hashValue) { index in
                            let filteredEvents = EventUtils.filterEventsByType(events: events, eventTypeSelection: eventTypes[index])
                            let filteredEventStatus = EventUtils.filterEventStatus(events: events, eventStatus: eventStatus)

                            let estimatedCompletion = EventUtils.getEstimatedCompletion(events: filteredEvents, eventStatus: filteredEventStatus)

                            SubjectRow(subject: subject, weeks: weeks, events: events, displayedEvents: filteredEvents,
                                       eventStatus: filteredEventStatus, eventTypeSelection: eventTypes[index],
                                       displayMode: .eventType, estimatedCompletion: estimatedCompletion)
                        }
                    }.background(.white).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    Text("Projects").font(.title)
                    if let attributes = subject.attributes {
                        ForEach(Array(attributes.keys), id: \.self) { fieldName in
                            Text(fieldName)
                            let projectF = attributes[fieldName]
                            Text("\(projectF.debugDescription)")
                            // TODO: fix this to generate pickers for project points (from the var subject)
                            // TODO: ideally this should also display for points from lectures/exercises (use the same logic but with var
                            // events which contains the individual lectures/exercises/exams)

//                            switch projectF {
//                            case .rangeField(let rangeField):
//                                Picker(selection: $pointsP1, in: rangeField.min...rangeField.max)
//                                Text("test")
//                                break
//                            default:
//                                Text("Asdf")
//                                break
//                            }
                        }
                    } else {
                        Text("No projects")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
            .padding().background(Color.background)
    }
}
