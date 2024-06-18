//
//  DashboardView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//


import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView()
            ScrollView {
                VStack(spacing: 16) {
                    PetInfoView()
                    ActivityHistoryView()
                    SettingsView()
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
    }
}

#Preview {
    DashboardView()
}
