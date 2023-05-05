//
//  StatusCell.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import SwiftUIFontIcon

struct StatusCell: View {
//    var status: Status
    let iconSize: CGFloat = 55
    var attendance: String? = nil
    
    var body: some View {
//        //MARK: date
//        Text(DateFormatter.dayMonthFormat.string(from: status.event.dateParse))
//            .font(.subheadline)
//            .fontDesign(.monospaced)
        // MARK: icon
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(Color.icon.opacity(0.2))
            .frame(width: iconSize, height: iconSize)
            .overlay {
                if(attendance == "presence") {
                    FontIcon.text(.awesome5Solid(code: .check), fontsize: 35, color: .green)
                }
                else if(attendance == "absence") {
                    FontIcon.text(.awesome5Solid(code: .plus), fontsize: 35, color: .red
                    ).rotationEffect(Angle(degrees: 45))
                }
                else if(attendance == "distraction") {
                    FontIcon.text(.awesome5Solid(code: .question), fontsize: 35, color: .orange
                    )
                } else if attendance == nil {
                    FontIcon.text(.awesome5Solid(code: .minus), fontsize: 35, color: Color.icon.opacity(0.25))
                }
            }.shadow(radius: .pi)
    }
}

//struct StatusCell_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusCell(status: statusPreviewData)
//    }
//}
