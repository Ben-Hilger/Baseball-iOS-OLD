// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchTendenciesLoaderView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var pitchTendenciesViewModel: PitchTendenciesViewModel
    
    @State var membersViewing: [MemberInGame] = []
    @State var state : Int?
    
    var position: Positions
    var team: GameTeamType
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    pitchTendenciesViewModel.teamSelected = .Home
                    pitchTendenciesViewModel.objectWillChange.send()
                }, label: {
                    Text("\(gameViewModel.game?.homeTeam.teamName ?? "")")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .border(pitchTendenciesViewModel.teamSelected == .Home ? gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black : Color.black, width: 3)
                        .foregroundColor(pitchTendenciesViewModel.teamSelected == .Home ? gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black : Color.black)
                })
                Button(action: {
                    pitchTendenciesViewModel.teamSelected = .Away
                    pitchTendenciesViewModel.objectWillChange.send()
                }, label: {
                    Text("\(gameViewModel.game?.awayTeam.teamName ?? "")")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .border(pitchTendenciesViewModel.teamSelected == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : Color.black, width: 3)
                        .foregroundColor(pitchTendenciesViewModel.teamSelected == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : Color.black
                        )
                })
                PitchTendencyList(playerPosition: .Pitcher, sectionTitle: "Pitchers")
                    .environmentObject(gameViewModel)
                    .environmentObject(pitchTendenciesViewModel)
                PitchTendencyList(playerPosition: .Hitter, sectionTitle: "Hitters")
                    .environmentObject(gameViewModel)
                    .environmentObject(pitchTendenciesViewModel)
            //    List {
                    
//                    ForEach(membersViewing) { member in
//                        HStack {
//                            Text(member.member.getFullName())
//                               // .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.leading)
//                            Spacer()
//                            NavigationLink(
//                                destination: PitchTendenciesReportView(playerViewing: [member], pitchCounts: configurePitchCounts(forPlayers: [member]))
//                                    .environmentObject(gameViewModel)
//                                    .environmentObject(pitchTendenciesViewModel),
//                                tag: membersViewing.firstIndex(of: member) ?? 1,
//                                selection: $state,
//                                label: {
//                                    EmptyView()
//                                })
//                        }.contentShape(Rectangle()).onTapGesture {
//                            self.state = membersViewing.firstIndex(of: member) ?? 1
//                        }
//                    }
//                    // For all members at once
//                    HStack {
//                        Text("All Pitchers")
//                           // .frame(maxWidth: .infinity)
//                            .multilineTextAlignment(.leading)
//                        Spacer()
//                        NavigationLink(
//                            destination: PitchTendenciesReportView(playerViewing: membersViewing, pitchCounts: configurePitchCounts(forPlayers: membersViewing))
//                                .environmentObject(gameViewModel)
//                                .environmentObject(pitchTendenciesViewModel),
//                            tag: membersViewing.count + 1,
//                            selection: $state,
//                            label: {
//                                EmptyView()
//                            })
//                    }.contentShape(Rectangle()).onTapGesture {
//                        self.state = membersViewing.count + 1
//                    }
           //     }.border(Color.black)
                    
                    .navigationBarTitle("Pitch Tendency Reports", displayMode: .inline)
                    .navigationViewStyle(StackNavigationViewStyle())
            }

        }.navigationViewStyle(StackNavigationViewStyle())

    }

  
    
//    func configurePitchCounts(forPlayers players: [MemberInGame]) -> [PitchLocation : [PitchType : Int]] {
//        var pitchZoneCountSummary : [PitchLocation : [PitchType : Int]] = [:]
//
//        // var pitchCounts : [PitchType : Int] = [:]
//        for player in players {
//            let summary = pitchTendenciesViewModel
//                .generatePitchesSummaryByZone(withGameViewModel: gameViewModel,
//                        forPitcher: player)
//            for zones in summary {
//                var zoneSummary = pitchZoneCountSummary[zones.key] ?? [:]
//                for pitch in zones.value {
//                    var currentPitches = zoneSummary[pitch.key] ?? 0
//                    currentPitches += pitch.value
//                    zoneSummary.updateValue(currentPitches, forKey: pitch.key)
//                }
//                pitchZoneCountSummary.updateValue(zoneSummary, forKey: zones.key)
//            }
////
////                pitchCounts = pitchTendenciesViewModel
////                    .generatePitchesSummary(withGameViewModel: gameViewModel,
////                            forZone: pitchLocation,
////                            forPitcher: player)
//        }
//
//        return pitchZoneCountSummary
//    }
    
}

