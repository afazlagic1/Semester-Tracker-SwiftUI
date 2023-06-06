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
                Text("Basic usage").font(.largeTitle)
                Image("help")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(frameCornerRadius)
                    .frame(maxWidth: .infinity)
                    .shadow(radius: shadowRadius).padding()
                    
                Spacer()
            }.background(backgroundGradient)
        }.navigationBarTitleDisplayMode(.inline).navigationTitle("Help")
    }
}
