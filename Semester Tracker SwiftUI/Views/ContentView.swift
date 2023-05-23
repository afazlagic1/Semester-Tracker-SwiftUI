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

    @FirestoreQuery(collectionPath: "events",
                    predicates: [.whereField("type", isEqualTo: "semester")], decodingFailureStrategy: .raise
    ) private var semesters: [Event]

    var body: some View {
        NavigationStack {
            //takes size of biggest child bydefault
            VStack(alignment: .center) {
                Picker(selection: $selectedSemester, label: Text("Semester")) {
                    let semesters = semesters.sorted(by: { $0.start < $1.start })

                    ForEach(semesters) { semester in
                        Text("🎓 \(semester.name)").tag(semester as Event?)
                    }
                }.pickerStyle(MenuPickerStyle())

                //MARK: Scrollable table of subjects
                if let semester = selectedSemester {
                    SubjectsTable(semester: semester)
                }
                Spacer()
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).task {
                if ($semesters.error != nil) {
                    print($semesters.error!.localizedDescription);
                    return;
                }

                if (semesters.count > 0) {
                    selectedSemester = semesters[0]
                }
            }.background(Color.background)
//            .searchable(text: $searchSubject)
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //MARK: NotificationItem in the right
                ToolbarItem {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape").fontWeight(.bold)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                    }
                }
            }
            NavigationLink {
                AddEventView()
            } label: {
                Text("🗓️ Add Event")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SubjectListViewModel())
            .environmentObject(StatusListViewModel())
            .environmentObject(DataManager())
    }
}
