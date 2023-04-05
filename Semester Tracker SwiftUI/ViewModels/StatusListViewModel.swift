//
//  StatusListViewModel.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 25. 3. 2023..
//

import Foundation
//turns every object into publisher and will notify when the state changes so the view can change
final class StatusListViewModel: ObservableObject {
    //Publisher sends to subscribers whenever the state changes of @Published objects, so the subscribers can change the view
    @Published var statusList: [Status] = []
    
    init() {
        //self.statusList = statusListPreviewData
        getAllStatuses()
    }
    
    func getAllStatuses() {
        //TODO: change to use Firebase database
        //TODO: filter - student with id = ...
        //TODO: sort - by date asc
        func loadJson(filename fileName: String) -> [Status]? {
            if let url = Bundle.main.url(forResource: "statuses", withExtension: "json") {
                    guard let data = try? Data(contentsOf: url)
                    else {
                        return nil
                    }
                    let decoder = JSONDecoder()
                    guard let statuses = try? decoder.decode([Status].self, from: data) else {
                            return nil
                        }
                        statusList = statuses
                    return statusList
            }
            return nil
        }
        
        self.statusList = loadJson(filename: "statuses.json") ?? []
    }
}
