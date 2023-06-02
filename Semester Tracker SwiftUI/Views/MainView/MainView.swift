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
    @EnvironmentObject private var dataManager: DataManager

    // MARK: semesters
    @FirestoreQuery(collectionPath: "events",
                    predicates: [.whereField("type", isEqualTo: "semester")],
                    decodingFailureStrategy: .raise
    ) private var semesters: [Event]

    // MARK: subjects in selected semester
    @FirestoreQuery(collectionPath: "events", predicates: [
        .where("invalidField", isLessThan: "")
    ], decodingFailureStrategy: .raise) private var subjects: [Event]

    // MARK: events in selected subjects
    @FirestoreQuery(collectionPath: "events", predicates: [
            .where("invalidField", isLessThan: "")
    ], decodingFailureStrategy: .raise) private var events: [Event]

    // MARK: event statuses
    @FirestoreQuery(collectionPath: "event_status", predicates: [
        .where("invalidField", isLessThan: "")
    ], decodingFailureStrategy: .raise) private var eventStatus: [EventStatus]

    private var parentSubjects: [String] {
        get {
            var parentSubjects = [String]()
            for subject in subjects {
                if let id = subject.id {
                    parentSubjects.append("/events/\(id)")
                }
            }
            return parentSubjects
        }
    }

    var body: some View {
        NavigationStack {
            // takes size of biggest child bydefault
            VStack(alignment: .center) {
                SemesterPickerView()
                SubjectsTableView().environmentObject(dataManager)
                Spacer()
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            .toolbar {
                ToolbarItem {
                    ToolbarView()
                }
            }.onChange(of: semesters) { _ in
                SemesterSwitchedTask()
                initialLoad = false
            }
            HStack {
                NavigationLinkView()
            }.padding(.vertical, 1)
        }

//       #if DEBUG
//       ScrollView {
//           Text("Semesters \(semesters.count)")
//           Text("Subjects \(subjects.count)")
//           Text("Subject events \(events.count)")
//           if let error = $events.error {
//               Text("Subject event error: \(error.localizedDescription)").foregroundColor(.red)
//           }
//           Text("Event status \(eventStatus.count)")
//           if let error = $eventStatus.error {
//               Text("Event status error: \(error.localizedDescription)").foregroundColor(.red)
//           }
//       }.border(Color.black, width: 1).frame(height: 200)
//       #endif
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
        NSLog("Changed event filtering to subjects '\(parentSubjects)'")

        if (!parentSubjects.isEmpty) {
            $events.predicates = [
                .whereField("parentSubject", isIn: parentSubjects)
            ]
        }
    }

    private func changeEventStatusPredicates() {
        NSLog("Changed event status filtering to subjects '\(parentSubjects)'")

        if (!parentSubjects.isEmpty) {
            $eventStatus.predicates = [
                .whereField("parentSubject", isIn: parentSubjects)
            ]
        }
    }

    @ViewBuilder
    private func SemesterPickerView() -> some View {
        VStack {
            if (semesters.isEmpty) {
                Text("🎓 No semesters available").font(
                    .system(size: 20)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Text("Contact your school administrator for more information.")
            } else {
                Picker(selection: $selectedSemester, label: Text("Semester")) {
                    ForEach(semesters.sorted(by: { $0.start < $1.start })) { semester in
                        let currentTime = Date.now
                        let isCurrentSemester = semester.start <= currentTime && currentTime <= semester.end
                        Text("🎓 \(semester.name)\(isCurrentSemester ? " (current)" : "")").tag(semester as Event?)
                    }
                }.pickerStyle(.menu).labelsHidden()
            }
        }
    }

    @ViewBuilder
    private func SubjectsTableView() -> some View {
        VStack {
            //MARK: Scrollable table of subjects
            if let semester = selectedSemester {
                SubjectsTable(semester: semester, subjects: subjects,
                              events: events, eventStatus: eventStatus)
                .onChange(of: semester.id) { _ in
                    changeSemesterPredicates()
                }.onChange(of: subjects) { _ in
                    changeSubjectPredicates()
                    changeEventStatusPredicates()
                }.task(id: semester.id) {
                    changeSemesterPredicates()
                }
            }
        }
    }

    @ViewBuilder
    func NavigationLinkView() -> some View {
        NavigationLink {
            if let selectedSemester = selectedSemester {
                AddEventView(semester: selectedSemester, subjects: subjects)
            }
        } label: {
            Text("🗓️ Add event").bold().padding(.all, 1).shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
        }.buttonStyle(.borderedProminent).disabled(semesters.isEmpty || subjects.isEmpty)
    }

    @ViewBuilder
    private func ToolbarView() -> some View {
        //MARK: NotificationItem in the right
        NavigationLink(destination: HelpView()) {
            Image(systemName: "questionmark.circle.fill")
            .fontWeight(.bold)
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.icon, .primary.opacity(0.5))
            .background(Color.background)
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
