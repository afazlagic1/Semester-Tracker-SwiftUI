//
//  PointsPicker.swift
//  Semester Tracker SwiftUI
//
//  Created by David Cerny on 26.05.2023.
//

import SwiftUI

struct PointsPicker: View {
    var event: Event
    var min: Int
    var max: Int
    var setPoints: (Int) -> Void
    @State var selectedPoints: Int

    var body: some View {
        VStack {
            Picker("Points picker", selection: $selectedPoints) {
                ForEach(min...max, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .pickerStyle(.wheel)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .shadow(radius: 5)
            .frame(height: 120)
            .onChange(of: selectedPoints) { newValue in
                setPoints(selectedPoints)
            }
        }
    }
}
