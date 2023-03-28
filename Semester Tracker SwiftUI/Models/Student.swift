//
//  Student.swift
//  semester_tracker
//
//  Created by Anesa Fazlagić on 9. 3. 2023..
//

import Foundation

struct Student: Identifiable, Decodable, Hashable {
    private(set) var id: Int
    private(set) var name: String
    private(set) var surname: String
    private(set) var username: String
    //in future handle password properly
    private(set) var password: String
}

