//
//  SubjectTableHeader.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 24.05.2023.
//

import SwiftUI

struct SubjectsTableHeader: View {
    var weeks: [Week]

    var body: some View {
        HStack {
            Spacer()
            ForEach(weeks) { week in
                CellRectangle(
                    backgroundColor: Color.white,
                    content: Text("W\(week.id + 1)").bold().font(.body)
                        .foregroundColor(week.isCurrentWeek ? .purple : .text)
                ).opacity(week.ended ? 0.5 : 1).strikethrough(week.ended)
            }
        }
    }
}
