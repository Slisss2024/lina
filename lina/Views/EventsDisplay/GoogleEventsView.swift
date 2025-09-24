//
//  GoogleEventsView.swift
//  lina
//
//  Created by Veena Mandhan on 24/09/25.
//


import SwiftUI
import GoogleAPIClientForREST_Calendar

struct GoogleEventsView: View {
    @ObservedObject var manager: GoogleCalendarManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(manager.events, id: \.identifier) { event in
                EventRow(event: event)
            }
            .navigationTitle("Google Calendar Events")
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

struct EventRow: View {
    let event: GTLRCalendar_Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.summary ?? "No Title")
                .font(.headline)
            
            if let start = event.start?.dateTime?.date ?? event.start?.date?.date {
                Text(DateFormatter.eventFormatter.string(from: start))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let description = event.descriptionProperty, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 2)
    }
}

extension DateFormatter {
    static let eventFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}