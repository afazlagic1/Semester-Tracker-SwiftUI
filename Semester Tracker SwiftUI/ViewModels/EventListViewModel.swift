//
//  EventListViewModel.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 27. 4. 2023..
//

import Combine

final class EventListViewModel: ObservableObject {
    @Published var eventRepository = EventRepository()
    @Published var events : [Event] = []
    
    private var cancellables : Set<AnyCancellable> = []
    
    init() {
        //with $ we access the events that are published by a publisher, not a list of events
        eventRepository.$events
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
    }
    
    func add(event: Event) {
        eventRepository.add(event)
    }
}
