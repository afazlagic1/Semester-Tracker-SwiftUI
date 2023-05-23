//
//  ProgressDisplay.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 23.05.2023.
//

import SwiftUI

struct ProgressDisplay: View {
    var progress: Double
    var maxValue: Double = 0.0
    
    private var formattedProgress: String {
        get {
            return String(format: "%.0f", progress.rounded(.toNearestOrAwayFromZero))
        }
    }
    
    private var progressColor: Color {
        switch (progress / maxValue) * 100 {
        case 0...25:
            return Color.red
        case 26...75:
            return Color.orange
        case 76...100:
            return Color.green
        default:
            return Color.red
        }
    }

    var body: some View {
        Text("\(formattedProgress)%").bold().foregroundColor(progressColor)
    }
}
