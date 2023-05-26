//
//  Utils.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 24.05.2023.
//

import Foundation


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

class TimeUtils {
    private static let calendar = Calendar.current

    static func get_week_start(date: Date) -> Date? {
        if let newDate = calendar.date(
            from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)) {
            return newDate
        }
        return nil
    }

    static func getWeeks(event: Event) -> [Week] {
        var weeks: [Week] = []
        var date = get_week_start(date: event.start)!
        var i = 0

        while date < event.end {
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

class EventUtils {
    static func filterEventsByType(events: [Event]?, eventTypeSelection: String) -> [Event] {
        if let events = events {
            return events.filter { $0.type == eventTypeSelection }
        }
        return []
    }
    
    static func getEstimatedCompletionForType(events: [Event]?, eventStatus: [EventStatus], eventTypeSelection: String) -> Double {
        let filteredEvents = EventUtils.filterEventsByType(events: events, eventTypeSelection: eventTypeSelection)
        let filteredEventStatus = EventUtils.filterEventStatus(events: filteredEvents, eventStatus: eventStatus)
        return EventUtils.getEstimatedCompletion(events: filteredEvents,
                                                 eventStatus: filteredEventStatus)
    }

    static func filterEventStatus(events: [Event], eventStatus: [EventStatus]?) -> [EventStatus] {
        let filteredEventIds = events.map { "/events/\($0.id ?? "")" }
        if let eventStatus = eventStatus {
            return eventStatus.filter({
                filteredEventIds.contains($0.parent)
            })
        }
        return []
    }

    static func getEstimatedCompletion(events: [Event], eventStatus: [EventStatus]) -> Double {
        let eventCount = Double(events.count)
        let eventStatus = eventStatus.map {
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
//        print("Event count: \(eventCount) eventStatus: \(eventStatus) -> \(totalStatus)")

        return (totalStatus / eventCount) * 100
    }
}
