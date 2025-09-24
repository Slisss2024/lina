//
//  EventGroupManager.swift
//  lina
//
//  Created by Veena Mandhan on 25/09/25.
//


import Foundation

class EventGroupManager {
    static func groupEventsByDate(_ events: [CalendarEvent]) -> [DayEvents] {
        let calendar = Calendar.current
        
        // Group events by day
        let grouped = Dictionary(grouping: events) { event in
            calendar.startOfDay(for: event.startDate)
        }
        
        // Convert to DayEvents and sort by date
        let dayEvents = grouped.map { (date, events) in
            DayEvents(date: date, events: events.sorted { $0.startDate < $1.startDate })
        }
        
        return dayEvents.sorted { $0.date < $1.date }
    }
}