//
//  SettingsView.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 05.05.2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Settings").font(.title)
                Text("TODO: add settings for week numbering (relative/absolute)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }.navigationBarTitleDisplayMode(.inline)
    }
}
