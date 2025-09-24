//
//  ContentView.swift
//  lina
//
//  Created by Veena Mandhan on 24/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                WSHeaderView()
                
                Spacer()
                
                WSConnectButtonsView()
                
                Spacer()
                
                WSFooterView()
            }
            .navigationBarHidden(true)
        }
    }
}
