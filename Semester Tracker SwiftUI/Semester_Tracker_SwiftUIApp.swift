//
//  Semester_Tracker_SwiftUIApp.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import Introspect

@main
struct Semester_Tracker_SwiftUIApp: App {
    //this object follows the lifecycle of an app
    @StateObject var statusListViewModel = StatusListViewModel()
    @StateObject var subjectListViewModel = SubjectListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
            //object available to others
                .environmentObject(statusListViewModel)
                .environmentObject(subjectListViewModel)
        }
    }
}

