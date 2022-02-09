//
//  SeriesTabView.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/8/21.
//

import SwiftUI

struct SeriesTabView: View {
    
    @EnvironmentObject var seasonViewModel: SeasonViewModel
    @StateObject var seriesViewModel: SeriesViewModel = SeriesViewModel()
    
    /// Stores the current series being shown
    @State var seriesViewing: Series
    
    var body: some View {
        TabView {
            SeriesGameView(seriesViewing: seriesViewing)
                .environmentObject(seriesViewModel)
                .tabItem { Text("Games") }
            SeriesReportsView(seriesViewing: seriesViewing)
                .environmentObject(seriesViewModel)
                .tabItem { Text("Series Reports") }
        }.onAppear {
            // Load series information once the view appears
            seriesViewing.season = seasonViewModel.seasons[seasonViewModel.currentSeasonIndex!]
            loadSeriesInformation()
        }
    }
    
    func loadSeriesInformation() {
        seriesViewModel.loadSeriesInformation(withSeason: seasonViewModel.seasons[seasonViewModel.currentSeasonIndex!], forSeries: seriesViewing)
    }
}

struct SeriesTabView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesTabView(seriesViewing: Series(name: "Coastal Carolina", seriesID: "bgeragta", season: Season(withSeasonID: "", withSeasonYear: 0, withSeasonName: "")))
    }
}

struct SeriesGameView: View {
    
    
    @EnvironmentObject var seasonViewModel: SeasonViewModel
    @EnvironmentObject var seriesViewModel: SeriesViewModel
    
    var seriesViewing: Series
    
    @StateObject var gameViewModel: GameSetupViewModel = GameSetupViewModel()
    @State var state: Int?
    @State var isAddingGame: Bool = false
    
    var body: some View {
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
            if seriesViewModel.loadedGames.count > 0 {
                List {
                    ForEach(seriesViewModel.loadedGames) { game in
                        HStack {
                            Button {
                                self.gameViewModel.gameSelected = game
                                self.gameViewModel.loadInitialLineupInfo()
                                if game.homeTeam.members.count == 0 {
                                    gameViewModel.loadingMembers = true
                                    MemberSaveManagement.loadMemberTeamInformation(
                                        withSeason: seriesViewing.season,
                                        withTeam: game.homeTeam) { (member) in
                                        gameViewModel.loadingMembers = true
                                        if let index = game.homeTeam.members.firstIndex(of: member) {
                                            self.gameViewModel.gameSelected?.homeTeam.members[index] = member
                                        } else {
                                            self.gameViewModel.gameSelected?.homeTeam.members.append(member)
                                        }
                                        gameViewModel.loadingMembers = false
                                        self.gameViewModel.gameSelected?.homeTeam.members.sort {
                                            (member, member2) -> Bool in
                                            member.lastName < member2.lastName
                                        }
                                        self.gameViewModel.generateLineup()
                                    }
                                }
                                if game.awayTeam.members.count == 0 {
                                    MemberSaveManagement.loadMemberTeamInformation(withSeason: seriesViewing.season, withTeam: game.awayTeam) { (member) in
                                        gameViewModel.loadingMembers = true
                                        if let index = game.awayTeam.members.firstIndex(of: member) {
                                            self.gameViewModel.gameSelected?.awayTeam.members[index] = member
                                        } else {
                                            self.gameViewModel.gameSelected?.awayTeam.members.append(member)
                                        }
                                        gameViewModel.loadingMembers = false
                                        self.gameViewModel.gameSelected?.awayTeam.members.sort {
                                            (member, member2) -> Bool in
                                            member.lastName < member2.lastName
                                        }
                                        self.gameViewModel.generateLineup()
                                    }
                                }
                                
                                self.state = self.seriesViewModel.loadedGames.firstIndex(of: game) ?? 1
                            } label: {
                                Text("\(game.awayTeam.teamName) @ \(game.homeTeam.teamName) \n\(DateUtil.getFormattedDay(forDate: game.date))")
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                            }
                            NavigationLink(
                                destination: GameTabView()
                                    .environmentObject(gameViewModel),
                                tag: self.seriesViewModel.loadedGames.firstIndex(of: game) ?? 1,
                                selection: $state,
                                label: {
                                    EmptyView()
                                })
                        }
                    }
                }
            } else {
                Text("Once you add games, they'll show up here")
            }
        }
    }
}

struct SeriesReportsView: View {
    
    @EnvironmentObject var seriesViewModel: SeriesViewModel
    @EnvironmentObject var seasonViewModel: SeasonViewModel
    
    var seriesViewing: Series
    
    @State var state: Int?
    
    var body: some View {
        VStack {
            List {
                HStack {
                    Button(action: {
                        loadGamesInfo()
                        self.state = 1
                    }, label: {
                        Text("Pitch Tendencies")
                    })
                    Spacer()
                    NavigationLink(
                        destination: PitchTendenciesReportLoaderView(seriesViewing: seriesViewing, teamViewing: .Home)
                            .environmentObject(seriesViewModel),
                        tag: 1,
                        selection: $state,
                        label: {
                            EmptyView()
                        })
                }
            }
        }
    }
    
    
    
    func loadGamesInfo() {
        for game in seriesViewModel.loadedGames {
            let homeTeam = game.homeTeam.members
            let awayTeam = game.awayTeam.members
            if homeTeam.count == 0 {
                MemberSaveManagement.loadMemberTeamInformation(
                    withSeason: seriesViewing.season,
                    withTeam: game.homeTeam) { (member) in
                    if let index = seriesViewModel.loadedMembers.firstIndex(of: member) {
                        seriesViewModel.loadedMembers[index] = member
                    } else {
                        seriesViewModel.loadedMembers.append(member)
                    }
            
                }
            }
            if awayTeam.count == 0 {
                MemberSaveManagement.loadMemberTeamInformation(withSeason: seriesViewing.season, withTeam: game.awayTeam) { (member) in
                    if let index = seriesViewModel.loadedMembers.firstIndex(of: member) {
                        seriesViewModel.loadedMembers[index] = member
                    } else {
                        print("adding member")
                        seriesViewModel.loadedMembers.append(member)
                    }
                }
            }
        }
    }
}
