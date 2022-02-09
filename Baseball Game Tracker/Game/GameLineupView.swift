// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameLineupView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var viewingHomeTeam : Bool = true
    
    var body: some View {
        // Checks if the game is valid
        if let game = gameViewModel.game {
            VStack {
                Text(viewingHomeTeam ? "Home Team" : "Away Team")
                    .font(.largeTitle)
                List {
                    ForEach(0..<getCurrentLineupViewing().count) { index in
                        HStack {
                            Text("#\(index)")
                            Spacer()
                            Text(getCurrentLineupViewing()[index].member.getFullName())
                            Spacer()
                            Text(getCurrentLineupViewing()[index].positionInGame.getPositionString())
                        }
                    }
                }
            }
        }
    }
    
    func getCurrentLineupViewing() -> [MemberInGame] {
        // Checks if there's a valid game
        if let game = gameViewModel.game {
            // Checks if the user is viewing the home team
            if viewingHomeTeam {
                // Returns the current home team lineup
                return gameViewModel.lineup.currentHomeTeamLineup
            } else {
                // Returns the current away team lineup
                return gameViewModel.lineup.curentAwayTeamLineup
            }
        }
        // Returns an empty array
        return []
    }
}
