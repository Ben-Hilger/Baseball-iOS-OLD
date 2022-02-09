// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameInformationView: View {
    
    @EnvironmentObject var gameSetupViewModel : GameSetupViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    //var game : Game
    
    @State private var hometeamEditMode = EditMode.inactive
    @State private var awayteamEditMode = EditMode.inactive
    
    @State var state: Int?
    @State var state2: Int?
    var body: some View {
       // NavigationView {
            if var game = gameSetupViewModel.gameSelected {
                VStack {
                    Text("Game Information")
                        .font(.largeTitle)
                    List {
                        HStack {
                            Text("Home Team")
                            Spacer()
                            Text(game.homeTeam.teamName)
                        }.padding()
                        HStack {
                            Text("Away Team")
                            Spacer()
                            Text(game.awayTeam.teamName)
                        }.padding()
                        HStack {
                            Text("Game Time")
                            Spacer()
                            Text(DateUtil.getFormattedDay(forDate: game.date))
                        }.padding()
                        HStack {
                            Text("Location")
                            Spacer()
                            Text("\(game.city), \(game.state)")
                        }.padding()
//                        HStack {
//                            Button(action: {
//                                gameViewModel.game = game
//                                MongoDBConversion.convertGame(gameToConvert: gameViewModel)
//                            }, label: {
//                                Text("Convert to Mongo Format")
//                            })
//                            Text("Convert to Mongo Format")
//                            Spacer()
//                            Text("\(game.city), \(game.state)")
//                        }.padding()
                        HStack {
                            Text("Game Statistics")
                            Spacer()
                            Button(action: {
                                // Set the game
                                gameViewModel.game = game
                                // Try to hold previous information
                                gameViewModel.checkAndLoadPreviousGameInformation(
                                    withLineup: gameSetupViewModel.lineupViewModel)
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
                            Spacer()
                            NavigationLink(
                                destination: StatisticsSelectionView()
                                    .environmentObject(gameViewModel)
                                    .environmentObject(gameSetupViewModel),
                                tag: 1,
                                selection: $state,
                                label: {
                                    EmptyView()
                                })
                                .hidden()
                        }
                    }
                }
            } else {
                Text("There was no game selected!!")
            }
      //  }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getButtonMessage() -> String {
        if gameSetupViewModel.gameSelected?.gameScheduleState == .Scheduled {
            return "Begin Recording Data"
        } else if gameSetupViewModel.gameSelected?.gameScheduleState == .InProgress {
            return "Resume Recording Data"
        } else if gameSetupViewModel.gameSelected?.gameScheduleState == .Finished {
            return "View Reports"
        }
        return "Unknown Action"
    }
}

struct DeveloperOptionsView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @State var uploading: Bool = false
    
    var body: some View {
        List {
            Button(action: {
                self.uploading = true
                for snapshot in gameViewModel.gameSnapshots {
                    print("Uploading")
                    MongoDBConversion.convertGameSnapshot(gameSnapshot: snapshot)
                }
                self.uploading = false
            }, label: {
                Text("Developer Options")
            })
        }
        if (uploading) {
            ActivityIndicator()
        }
    }
}

struct StatisticsSelectionView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var gameSetupViewModel: GameSetupViewModel
    
    @StateObject var settings: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        if gameViewModel.game?.gameScheduleState == .Finished {
            TabView {
                AnalyticsReportView()
                    .environmentObject(gameViewModel)
                    .environmentObject(settings)
                    .tabItem { Text("Analytics Reports") }
                GameSnapshotView()
                    .environmentObject(gameViewModel)
                    .environmentObject(settings)
                    .tabItem { Text("Game History") }
                DeveloperOptionsView()
                    .environmentObject(gameViewModel)
                    .tabItem { Text("Developer Options") }
            }.navigationBarTitle("Analytics")
            
        } else {
            GameRoleView()
               .environmentObject(gameViewModel)
               .environmentObject(gameSetupViewModel.lineupViewModel)
                .navigationBarTitle("Game Roles")
        }
    }
}
