//
//  StatusCell.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import SwiftUIFontIcon

struct StatusCell: View {
    let fontsize: CGFloat = 35
    var event: Event? = nil
    var attendance: String? = nil
    var setAttendance: (String) -> Void
    var week: Week

    var backgroundColor: Color {
        switch attendance {
        case "presence":
            return .green
        case "distraction":
            return .orange
        case "absence":
            return .red
        case "unfilled":
            return .gray
        default:
            return .gray
        }
    }
    
    var icon: FontCode {
        switch attendance {
        case "presence":
            return .awesome5Solid(code: .check)
        case "distraction", "unfilled":
            return .awesome5Solid(code: .question)
        case "absence":
            return .awesome5Solid(code: .times)
        default:
            return .awesome5Solid(code: .minus)
        }
    }

    var body: some View {
        Button(action: {
            switch attendance {
            case "unfilled":
                setAttendance("presence")
            case "absence":
                setAttendance("unfilled")
            case "distraction":
                setAttendance("absence")
            case "presence":
                setAttendance("distraction")
            default:
                break
            }
        }) {
            let icon = FontIcon.text(icon, fontsize: fontsize, color: backgroundColor)
            CellRectangle(backgroundColor: backgroundColor.opacity(0.25), content: icon, fixedHeight: true)
                .shadow(radius: shadowRadius).opacity(week.ended ? 0.5 : 1)
        }.disabled(attendance == nil)
    }
}

struct CellRectangle: View {
    var backgroundColor: Color = Color.white
    let iconSize: CGFloat = 55
    var content: Text
    var fixedHeight: Bool = false

    var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(backgroundColor)
            .frame(width: iconSize, height: fixedHeight ? iconSize : 15)
            .overlay { content }
    }
}
