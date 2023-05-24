//
//  FilterBar.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 4. 4. 2023..
//

import SwiftUI

struct FilterBar: View {
    @Binding var selection: String
    var items: [String]
    
    var body: some View {
        VStack {
            Picker("Pick event type.", selection: $selection) {
                ForEach(items, id: \.self) {
                    Text($0.capitalized)
                }
            }.pickerStyle(.segmented)
        }
    }
}
