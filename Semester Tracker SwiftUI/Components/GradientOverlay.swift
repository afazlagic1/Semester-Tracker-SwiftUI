//
//  GradientOverlay.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 02.06.2023.
//

import SwiftUI

struct GradientOverlay: View {
    var body: some View {
        HStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.white.opacity(0.0)]),
                startPoint: .center, endPoint: .trailing).frame(width: 10)
            Spacer()
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.0), Color.white]),
                startPoint: .center, endPoint: .trailing).frame(width: 50)
        }
    }
}
