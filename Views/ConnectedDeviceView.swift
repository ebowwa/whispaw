//
//  ConnectedDeviceView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct ConnectedDeviceView: View {
    var body: some View {
        ZStack {
            BackgroundGradientView()
            VStack {
                DeviceCardView()
            }
        }
    }
}

struct ConnectedDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedDeviceView()
    }
}
