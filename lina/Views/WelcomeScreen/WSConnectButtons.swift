//
//  WSConnectButtons.swift
//  DayBrief
//
//  Created by Veena Mandhan on 24/09/25.
//

import SwiftUI

struct WSConnectButtonsView: View {
    @StateObject private var googleCalendarManager = GoogleCalendarManager()
    @State private var showingGoogleEvents = false
    
    var body: some View {
        VStack(spacing: 16) {
            CalendarConnectionButton(
                title: googleCalendarManager.isSignedIn ? "View Google Calendar Events" : K.connectGoogleCalendar,
                iconName: "globe",
                color: .green
            ) {
                if googleCalendarManager.isSignedIn {
                    showingGoogleEvents = true
                } else {
                    googleCalendarManager.signIn()
                }
            }
            
            CalendarConnectionButton(
                title: K.connectOutlookCalendar,
                iconName: "envelope",
                color: .blue
            ) {
                print("Connect Outlook Calendar tapped")
            }
            
            CalendarConnectionButton(
                title: K.connectAppleCalendar,
                iconName: "applelogo",
                color: .black
            ) {
                print("Connect Apple Calendar tapped")
            }
            
            // Show loading state
            if googleCalendarManager.isLoading {
                ProgressView("Loading...")
                    .padding()
            }
            
            // Show error message
            if let errorMessage = googleCalendarManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding(.horizontal, 30)
        .sheet(isPresented: $showingGoogleEvents) {
            GoogleEventsView(manager: googleCalendarManager)
        }
    }
}

struct CalendarConnectionButton: View {
    let title: String
    let iconName: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray.withAlphaComponent(0.2)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray.withAlphaComponent(0.2)), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
