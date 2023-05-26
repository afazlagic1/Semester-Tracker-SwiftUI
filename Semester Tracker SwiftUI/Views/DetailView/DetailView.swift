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
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: TITLE
                    Text("\(subject.shortcut): \(subject.name)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.text)
                    // MARK: DESCRIPTION
                    Text(subject.description)
                        .font(.headline)

                    Divider()
                    Text("📅 Events").font(.title)
                    HStack {
                        Text("Total subject event completion: ")
                        ProgressDisplay(progress: totalEstimatedAttendanceCompletion, maxValue: 100)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack {
                            SubjectsTableHeader(weeks: weeks)

                            ForEach(eventTypes.indices, id: \.hashValue) { index in
                                let filteredEvents = EventUtils.filterEventsByType(events: events, eventTypeSelection: eventTypes[index])
                                let filteredEventStatus = EventUtils.filterEventStatus(events: events, eventStatus: eventStatus)

                                let estimatedCompletion = EventUtils.getEstimatedCompletion(events: filteredEvents, eventStatus: filteredEventStatus)

                                if (filteredEvents.isEmpty) {
                                    VStack {}
                                } else {
                                    SubjectRow(subject: subject, weeks: weeks, events: events, displayedEvents: filteredEvents,
                                               eventStatus: filteredEventStatus, eventTypeSelection: eventTypes[index],
                                               displayMode: .eventType, estimatedCompletion: estimatedCompletion)
                                }
                            }
                        }.padding()
                    }.background(.white).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    Divider()
                    Text("Projects").font(.largeTitle)
                    if let attributes = subject.attributes {
                        VStack {
                            ForEach(Array(attributes.keys).sorted(by: <), id: \.self) { fieldName in
                                ProjectPointsView(fieldName: fieldName, attributes: attributes)
                            }
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

    private func ProjectPointsView(fieldName: String, attributes: [String: Field]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            let eventStatusForSubject = eventStatus.first(where: { $0.id ?? "" == subject.id })
            let pointsCallback: (Int) -> Void = { (newPoints: Int) in
                NSLog(eventStatusForSubject.debugDescription)

                var oldAttributes = eventStatusForSubject?.attributes ?? [String: String]()
                oldAttributes[fieldName] = String(newPoints)

                dataManager.setEventStatus(event: subject, attributes: oldAttributes)
            }

            Text(fieldName).font(.title)
            switch attributes[fieldName] {
            case .rangeField(let rangeField):
                let fieldValue: Int = GetFieldIntValue(
                    value: eventStatusForSubject?.attributes[fieldName] ?? "",
                    defaultValue: rangeField.default_val ?? 0
                )
                
                let minPointsToPass = rangeField.min_points_to_pass ?? 0

                Text("Min points: \(rangeField.min), max points: \(rangeField.max)")
            
                HStack {
                    let rangeFieldMax = Double(rangeField.max)
                    Text("Current progress: ")
                    ProgressDisplay(progress: (Double(fieldValue) / rangeFieldMax) * 100, maxValue: 100.0)
                }
                
                if (fieldValue >= minPointsToPass) {
                    Text("✅ Passed minimum requirements:\npoints \(fieldValue) >= \(minPointsToPass)").foregroundColor(.green).bold()
                } else {
                    Text("❌ Failed minimum requirements:\npoints \(fieldValue) >= \(minPointsToPass)").foregroundColor(.red).bold()
                }

                PointsPicker(event: subject, min:rangeField.min, max: rangeField.max,
                             setPoints: pointsCallback,
                             selectedPoints: fieldValue)

            default:
                VStack {}
            }
        }

        // TODO: ideally this should also display for points from lectures/exercises (use the same logic but with var
    }
        
    private func GetFieldIntValue(value: String, defaultValue: Int) -> Int {
        if let newValue = Int(value) {
            return newValue
        }
        return defaultValue
    }
}
