// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SeasonGameView: View {
    
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    
    @StateObject var gameViewModel : GameSetupViewModel = GameSetupViewModel()
    @State var isAddingGame : Bool = false
    
    @State var state : Int?
    
    init() {
    }
    
    var body: some View {
        if let seasonIndex = seasonViewModel.currentSeasonIndex {
            VStack {
                HStack {
                    Text("Games")
                        .padding()
                    Image(systemName: "plus.app")
                    .foregroundColor(.blue)
                    .sheet(isPresented: $isAddingGame) {
                            GameNavigation()
                                .environmentObject(seasonViewModel)
                    }.onTapGesture {
                            isAddingGame = true
                    }
                }
                List {
                    ForEach(seasonViewModel.seasons[seasonIndex].games) { game in
                        HStack {
                            Button {
                                self.gameViewModel.gameSelected = game
                                self.gameViewModel.loadInitialLineupInfo()
                                if game.homeTeam.members.count == 0 {
                                    gameViewModel.loadingMembers = true
                                    MemberSaveManagement.loadMemberTeamInformation(withSeason: seasonViewModel.seasons[seasonIndex], withTeam: game.homeTeam) { (member) in
                                        gameViewModel.loadingMembers = true
                                        if let index = game.homeTeam.members.firstIndex(of: member) {
                                            self.gameViewModel.gameSelected?.homeTeam.members[index] = member
                                        } else {
                                            self.gameViewModel.gameSelected?.homeTeam.members.append(member)
                                        }
                                        gameViewModel.loadingMembers = false
                                        self.gameViewModel.gameSelected?.homeTeam.members.sort { (member, member2) -> Bool in
                                            member.lastName > member2.lastName
                                        }
                                        self.gameViewModel.generateLineup()
                                    }
                                }
                                if game.awayTeam.members.count == 0 {
                                    MemberSaveManagement.loadMemberTeamInformation(withSeason: seasonViewModel.seasons[seasonIndex], withTeam: game.awayTeam) { (member) in
                                        gameViewModel.loadingMembers = true
                                        if let index = game.awayTeam.members.firstIndex(of: member) {
                                            self.gameViewModel.gameSelected?.awayTeam.members[index] = member
                                        } else {
                                            self.gameViewModel.gameSelected?.awayTeam.members.append(member)
                                        }
                                        gameViewModel.loadingMembers = false
                                        self.gameViewModel.gameSelected?.awayTeam.members.sort { (member, member2) -> Bool in
                                            member.lastName > member2.lastName
                                        }
                                        self.gameViewModel.generateLineup()
                                    }
                                }
                                
                                self.state = seasonViewModel.seasons[seasonIndex].games.firstIndex(of: game) ?? 1
                            } label: {
                                Text("\(game.awayTeam.teamName) @ \(game.homeTeam.teamName) @\n\(DateUtil.getFormattedDay(forDate: game.date))")
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                            }  
                            NavigationLink(
                                destination: GameTabView()
                                    .environmentObject(gameViewModel),
                                tag: seasonViewModel.seasons[seasonIndex].games.firstIndex(of: game) ?? 1,
                                selection: $state,
                                label: {
                                    EmptyView()
                                })
                        }
                        
                    }
                }.border(Color.black, width: 1)
            }
        }
    }
}
