//
//  CalendarEvent.swift
//  lina
//
//  Created by Veena Mandhan on 25/09/25.
//


import Foundation
import GoogleAPIClientForREST_Calendar

struct CalendarEvent {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date?
    let description: String?
    let isAllDay: Bool
    
    init(from googleEvent: GTLRCalendar_Event) {
        self.id = googleEvent.identifier ?? UUID().uuidString
        self.title = googleEvent.summary ?? "No Title"
        self.description = googleEvent.descriptionProperty
        
        // Handle all-day vs timed events
        if let dateTime = googleEvent.start?.dateTime?.date {
            self.startDate = dateTime
            self.isAllDay = false
        } else if let date = googleEvent.start?.date?.date {
            self.startDate = date
            self.isAllDay = true
        } else {
            self.startDate = Date()
            self.isAllDay = false
        }
        
        // Handle end date
        if let endDateTime = googleEvent.end?.dateTime?.date {
            self.endDate = endDateTime
        } else if let endDate = googleEvent.end?.date?.date {
            self.endDate = endDate
        } else {
            self.endDate = nil
        }
    }
}

struct DayEvents {
    let date: Date
    let events: [CalendarEvent]
    
    var dayTitle: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(date)
    }
    
    var displayTitle: String {
        if isToday { return "Today" }
        if isTomorrow { return "Tomorrow" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}