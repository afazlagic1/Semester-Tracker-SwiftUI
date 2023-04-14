//
//  SubjectListViewModel.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 3. 2023..
//

import Foundation

final class SubjectListViewModel: ObservableObject {
    @Published var subjectList: [Subject] = []
    @Published var searchSubject: String = ""

    init() {
         getSubjects()
    }
    
    func getSubjects() {
        func loadJSON() -> [Subject]? {
            if let url = Bundle.main.url(forResource: "subjects", withExtension: "json") {
                guard let data = try? Data(contentsOf: url) else {
                    return nil
                }
                let decoder = JSONDecoder()
                guard let subjects = try? decoder.decode([Subject].self, from: data) else {
                    return nil
                }
                return subjects
            }
            return nil
        }
        self.subjectList = loadJSON() ?? []
        
        $searchSubject
            .sink { (returnedText) in
                self.subjectList
            }
    }
}
