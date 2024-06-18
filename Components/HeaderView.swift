//
//  HeaderView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            HStack {
                Image("placeholder")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text("PetComm")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
            AvatarView()
        }
        .padding()
        .background(Color(hex: "#00b894"))
    }
}
