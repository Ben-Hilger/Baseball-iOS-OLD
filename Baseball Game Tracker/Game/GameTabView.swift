// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameTabView: View {
    
    @EnvironmentObject var gameSetupViewModel : GameSetupViewModel
    
    @StateObject var gameViewModel : GameViewModel = GameViewModel()
        
    var body: some View {
        if !gameSetupViewModel.loadingMembers {
            TabView {
                GameInformationView()
                    .environmentObject(gameSetupViewModel)
                    .environmentObject(gameViewModel)
                    .tabItem { Text("Game Information") }
                VStack {
                    LineupEditView(editingAwayTeam: false)
                        .environmentObject(gameSetupViewModel.lineupViewModel)
                        .onDisappear {
                            let change = LineupChange(prevHomeTeamLineup: gameSetupViewModel.lineupViewModel.homeLineup, prevAwayTeamLineup: gameSetupViewModel.lineupViewModel.awayLineup, newHomeTeamLineup: gameSetupViewModel.lineupViewModel.homeLineup, newAwayTeamLineup: gameSetupViewModel.lineupViewModel.awayLineup, pitchNumChanged: 0)
                            gameViewModel.lineup.totalHomeTeamRoster = gameSetupViewModel.lineupViewModel.homeRoster
                            gameViewModel.lineup.totalAwayTeamRoster = gameSetupViewModel.lineupViewModel.awayRoster
                            gameViewModel.lineup.curentAwayTeamLineup = gameSetupViewModel.lineupViewModel.awayLineup
                            gameViewModel.lineup.currentHomeTeamLineup = gameSetupViewModel.lineupViewModel.homeLineup
                            if let game = gameSetupViewModel.gameSelected {
                                LineupSaveManagement.saveLineupChange(gameToSave: game, changeToSubmit: change)
                            }
                        }
                }.tabItem {
                    Text("Home Team Lineup")
                }
                VStack {
                    LineupEditView(editingAwayTeam: true)
                        .environmentObject(gameSetupViewModel.lineupViewModel)
                        .onDisappear {
                            let change = LineupChange(prevHomeTeamLineup: gameSetupViewModel.lineupViewModel.homeLineup, prevAwayTeamLineup: gameSetupViewModel.lineupViewModel.awayLineup, newHomeTeamLineup: gameSetupViewModel.lineupViewModel.homeLineup, newAwayTeamLineup: gameSetupViewModel.lineupViewModel.awayLineup, pitchNumChanged: 0)
                            gameViewModel.lineup.totalHomeTeamRoster = gameSetupViewModel.lineupViewModel.homeRoster
                            gameViewModel.lineup.totalAwayTeamRoster = gameSetupViewModel.lineupViewModel.awayRoster
                            gameViewModel.lineup.curentAwayTeamLineup = gameSetupViewModel.lineupViewModel.awayLineup
                            gameViewModel.lineup.currentHomeTeamLineup = gameSetupViewModel.lineupViewModel.homeLineup
                            if let game = gameSetupViewModel.gameSelected {
                                LineupSaveManagement.saveLineupChange(gameToSave: game, changeToSubmit: change)
                            }
                        }
                }.tabItem {
                    Text("Away Team Lineup")
                }
    //            GameStatsView()
    //                .environmentObject(gameSetupViewModel)
    //                .environmentObject(gameViewModel)
    //                .tabItem { Text("Game Stats") }
            }
            .navigationBarTitle("\(gameSetupViewModel.gameSelected?.awayTeam.teamName ?? "Away") @ \(gameSetupViewModel.gameSelected?.homeTeam.teamName ?? "Home")", displayMode: .inline)
            .onChange(of: gameSetupViewModel.loadingMembers, perform: { value in
                self.gameSetupViewModel.objectWillChange.send()
            })
        } else {
            ActivityIndicator()
                .onChange(of: gameSetupViewModel.loadingMembers, perform: { value in
                    self.gameSetupViewModel.objectWillChange.send()
                })
        }
    }
}
