// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotPositionView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    var body: some View {
        GeometryReader { geometry in
            GameSnapshotInfieldFielderView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .Pitcher, widthAdjustment: 0.5, heightAdjustment: 0.67)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .Catcher, widthAdjustment: 0.5, heightAdjustment: 0.95)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotOutfieldView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
                
        }
    }
}
