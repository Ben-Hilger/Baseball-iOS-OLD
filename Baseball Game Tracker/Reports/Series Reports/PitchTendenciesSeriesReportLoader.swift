//
//  PitchTendenciesSeriesReportLoader.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/12/21.
//

import Foundation
import SwiftUI

struct PitchTendenciesReportLoaderView: View {
    
    @StateObject var pitchTendenciesViewModel: PitchTendenciesSeriesReportViewModel =
        PitchTendenciesSeriesReportViewModel()
    @EnvironmentObject var seriesViewModel: SeriesViewModel
    
    @State var loadedPitchers: [Member] = []
    @State var loadedHitters: [Member] = []
    
    @State var state: Int?
    @State var hitterState: Int?
    var seriesViewing: Series
    
    var teamViewing: GameTeamType
    
    var body: some View {
        VStack {
            Text("Pitch Tendencies")
                .padding()
            List {
                Section(header: Text("Pitchers")) {
                    ForEach(pitchTendenciesViewModel.pitchersHome) { pitcher in
                        HStack {
                            Text(pitcher.getFullName())
                                .padding()
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    print("Herre")
                                    _ = pitchTendenciesViewModel.populateReport(forPlayers: [pitcher],
                                                                            playerType: .Pitcher)
                                    self.state = pitchTendenciesViewModel.pitchersHome.firstIndex(of: pitcher) ?? 1
                                }
//                            Button(action: {
//                                print("Hello There")
//                                _ = pitchTendenciesViewModel.populateReport(forPlayers: [pitcher],
//                                                                        playerType: .Pitcher)
//                                self.state = pitchTendenciesViewModel.pitchersHome.firstIndex(of: pitcher) ?? 1
//                            }, label: {
//                                Text(pitcher.getFullName())
//                                    .padding()
//                            })
                            Spacer()
                            NavigationLink(
                                destination: PitchTendenciesSeriesReportView(playerViewing:
                                        [MemberInGame(member: pitcher, positionInGame: .Pitcher)], playerEditing: .Pitcher)
                                    .environmentObject(pitchTendenciesViewModel),
                                tag: pitchTendenciesViewModel.pitchersHome.firstIndex(of: pitcher) ?? 1,
                                selection: $state,
                                label: {
                                    EmptyView()
                                })
                        }
                    }
                }
                Section(header: Text("Hitters")) {
                    ForEach(pitchTendenciesViewModel.hittersHome) { hitter in
                        HStack {
                            Text(hitter.getFullName())
                                .padding()
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    print("Herre")
                                    pitchTendenciesViewModel.populateHitterReport(forPlayers: [hitter], playerType: .Hitter)
//                                    self.state = pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1 + pitchTendenciesViewModel.pitchersHome.count + 2
                                    self.hitterState = pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1
                                }
//                            Button(action: {
//                                print("Hello There")
//                                _ = pitchTendenciesViewModel.populateReport(forPlayers: [pitcher],
//                                                                        playerType: .Pitcher)
//                                self.state = pitchTendenciesViewModel.pitchersHome.firstIndex(of: pitcher) ?? 1
//                            }, label: {
//                                Text(pitcher.getFullName())
//                                    .padding()
//                            })
                            Spacer()
                            NavigationLink(
                                destination: PitchTendenciesSeriesReportHitterSplit(playersViewing: [MemberInGame(member: hitter, positionInGame: .DH)], hitterTeam: .Home)
                                    .environmentObject(pitchTendenciesViewModel),
                                tag: pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1,
                                selection: $hitterState,
                                label: {
                                    EmptyView()
                                }).onTapGesture {
                                    print("Herre")
                                    pitchTendenciesViewModel.populateHitterReport(forPlayers: [hitter], playerType: .Hitter)
//                                    self.state = pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1 + pitchTendenciesViewModel.pitchersHome.count + 2
                                    self.hitterState = pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1
                                }
                        }.onTapGesture {
                            print("Herre")
                            pitchTendenciesViewModel.populateHitterReport(forPlayers: [hitter], playerType: .Hitter)
//                                    self.state = pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1 + pitchTendenciesViewModel.pitchersHome.count + 2
                            self.hitterState = pitchTendenciesViewModel.hittersHome.firstIndex(of: hitter) ?? 1
                        }
                    }
                }
            }
        }.onAppear {
            state = nil
            hitterState = nil
            pitchTendenciesViewModel.loadGames(gamesToLoad: seriesViewModel.loadedGames, teamToView: teamViewing)
        }.onReceive(seriesViewModel.$loadedMembers, perform: { value in
            print("Changed")
            pitchTendenciesViewModel.loadPlayer(withMembers: seriesViewModel.loadedMembers)
        }).onReceive(pitchTendenciesViewModel.$hittersHome, perform: { _ in
            print("Hitters  Changed")
        }).onReceive(pitchTendenciesViewModel.$loadedSnapshots, perform: { _ in
            print("Changed Val")
            pitchTendenciesViewModel.loadPlayer(withMembers: seriesViewModel.loadedMembers)
        }).onReceive(pitchTendenciesViewModel.$needUpdate, perform: { _ in
            print("CC")
            pitchTendenciesViewModel.loadPlayer(withMembers: seriesViewModel.loadedMembers)
        })
        
    }
}
