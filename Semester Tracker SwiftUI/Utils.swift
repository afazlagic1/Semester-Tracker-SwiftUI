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
