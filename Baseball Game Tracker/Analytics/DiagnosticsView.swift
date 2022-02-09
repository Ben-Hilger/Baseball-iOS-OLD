// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct DiagnosticsView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text("Away Team AB: \(AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: .Away, settingsViewModel: SettingsViewModel()))")
                Text("Away Team PA: \(AnalyticsCore.getTotalPA(fromGameViewModel: gameViewModel, forTeam: .Away, settingsViewModel: SettingsViewModel()))")
                Text("Away Team Walks: \(AnalyticsCore.getTotalWalks(fromGameViewModel: gameViewModel, forTeam: .Away, settingsViewModel: SettingsViewModel()))")
                Text("Away Team BIP: \(AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withPitchOutcomes: [.BIP], forTeam: .Away, settingsViewModel: SettingsViewModel()))")
                Text("Away Team GB: \(AnalyticsCore.getTotalBIPType(fromGameViewModel: gameViewModel, forTeam: .Away, settingsViewModel: SettingsViewModel(), forBIPType: .GB))")
            }
            VStack {
                Text("Home Team AB: \(AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: .Home, settingsViewModel: SettingsViewModel()))")
                Text("Home Team PA: \(AnalyticsCore.getTotalPA(fromGameViewModel: gameViewModel, forTeam: .Home, settingsViewModel: SettingsViewModel()))")
                Text("Home Team Walks: \(AnalyticsCore.getTotalWalks(fromGameViewModel: gameViewModel, forTeam: .Home, settingsViewModel: SettingsViewModel()))")
                Text("Home Team BIP: \(AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withPitchOutcomes: [.BIP], forTeam: .Home, settingsViewModel: SettingsViewModel()))")
                Text("Home Team GB: \(AnalyticsCore.getTotalBIPType(fromGameViewModel: gameViewModel, forTeam: .Home, settingsViewModel: SettingsViewModel(), forBIPType: .GB))")
            }
        }
    }
}

struct DiagnosticsView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosticsView()
    }
}
