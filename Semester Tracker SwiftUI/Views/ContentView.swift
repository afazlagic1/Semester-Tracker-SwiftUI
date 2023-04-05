//
//  ContentView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//
import SwiftUI

struct ContentView: View {
    @State private var searchSubject = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                //takes size of biggest child bydefault
                VStack(alignment: .leading, spacing: 24) {
                    //MARK: Filter bars by lecture & by attendence
                    FilterBar()
                    //MARK: Scrollable table of subjects
                    SubjectsTable()
                }
                .padding()
                .frame(maxWidth: .infinity)
                //to make ScrollView scrollable
                //TODO: login/sign up page
            }
            .searchable(text: $searchSubject)
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //MARK: NotificationItem in the right
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SubjectListViewModel())
            .environmentObject(StatusListViewModel())
    }
}
