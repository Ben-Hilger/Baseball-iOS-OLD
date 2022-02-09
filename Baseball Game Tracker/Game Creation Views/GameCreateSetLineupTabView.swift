// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameCreateSetLineupTabView: View {
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var seasonViewModel : SeasonViewModel
 ///   @EnvironmentObject var lineupViewModel : LineupViewModel
    
    var completion : () -> Void
    
    var body: some View {
        if let game = seasonViewModel.gameAdding, let seasonIndex = seasonViewModel.currentSeasonIndex {
            VStack {
                TabView {
                    LineupEditView(editingAwayTeam: true)
                        .environmentObject(seasonViewModel.lineupEditing)
                        .tabItem { Text("Away Team") }
                    LineupEditView(editingAwayTeam: false)
                        .environmentObject(seasonViewModel.lineupEditing)
                        .tabItem { Text("Home Team") }
                }
                Button(action: {
                    game.gameID = GameSaveManagement.saveGameInformation(gameToSave: game)
                    LineupSaveManagement.saveLineupChange(gameToSave: game, changeToSubmit: LineupChange(prevHomeTeamLineup: [], prevAwayTeamLineup: [], newHomeTeamLineup: seasonViewModel.lineupEditing.homeLineup, newAwayTeamLineup: seasonViewModel.lineupEditing.awayLineup, pitchNumChanged: 0))
                    seasonViewModel.seasons[seasonIndex].games.append(game)
                    presentation.wrappedValue.dismiss()
                    completion()
                }, label: {
                    Text("Create Game")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .border(Color.blue, width: 3)
                })
            }
        }
    }
}
