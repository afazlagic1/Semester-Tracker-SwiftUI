//
//  HelpView.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 05.05.2023.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationStack {
            VStack() {
                Text("Help").font(.title)
                Image("help")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }.navigationBarTitleDisplayMode(.inline)
    }
}
