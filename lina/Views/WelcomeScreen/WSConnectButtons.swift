//
//  WSConnectButtons.swift
//  DayBrief
//
//  Created by Veena Mandhan on 24/09/25.
//

import SwiftUI

struct WSConnectButtonsView: View {
    var body: some View {
        VStack(spacing: 16) {
            CalendarConnectionButton(
                title: K.connectGoogleCalendar,
                iconName: "globe",
                color: .green
            ) {
                print("Connect Google Calendar tapped")
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
        }
        .padding(.horizontal, 30)
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
