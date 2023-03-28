//
//  ContentView.swift
//  Semester Tracker SwiftUI
//
//  Created by Edna Fazlagić on 24. 3. 2023..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            SubjectsTable()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SubjectListViewModel())
            .environmentObject(StatusListViewModel())
    }
}
