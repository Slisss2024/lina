//
//  GoogleEventsView.swift
//  lina
//
//  Created by Veena Mandhan on 24/09/25.
//


import SwiftUI

struct GoogleEventsView: View {
    @ObservedObject var manager: GoogleCalendarManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.groupedEvents, id: \.date) { dayEvents in
                    Section(header: DaySectionHeader(dayEvents: dayEvents)) {
                        ForEach(dayEvents.events, id: \.id) { event in
                            EventRow(event: event)
                        }
                    }
                }
            }
            .navigationTitle("Google Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        manager.signOut()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .refreshable {
                manager.fetchEvents()
            }
        }
    }
}

struct DaySectionHeader: View {
    let dayEvents: DayEvents
    
    var body: some View {
        HStack {
            Text(dayEvents.displayTitle)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("\(dayEvents.events.count) event\(dayEvents.events.count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct EventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.title)
                .font(.headline)
            
            HStack {
                Text(timeText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if event.isAllDay {
                    Text("All day")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
            }
            
            if let description = event.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 2)
    }
    
    private var timeText: String {
        if event.isAllDay {
            return "All day"
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let startTime = formatter.string(from: event.startDate)
        
        if let endDate = event.endDate {
            let endTime = formatter.string(from: endDate)
            return "\(startTime) - \(endTime)"
        }
        
        return startTime
    }
}
