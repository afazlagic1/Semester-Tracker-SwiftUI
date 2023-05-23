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
    @State private var initialLoad: Bool = true

    @FirestoreQuery(collectionPath: "events",
                    predicates: [.whereField("type", isEqualTo: "semester")],
                    decodingFailureStrategy: .raise
    ) private var semesters: [Event]

    @FirestoreQuery(collectionPath: "events", predicates: [
        .whereField("type", isEqualTo: "subject")
    ], decodingFailureStrategy: .raise) private var subjects: [Event]

    @FirestoreQuery(collectionPath: "events", predicates: [
            .whereField("type", isNotIn: ["subject", "semester"])
    ], decodingFailureStrategy: .raise) private var events: [Event]

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

    private func changeSemesterPredicates() {
        if let semester = selectedSemester {
            if let id = semester.id {
                let parentRef = "/events/\(id)"
                let parent = parentRef

                NSLog("Changed semester filtering to '\(semester.name)' parentRef=\(parentRef) type=subject")

                if ($subjects.error != nil) {
                    NSLog($subjects.error!.localizedDescription)
                    NSLog($subjects.error.debugDescription)
                    return
                }

                $subjects.predicates = [
                    .whereField("type", isEqualTo: "subject"),
                    .whereField("parent", isEqualTo: parent)
                ]
            }
        }

    }

    private func changeSubjectPredicates() {
        var parentSubjects = [String]()
        for subject in subjects {
            if let id = subject.id {
                parentSubjects.append("/events/\(id)")
            }
        }

        NSLog("Changed event filtering to subjects '\(subjects.map { $0.shortcut })'")

        if !parentSubjects.isEmpty {
            $events.predicates = [
                .whereField("parentSubject", isIn: parentSubjects)
            ]
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
                SubjectsTable(semester: semester, subjects: subjects, events: events)
                .onChange(of: semester.id) { _ in
                    changeSemesterPredicates()
                }.onChange(of: subjects) { _ in
                    changeSubjectPredicates()
                }.task(id: semester.id) {
                    changeSemesterPredicates()
                }
            }
        }
    }
    
    @ViewBuilder
    func NavigationLinkView() -> some View {
        NavigationLink {
            AddEventView(subjects: subjects)
        } label: {
            Text("🗓️ Add Event").bold()
        }.buttonStyle(.borderedProminent).disabled(semesters.isEmpty || subjects.isEmpty)
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
