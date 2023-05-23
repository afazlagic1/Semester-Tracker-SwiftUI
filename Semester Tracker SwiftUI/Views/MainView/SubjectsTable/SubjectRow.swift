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
    
    var body: some View {
        HStack {
            NavigationLink(destination: DetailView(subject: subject)) {
                SubjectTitle(subject: subject, icon: Text("📚")).padding(.horizontal, 5)
            }
            Spacer()
            HStack {
                ForEach(weeks) { week in
                    viewForStatusCell(week: week)
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewForStatusCell(week: Week) -> some View {
        let weekEvents = events!.filter {
            $0.start >= week.start && $0.start < week.end
        }

        if weekEvents.count > 0 {
            StatusCell(attendance: "unfilled", week: week)
        } else {
            StatusCell(week: week)
        }
    }
}
