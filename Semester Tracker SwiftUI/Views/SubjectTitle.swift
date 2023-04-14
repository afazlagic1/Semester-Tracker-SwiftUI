//
//  File.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 13.04.2023.
//

import Foundation
import SwiftUI
import SwiftUIFontIcon

struct SubjectTitle: View {
    var subject: Subject
    
    var body: some View {
        HStack {
            //MARK: icon
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon.opacity(0.2))
                .frame(width: 46, height: 46)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: .book_open), fontsize: 24, color: Color.icon)
                }
            VStack(spacing: 4) {
                //MARK: title subject
                Text(subject.subjectCode)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                //MARK: semester
                Text(subject.semester.semesterType)
                    .font(.footnote)
                    .opacity(0.7)
                //MARK: year
                Text("\(subject.semester.academicYear.description)")
                    .font(.footnote)
                    .opacity(0.7)
                
            }
        }
    }
}

//class SubjectTitle_Previews: PreviewProvider {
//    static var previews: some View {
////        SubjectTitle(subject: {});
//    }
//}
