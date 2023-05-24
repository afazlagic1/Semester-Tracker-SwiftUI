//
//  AddEventView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 10. 5. 2023..
//

import SwiftUI
import FirebaseFirestoreSwift

struct AddEventView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAlert = false
    @State private var showingConfirmation = false
    @State private var selectedSubject: Event?
    @State private var startD = GetDefaultDate()
    @State private var endD = GetDefaultDate()
    @State private var attendance = "presence"
    @State private var eventType: EventType = .lecture
    @State private var eventShortcut: String = ""
    @State private var eventName: String = ""
    @State private var eventDesc: String = ""
    @State private var navigateToNewView = false
    private var allOptions = ["presence", "absence", "distraction"]
    var subjects: [Event]
    
    init(subjects: [Event]) {
        self.subjects = subjects
    }

    static func GetDefaultDate() -> Date {
        let date = Date.now
        var components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second], from: date
        )

        components.hour = 12
        components.minute = 0
        components.second = 0

        if let finalDate = Calendar.current.date(from: components) {
            return finalDate
        } else {
            return date
        }
    }

    private func Submit() {
        self.showingAlert = true

        if let selectedSubject = selectedSubject {
            let docRef = "/events/\(selectedSubject.id)"
            let optionsField = OptionsField(default_val: "presence")
            let field2 = Field.optionsField(optionsField)
            let attributes: [String: Field] = ["field": field2]
           let newEvent = Event(
               shortcut: eventShortcut, name: eventName,
               description: eventDesc, type: eventType.rawValue, start: startD,
               end: endD, attributes: attributes, parent: docRef, parentSubject: docRef
           )
           dataManager.addEvent(event: newEvent)
        }

        ResetForm()
    }

    private func ResetForm() {
        eventName = ""
        eventShortcut = ""
        eventDesc = ""
        startD = AddEventView.GetDefaultDate()
        endD = AddEventView.GetDefaultDate()
        attendance = "presence"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Subject details")) {
                    SubjectPickerView()

                    Picker(selection: $eventType, label: Text("Type")) {
                        ForEach(EventType.allCases, id: \.self) { option in
                            let optionDescription = String(describing: option)

                            if (optionDescription != "semester" && optionDescription != "subject") {
                                Text(optionDescription.capitalized)
                            }
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }

                Section(header: Text("Event details")) {
                    TextField("Name", text: $eventName)
                    TextField("Shortcut", text: $eventShortcut)
                    Picker(selection: $attendance, label: Text("Attendance")) {
                        ForEach(self.allOptions, id: \.self) { option in
                            Text(option.capitalized)
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }

                Section(header: Text("Time details")) {
                    // TODO: not sure if this is working
                    if let selectedSubject = selectedSubject {
                        //MARK: start date picker
                        DatePicker(selection: $startD, in: selectedSubject.start...) {
                            Text("Start date")
                        }
                        //MARK: end date picker
                        DatePicker(selection: $endD, in: startD...selectedSubject.end) {
                            Text("End date")
                        }
                    }
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $eventDesc).frame(height: 100)
                }

                Section {
                    //TODO: disable button if required fields are not filled
                    Button {
                        //TODO: only call this after the alert is confirmed
                        Submit()
                    } label: {
                        HStack {
                            Spacer()
                            Text("🗓️ Add event").bold()
                            Spacer()
                        }
                    }.alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Alert"),
                            message: Text("Are you sure you want to add this event?"),
                            primaryButton: .default(Text("OK"),
                            action: { navigateToNewView = true }),
                            secondaryButton: .cancel()
                        )
                    }
                }
            }.navigationTitle(Text("🗓️ New event"))
        }.frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func SubjectPickerView() -> some View {
        Picker(selection: $selectedSubject, label: Text("Subject")) {
            ForEach(subjects, id: \.self) { subject in
                Text("\(subject.shortcut) - \(subject.name)")
                    .tag(subject as Event?)
            }
        }.pickerStyle(DefaultPickerStyle()).task {
            if (!subjects.isEmpty) {
                selectedSubject = subjects[0]
            }
        }
    }
}
