//
//  DetailView.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 28. 4. 2023..
//

import SwiftUI

struct DetailView: View {
    var subject: Event
    var body: some View {
        NavigationStack {
            ScrollView(.vertical,  showsIndicators: false) {
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        //TITLE
                        Text("\(subject.shortcut): \(subject.name)")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.text)
                        //DESCRIPTION
                        Text(subject.description)
                            .font(.headline)
//                        multilineTextAlignment(.leading )
                    }
//                    .padding(.horizontal, 20)
//                    .frame(maxWidth: 640, alignment: .center)
                }
            }
        }
        .background(Color.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(subject: eventPreviewData)
    }
}
