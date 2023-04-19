//
//  FilterBar.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 4. 4. 2023..
//

import SwiftUI

struct FilterBar: View {
    var body: some View {
        VStack {
            SearchBar()
        }
    }
}

struct SearchBar: View {
    var body: some View {
        VStack {
//            FilterItem(name: "eventType", items: ["all", "lecture", "excercise", "description"])
//            FilterItem(name: "attendanceType", items: ["all", AttendanceType.presence.rawValue, AttendanceType.distraction.rawValue, AttendanceType.absence.rawValue])
        }
    }
}

struct FilterItem: View {
    let name: String
    @State private var selection = "all"
    let items: [String]
    var body: some View {
            Picker("Pick event type.", selection: $selection) {
                ForEach(items, id: \.self) {
                    Text($0)
                        
                }
            }.pickerStyle(.segmented)
            .background(Color.cyan.opacity(0.7))
    }
}

struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar()
    }
}
