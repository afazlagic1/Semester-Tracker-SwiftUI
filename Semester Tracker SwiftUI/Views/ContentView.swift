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
                    predicates: [.whereField("type", isEqualTo: "semester")],
                    decodingFailureStrategy: .raise
    ) private var semesters: [Event]

    var body: some View {
        NavigationStack {
            // takes size of biggest child bydefault
            VStack(alignment: .center) {
                SemesterPickerView()
                SubjectsTableView()
                Spacer()
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
//            .searchable(text: $searchSubject)
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    ToolbarView()
                }
            }.task {
                SemesterSwitchedTask()

            }

            NavigationLinkView()
        }
    }

    func SemesterPickerView() -> some View {
        VStack {
            // MARK: Semester picker
            if (semesters.isEmpty) {
                Text("🎓 No semesters available").font(
                    .system(size: 20)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Text("Contact your school administrator for more information.")
            } else {
                Picker(selection: $selectedSemester, label: Text("Semester")) {
                    let semesters = semesters.sorted(by: { $0.start < $1.start })

                    ForEach(semesters) { semester in
                        Text("🎓 \(semester.name)").tag(semester as Event?)
                    }
                }.pickerStyle(MenuPickerStyle())
            }
        }
    }

    func SubjectsTableView() -> some View {
        VStack {
            //MARK: Scrollable table of subjects
            if let semester = selectedSemester {
                SubjectsTable(semester: semester)
            }
        }
    }
    
    func NavigationLinkView() -> some View {
        NavigationLink {
            AddEventView()
        } label: {
            Text("🗓️ Add Event").bold()
        }.buttonStyle(.borderedProminent).disabled(semesters.isEmpty)
    }
    
    func ToolbarView() -> some View {
        //MARK: NotificationItem in the right
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "gearshape").fontWeight(.bold)
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.icon, .primary)
        }
    }
    
    func SemesterSwitchedTask() {
        if ($semesters.error != nil) {
            print($semesters.error!.localizedDescription);
            return;
        }

        if (semesters.count > 0) {
            selectedSemester = semesters[0]
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
