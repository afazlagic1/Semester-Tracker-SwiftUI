//
//  Extensions.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import Foundation
import SwiftUI

let frameCornerRadius: CGFloat = 20
let shadowRadius: CGFloat = 8
let clickableGradient = LinearGradient(colors: [.background, .teal], startPoint: .leading, endPoint: .trailing)
let backgroundGradient = LinearGradient(colors: [.white, .background], startPoint: .bottom, endPoint: .top)

extension Color {
    static let background = Color("Background")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
    static let icon = Color("Icon")
    static let color = Color("Color")
}
