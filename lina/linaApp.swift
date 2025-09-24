//
//  linaApp.swift
//  lina
//
//  Created by Veena Mandhan on 24/09/25.
//

import SwiftUI
import GoogleSignIn

@main
struct linaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
    
    init() {
        configureGoogleSignIn()
    }
    
    func configureGoogleSignIn() {
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let clientId = plist["CLIENT_ID"] as? String {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        }
    }
}
