// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineScoreStatisticsView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    @State var viewSheet : Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("\(settingsViewModel.formulas.count >= 1 ? settingsViewModel.formulas[0].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamAbbr ?? "" : gameViewModel.game?.homeTeam.teamAbbr ?? "" : "") \(settingsViewModel.formulas.count >= 1 ? "\(settingsViewModel.formulas[0].getFormulaShortName()): \( settingsViewModel.formulas[0].getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel))" : "Stat #1")").padding(1).if(settingsViewModel.formulas.count >= 1) {
                    $0.border(settingsViewModel.formulas[0].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black, width: 2)
                }
                Text("\(settingsViewModel.formulas.count >= 2 ? settingsViewModel.formulas[1].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamAbbr ?? "" : gameViewModel.game?.homeTeam.teamAbbr ?? "" : "") \(settingsViewModel.formulas.count >= 2 ? "\(settingsViewModel.formulas[1].getFormulaShortName()): \( settingsViewModel.formulas[1].getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel))" : "Stat #2")").padding(1).if(settingsViewModel.formulas.count >= 2) {
                    $0.border(settingsViewModel.formulas[1].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black, width: 2)
                }
                Text("\(settingsViewModel.formulas.count == 3 ? settingsViewModel.formulas[2].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamAbbr ?? "" : gameViewModel.game?.homeTeam.teamAbbr ?? "" : "") \(settingsViewModel.formulas.count == 3 ? "\(settingsViewModel.formulas[2].getFormulaShortName()): \( settingsViewModel.formulas[2].getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel))" : "Stat #3")")
                    .padding(1).if(settingsViewModel.formulas.count == 3) {
                        $0.border(settingsViewModel.formulas[2].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black, width: 2)
                    }
            }.position(x: geometry.size.width * 0.92, y: geometry.size.height*0.325)
            .onTapGesture {
                viewSheet = true
            }
        }.sheet(isPresented: $viewSheet, content: {
            AnalyticsTabView()
                .environmentObject(settingsViewModel)
                .environmentObject(gameViewModel)
        })
    }
}

struct LineScoreStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        LineScoreStatisticsView()
    }
}
