// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotInfieldFielderView: View {

    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel

    var body: some View {
        GeometryReader { geometry in
            GameSnapshotFielderView(position: .FirstBase, widthAdjustment: 0.75, heightAdjustment: 0.55)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .SecondBase, widthAdjustment: 0.65, heightAdjustment: 0.45)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .ShortStop, widthAdjustment: 0.35, heightAdjustment: 0.45)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
            GameSnapshotFielderView(position: .ThirdBase, widthAdjustment: 0.25, heightAdjustment: 0.55)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(gameSnapshotViewModel)
        }
    }
}

