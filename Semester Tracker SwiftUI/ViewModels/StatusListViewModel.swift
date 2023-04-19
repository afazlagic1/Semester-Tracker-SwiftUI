//
//  StatusListViewModel.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 25. 3. 2023..
//

import Foundation
import FirebaseFirestore

//turns every object into publisher and will notify when the state changes so the view can change
final class StatusListViewModel: ObservableObject {
//    Publisher sends to subscribers whenever the state changes of @Published objects, so the subscribers can change the view
//    @Published var statusList = [Status]()

//    func fetchData() {
//         fetchStatusesFromJson()
//        // fetchStatusesFromFirebase()
//        // populateFirebase()
//        //TODO: sort - by date asc
//    }
//
//    private func fetchStatusesFromJson() {
//        func loadJson(filename fileName: String) -> [Status]? {
//            if let url = Bundle.main.url(forResource: "statuses", withExtension: "json") {
//                    guard let data = try? Data(contentsOf: url)
//                    else {
//                        return nil
//                    }
//
//                    let decoder = JSONDecoder()
//                    guard let statuses = try? decoder.decode([Status].self, from: data) else {
//                            return nil
//                        }
//
//                    return statuses
//            }
//            return nil
//        }
//
//        self.statusList = loadJson(filename: "statuses.json") ?? []
//    }
}
