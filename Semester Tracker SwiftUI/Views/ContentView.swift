//
//  ContentView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//
import SwiftUI
import FirebaseFirestoreSwift

struct ContentView: View {
    @State private var searchSubject = ""
    @State private var selectedSemester: Event?

    @FirestoreQuery(collectionPath: "events", predicates: [
        .whereField("type", isEqualTo: "semester")]
    ) private var semesters: [Event]

    var body: some View {
        NavigationStack {
            ScrollView {
                //takes size of biggest child bydefault
                VStack(alignment: .leading, spacing: 24) {
                    Picker(selection: $selectedSemester, label: Text("Semester")) {
                        let semesters = semesters.sorted(by: { $0.start < $1.start })
                        
                        ForEach(semesters) { semester in
                            Text(semester.name).tag(semester as Event?)
                        }
                    }
                    //MARK: Filter bars by lecture & by attendence
//                    FilterBar()
                    //MARK: Scrollable table of subjects
                    if let semester = selectedSemester {
                        SubjectsTable(semester: semester)
                    }
                }.padding()
                    .frame(maxWidth: .infinity).task {
                        selectedSemester = semesters[0]
                    }
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(SubjectListViewModel())
//            .environmentObject(StatusListViewModel())
//    }
//}