struct PitchTendencyList: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var pitchTendenciesViewModel: PitchTendenciesViewModel
    
    var playerPosition: PersonEditing
    
    @State var membersViewing: [MemberInGame] = []

    var sectionTitle: String
    
    @State var state : Int?
    
    @State var showHitter: Bool = false
    @State var showPitcher: Bool = false
    
    var body: some View {
        List {
            Section(header: Text(sectionTitle)) {
                ForEach(membersViewing) { member in
                    HStack {
//                        Text(member.member.getFullName())
//                           // .frame(maxWidth: .infinity)
//                            .multilineTextAlignment(.leading)
//                        Spacer()
                        if playerPosition == .Pitcher {
                            NavigationLink(
                                destination: PitchTendenciesReportView(playerViewing: [member], pitchCounts: configurePitchCounts(forPlayers: [member]), playerEditing: .Pitcher)
                                    .environmentObject(gameViewModel)
                                    .environmentObject(pitchTendenciesViewModel)) {
                                Text(member.member.getFullName())
                            }
                        } else if playerPosition == .Hitter {
                            NavigationLink(
                                destination: PitchTendenciesHitterTab(playersViewing: [member],
                                                                      hitterTeam: pitchTendenciesViewModel.teamSelected)) {
                                Text(member.member.getFullName())
                            }
                            
                        }
                    }.contentShape(Rectangle()).onTapGesture {
                        if playerPosition == .Hitter {
                            self.showHitter = true
                        } else {
                            self.showPitcher = true
                        }
                    }
                }
                // For all members at once
                HStack {
                    Text(playerPosition == .Pitcher ? "All Pitchers" : "All Hitters")
                       // .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if playerPosition == .Pitcher {
                        NavigationLink(
                            destination: PitchTendenciesReportView(playerViewing: membersViewing, pitchCounts: configurePitchCounts(forPlayers: membersViewing), playerEditing: .Pitcher)
                                .environmentObject(gameViewModel)
                                .environmentObject(pitchTendenciesViewModel),
                            tag: membersViewing.count + 1,
                            selection: $state,
                            label: {
                                EmptyView()
                            })
                    } else if playerPosition == .Hitter {
                        NavigationLink(
                            destination: PitchTendenciesHitterTab(playersViewing: membersViewing,
                                                                  hitterTeam: pitchTendenciesViewModel.teamSelected),
                            tag: membersViewing.count + 1,
                            selection: $state,
                            label: {
                                EmptyView()
                            })
                    }
                }.contentShape(Rectangle()).onTapGesture {
                    self.state = membersViewing.count + 1
                }
            }
        }.onAppear {
            loadMembers()
        }.onChange(of: pitchTendenciesViewModel.teamSelected, perform: { _ in
            print("It changed!")
            loadMembers()
        })
    }
    
    func loadMembers() {
        membersViewing = []
        if playerPosition == .Pitcher {
            for player in gameViewModel.getAllPitchers(forTeam: pitchTendenciesViewModel.teamSelected) {
                if !membersViewing.contains(MemberInGame(member: player, positionInGame: .Pitcher)) {
                    membersViewing.append(MemberInGame(member: player, positionInGame: .Pitcher))
                }
            }
        } else if playerPosition == .Hitter {
            for player in gameViewModel.getAllHitters(forTeam: pitchTendenciesViewModel.teamSelected) {
                membersViewing.append(MemberInGame(member: player, positionInGame: .DH))
            }
        }
        
    }
    
    func configurePitchCounts(forPlayers players: [MemberInGame]) -> [PitchLocation : [PitchType : Int]] {
        var pitchZoneCountSummary : [PitchLocation : [PitchType : Int]] = [:]
        
        // var pitchCounts : [PitchType : Int] = [:]
        for player in players {
            let summary = pitchTendenciesViewModel
                .generatePitchesSummaryByZone(withGameViewModel: gameViewModel,
                        forPitcher: player)
            for zones in summary {
                var zoneSummary = pitchZoneCountSummary[zones.key] ?? [:]
                for pitch in zones.value {
                    var currentPitches = zoneSummary[pitch.key] ?? 0
                    currentPitches += pitch.value
                    zoneSummary.updateValue(currentPitches, forKey: pitch.key)
                }
                pitchZoneCountSummary.updateValue(zoneSummary, forKey: zones.key)
            }
//
//                pitchCounts = pitchTendenciesViewModel
//                    .generatePitchesSummary(withGameViewModel: gameViewModel,
//                            forZone: pitchLocation,
//                            forPitcher: player)
        }
        
        return pitchZoneCountSummary
    }
    
    
}
