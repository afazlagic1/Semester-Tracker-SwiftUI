//
//  ModelEntity.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 14.04.2023.
//

import Foundation

public protocol ModelEntity {
    func dictionary() -> [String: Any];
}
