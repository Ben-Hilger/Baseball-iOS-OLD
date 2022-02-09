// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameStatsView: View {
    
    @EnvironmentObject var gameSetupViewModel : GameSetupViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @State var state : Int? = 0
        
    var body: some View {
        if let game = gameSetupViewModel.gameSelected {
            VStack {
                Text("Game Statistics")
                Spacer()
                Text(getGameStatusMessage())
                Spacer()
                Button(action: {
                    gameViewModel.game = game
                    
//                    gameViewModel.lineup = Lineup(
//                        currentHomeTeamLineup:
//                            gameSetupViewModel.lineupViewModel.homeLineup,
//                        totalHomeTeamRoster:
//                            gameSetupViewModel.lineupViewModel.homeRoster,
//                        curentAwayTeamLineup:
//                                gameSetupViewModel.lineupViewModel.awayLineup,
//                        totalAwayTeamRoster:
//                            gameSetupViewModel.lineupViewModel.awayRoster)
                    gameViewModel.summaryData =
                        gameSetupViewModel.summarizedData
                    self.state = 1
                }, label: {
                    Text(getButtonMessage())
                })
                .padding().border(Color.blue, width: 5).cornerRadius(3.0)
                NavigationLink(
                    destination: GameRoleView()
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSetupViewModel.lineupViewModel),
                    tag: 1,
                    selection: $state,
                    label: {
                        EmptyView()
                    })
                    .hidden()
            }
        }
    }
    
    func getGameStatusMessage() -> String {
        if gameSetupViewModel.gameSelected?.gameScheduleState == .Scheduled {
            return "No game information has been record, press the start button to begin!"
        } else if gameSetupViewModel.gameSelected?.gameScheduleState == .InProgress {
            return "The game is currently in progress, use the option below to pickup recording at the current game state"
        } else if gameSetupViewModel.gameSelected?.gameScheduleState == .Finished {
            return "The game is compelte, you can view a variety of post-game reports"
        }
        return "Unkown Game State"
    }
    
    func getButtonMessage() -> String {
        if gameSetupViewModel.gameSelected?.gameScheduleState == .Scheduled ||
            gameSetupViewModel.gameSelected?.gameScheduleState == .InProgress {
            return "Begin Recording Data"
        } else if gameSetupViewModel.gameSelected?.gameScheduleState == .Finished {
            return "View Reports"
        }
        return "Unknown Action"
    }
}

struct GameStatsView_Previews: PreviewProvider {
    static var previews: some View {
        GameStatsView()
    }
}
