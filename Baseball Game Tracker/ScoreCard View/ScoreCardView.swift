// Copyright 2021-Present Benjamin Hilge

import SwiftUI

struct ScoreCardView: View {
     
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var body: some View {
        LineScoreView()
            .environmentObject(gameViewModel)
            .environmentObject(settingsViewModel)
    }
    
    func generatePitchOptions() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        
        let changePitcher = Alert.Button.default(Text("Change Pitcher")) {
        }
        
        buttons.append(changePitcher)
        return buttons
    }
    
    func generateHitterOptions() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        
        let pinchHitter = Alert.Button.default(Text("Pinch Hitter")) {
        }
        
        buttons.append(pinchHitter)
        return buttons
    }
}

enum ScoreCardType : CaseIterable {
    case PitchByPitch
    case LineScore
    
    func getString() -> String {
        switch self {
        case .LineScore:
            return "Line Score"
        case .PitchByPitch:
            return "Pitch By Pitch"
        }
    }
}
