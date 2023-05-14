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
    @State private var startD = Date.now
    @State private var endD = Date.now
    @State private var attendance = "presence"
    @State private var eventType: EventType = .lecture
    @State private var eventShortcut: String = ""
    @State private var eventName: String = ""
    @State private var eventDesc: String = ""
    @State private var navigateToNewView = false
    private var allOptions = ["presence", "absence", "distraction"]
    
    var body: some View {
        //background
//        ZStack {
//            Color.background.edgesIgnoringSafeArea(.all)
//        }
        //foreground
        NavigationStack {
            VStack(alignment: .center) {
                //MARK: subject picker
                HStack {
                    Text("Subject:")
                    Spacer()
                    Picker(selection: $selectedSubject, label: Text("Subject")) {
                        ForEach(dataManager.subjects, id: \.self) { subject in
                            Text(subject.name )
                                .tag(subject as Event?)
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }.task {
                    selectedSubject = dataManager.subjects[0]
                }
                //MARK: start date picker
                HStack {
                    DatePicker(selection: $startD, in: ...Date.now, displayedComponents: .date) {
                        Text("Start date: ")
                    }
                }
                //MARK: end date picker
                HStack {
                    DatePicker(selection: $endD, in: startD...Date.now, displayedComponents: .date) {
                        Text("End date: ")
                    }
                }
                //MARK: event type picker
                HStack {
                    Text("Event:")
                    Spacer()
                    Picker("Selection", selection: $eventType) {
                        ForEach(EventType.allCases, id: \.self) {
                            option in
                            if (String(describing: option) != "semester" && String(describing: option) != "subject") {
                                Text(String(describing: option))
                            }
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }
                HStack {
                    VStack {
                        Text("Event name:")
                        Spacer().frame(height: 10)
                        Text("Event shortcut:")
                        Spacer().frame(height: 10)
                        Text("Event description:")
                    }
                    VStack {
                        //MARK: enter event name
                        TextField("Enter event name", text: $eventName)
                        //MARK: enter event shortcut
                        TextField("Enter event shortcut", text: $eventShortcut)
                        //MARK: enter description
                        TextField("Enter event description", text: $eventDesc)
                    }
                }
                //MARK: attendance picker
                HStack {
                    Text("Attendance:")
                    Spacer()
                    Picker(selection: $attendance, label: Text("Attendance")) {
                        ForEach(self.allOptions, id: \.self) {
                            option in
                            Text(option)
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }
                VStack {
                    Button {
                        self.showingAlert = true
                        print("Tuuu")
                        if let selectedSubject = selectedSubject {
                            print("Aha")
                            let docRef = dataManager.getDocumentReference(documentId: selectedSubject.id ?? "")
                            let optionsField = OptionsField(default_val: "presence", picked_val: attendance)
                            let field2 = Field.optionsField(optionsField)
                            let attributes: [String: Field] = ["field": field2]
                            let newEvent = Event(shortcut: eventShortcut, name: eventName, description: eventDesc, type: eventType.rawValue, start: startD, end: endD, attributes: attributes, parent: docRef, parentSubject: docRef)
                            dataManager.addAttendance(event: newEvent)
                        }
                    } label: { Text("Add") }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Alert"), message: Text("Are you sure you want to add this event?"), primaryButton: .default(Text("OK"), action: {
                                navigateToNewView = true
                            }), secondaryButton: .cancel())
                        }
                }
                .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(8)
                NavigationLink(destination: ContentView(), isActive: $navigateToNewView) {
                                EmptyView()
                            }
            }
        }.padding().frame(maxWidth: .infinity)
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
            .environmentObject(DataManager())
    }
}
