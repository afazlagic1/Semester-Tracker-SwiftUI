//
//  Extensions.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
    static let icon = Color("Icon")
    static let color = Color("Color")
}

extension DateFormatter {
    static let allNumericFormat: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM/yyyy"
        return formater
    }()
}
extension String {
    func dateParsed() -> Date {
        guard let dateP = DateFormatter.allNumericFormat.date(from: self) else { return Date() }
        return dateP
    }
}
