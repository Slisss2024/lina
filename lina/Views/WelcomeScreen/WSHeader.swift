//
//  WSHeader.swift
//  DayBrief
//
//  Created by Veena Mandhan on 24/09/25.
//

import SwiftUI

struct WSHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(K.appName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(K.wsTitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding(.top, 50)
    }
}
