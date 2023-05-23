//
//  Semester_Tracker_SwiftUIApp.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//

import SwiftUI
import Introspect
import Firebase

@main
struct Semester_Tracker_SwiftUIApp: App {
    @StateObject var dataManager = DataManager()
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataManager)
        }
    }
}
