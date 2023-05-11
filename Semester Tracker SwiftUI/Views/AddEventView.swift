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
    @State private var selectedSubject: Event?
    @State private var startD = Date.now
    @State private var endD = Date.now
    @State private var attendance = "presence"
    @State private var eventType: EventType = .lecture
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
                            Text(subject.name)
                                .tag(subject as Event?)
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }
                //MARK start date picker
                HStack {
                    DatePicker(selection: $startD, in: ...Date.now, displayedComponents: .date) {
                        Text("Start date: ")
                    }
                }
                //MARK end date picker
                HStack {
                    DatePicker(selection: $endD, in: startD...Date.now, displayedComponents: .date) {
                        Text("End date: ")
                    }
                }
                //MARK event type picker
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
                //MARK attendance picker
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
                //MARK button add
                NavigationLink {
                    ContentView()
                } label: {
                    Text("Add")
                }
                .buttonStyle(.borderedProminent)
                .onTapGesture {
                    //TODO attributes optionField
                    let newEvent = Event(shortcut: "lec3", name: "lecture 3", description: "lecture 3", type: "lecture", start: startD, end: endD, attributes: nil )
                    dataManager.addAttendance(event: newEvent)
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
