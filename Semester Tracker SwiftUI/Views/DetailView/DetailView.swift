//
//  DetailView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 4. 2023..
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataManager: DataManager
    var subject: Event
    var events: [Event]
    var eventStatus: [EventStatus]
    var weeks: [Week]
    let eventTypes = ["lecture", "exercise", "exam"]

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
                            let eventStatusForSubject = eventStatus.first(where: { $0.id ?? "" == subject.id })

                            let pointsCallback: (Int) -> Void = { (newPoints: Int) in
                                NSLog(eventStatusForSubject.debugDescription)
                                print("New points: \(newPoints)")

                                var oldAttributes = eventStatusForSubject?.attributes ?? [String: String]()
                                oldAttributes[fieldName] = String(newPoints)

                                dataManager.setEventStatus(event: subject, attributes: oldAttributes)
                            }

                            Text(fieldName).font(.title)
                            switch attributes[fieldName] {
                            case .rangeField(let rangeField):
                                PointsPicker(event: subject, min:rangeField.min, max: rangeField.max,
                                             setPoints: pointsCallback, selectedPoints: rangeField.default_val)
                            default:
                                VStack {}
                            }

                            // TODO: fix this to generate pickers for project points (from the var subject)
                            // TODO: ideally this should also display for points from lectures/exercises (use the same logic but with var
                            // events which contains the individual lectures/exercises/exams)
                        }
                    } else {
                        Text("No projects")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .padding().background(Color.background).onAppear {
            eventStatus.map { $0.id ?? "" }.forEach {
                status in
                print(status)
            }
        }
    }
}
