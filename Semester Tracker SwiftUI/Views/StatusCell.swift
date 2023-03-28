//
//  StatusCell.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import SwiftUIFontIcon

struct StatusCell: View {
    var status: Status
    
    var body: some View {
        
        //MARK: icon
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(Color.icon.opacity(0.2))
            .frame(width: 55, height: 55)
            .overlay {
                if(status.attendance == "presence") {
                    FontIcon.text(.awesome5Solid(code: .check), fontsize: 35, color: .green)
                }
                else if(status.attendance == "absence") {
                    FontIcon.text(.awesome5Solid(code: .plus), fontsize: 35, color: .red
                        )
                    .rotationEffect(Angle(degrees: 45))
                }
                else if(status.attendance == "distraction") {
                    FontIcon.text(.awesome5Solid(code: .meh_rolling_eyes), fontsize: 35, color: Color.icon
                    )
                }
            }
            .shadow(radius: .pi)
    }
}

struct StatusCell_Previews: PreviewProvider {
    static var previews: some View {
        StatusCell(status: statusPreviewData)
    }
}
