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
    var subject: Event
    var icon: Text
    let iconSize: CGFloat = 50

    var body: some View {
        HStack {
            // MARK: icon
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.icon.opacity(0.1))
                .frame(width: iconSize, height: iconSize)
                .overlay {
                    icon.font(.system(size: 40))
            }
            VStack(spacing: 4) {
                // MARK: title subject
                Text(subject.shortcut)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                    .underline()
            }
        }
    }
}
