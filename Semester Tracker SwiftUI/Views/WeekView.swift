//
//  WeekView.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 05.05.2023.
//

import Foundation
import SwiftUI

struct WeekView: View {
    var week: Week

    var body: some View {
        Text("Week \(week.week_i)")
    }
}
