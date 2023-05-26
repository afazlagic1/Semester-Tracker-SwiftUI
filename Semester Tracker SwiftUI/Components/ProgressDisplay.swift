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
            var finalProgress = progress
            if (finalProgress > maxValue) {
                NSLog("Progress \(finalProgress) overflowed max value of \(maxValue)")
                finalProgress = maxValue
            }
            
            var finalProgressRounded = finalProgress.rounded(.toNearestOrAwayFromZero)
            if (finalProgressRounded.isNaN) {
                finalProgressRounded = 0
            }
            return String(format: "%.0f", finalProgressRounded)
        }
    }
    
    private var progressColor: Color {
        switch (progress / maxValue) * 100 {
        case ...25:
            return Color.red
        case 25...75:
            return Color.orange
        case 75...:
            return Color.green
        default:
            return Color.red
        }
    }

    var body: some View {
        Text("\(formattedProgress)%").bold().foregroundColor(progressColor)
    }
}
