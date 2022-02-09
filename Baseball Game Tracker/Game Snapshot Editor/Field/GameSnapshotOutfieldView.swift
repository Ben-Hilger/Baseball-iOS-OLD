// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotOutfieldView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    var body: some View {
        GeometryReader { geometry in
            GameSnapshotFielderView(position: .LeftField, widthAdjustment: 0.2, heightAdjustment: 0.3)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .CenterField, widthAdjustment: 0.5, heightAdjustment: 0.1)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .RightField, widthAdjustment: 0.8, heightAdjustment: 0.3)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
        }
    }
}
