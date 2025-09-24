//
//  GoogleCalendarManager.swift
//  lina
//
//  Created by Veena Mandhan on 24/09/25.
//


import Foundation
import GoogleSignIn
import GoogleAPIClientForREST_Calendar

class GoogleCalendarManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var events: [CalendarEvent] = []
    @Published var groupedEvents: [DayEvents] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let calendarService = GTLRCalendarService()
    
    init() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            isSignedIn = true
            configureCalendarService(user: user)
        }
    }
    
    func signIn() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Sign-in failed: \(error.localizedDescription)"
                    return
                }
                
                guard let user = result?.user else {
                    self?.errorMessage = "Failed to get user information"
                    return
                }
                
                self?.isSignedIn = true
                self?.configureCalendarService(user: user)
                self?.fetchEvents()
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
        events = []
        groupedEvents = []
        calendarService.authorizer = nil
    }
    
    private func configureCalendarService(user: GIDGoogleUser) {
        calendarService.authorizer = user.fetcherAuthorizer
    }
    
    func fetchEvents() {
        guard isSignedIn else { return }
        
        isLoading = true
        errorMessage = nil
        
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 100
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        
        calendarService.executeQuery(query) { [weak self] ticket, result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Failed to fetch events: \(error.localizedDescription)"
                    return
                }
                
                guard let eventList = result as? GTLRCalendar_Events,
                      let items = eventList.items else {
                    self?.errorMessage = "No events found"
                    return
                }
                
                // Convert to CalendarEvent and group by date
                self?.events = items.map { CalendarEvent(from: $0) }
                self?.groupedEvents = EventGroupManager.groupEventsByDate(self?.events ?? [])
            }
        }
    }
}
