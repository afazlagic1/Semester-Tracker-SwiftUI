//
//  ContentView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 24. 3. 2023..
//
import SwiftUI
import FirebaseFirestoreSwift

struct MainView: View {
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

    @ViewBuilder
    private func SemesterPickerView() -> some View {
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

    @ViewBuilder
    private func SubjectsTableView() -> some View {
        VStack {
            //MARK: Scrollable table of subjects
            if let semester = selectedSemester {
                SubjectsTable(semester: semester)
            }
        }
    }
    
    @ViewBuilder
    func NavigationLinkView() -> some View {
        NavigationLink {
            AddEventView()
        } label: {
            Text("🗓️ Add Event").bold()
        }.buttonStyle(.borderedProminent).disabled(semesters.isEmpty)
    }

    @ViewBuilder
    private func ToolbarView() -> some View {
        //MARK: NotificationItem in the right
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "gearshape").fontWeight(.bold)
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.icon, .primary)
        }
    }

    private func SemesterSwitchedTask() {
        if ($semesters.error != nil) {
            print($semesters.error!.localizedDescription);
            return;
        }

        if (semesters.count > 0) {
            selectedSemester = semesters[0]
        }
    }
}
