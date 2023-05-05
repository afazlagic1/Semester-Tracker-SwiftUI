//
//  FilterBar.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 4. 4. 2023..
//

import SwiftUI

struct FilterBar: View {
    @Binding var selection: String
    
    var body: some View {
        VStack {
            VStack {
                FilterItem(
                    selection: $selection,
                    name: "eventType",
                    items: ["lecture", "exercise", "exam"]
                )
            }
        }
    }
}

struct FilterItem: View {
    @Binding var selection: String
    let name: String
    let items: [String]

    var body: some View {
            Picker("Pick event type.", selection: $selection) {
                ForEach(items, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
    }
}

//struct FilterBar_Previews: PreviewProvider {
//    @State var selection = "lecture"
//
//    static var previews: some View {
//        FilterBar(selection: $selection)
//    }
//}
