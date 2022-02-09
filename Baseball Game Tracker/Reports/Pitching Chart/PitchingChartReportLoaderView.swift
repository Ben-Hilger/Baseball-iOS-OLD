// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchingChartReportLoaderView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @StateObject var pitchingChartViewModel : PitchingChartViewModel =
        PitchingChartViewModel()
    
    @State var state: Int?
    
    var body: some View {
        if gameViewModel.isCheckingForInitialData {
            ActivityIndicator()
        } else {
            NavigationView {
                List {
                    Section(header: Text("\(gameViewModel.game?.homeTeam.teamName ?? "Home Team")")) {
                        ForEach(gatherAllPitchers(forTeam: .Home)) { player in
                            HStack {
                                Text(player.getFullName())
                                    .padding()
                                NavigationLink(
                                    destination: PitchingChartReportView(pitcherViewing: [player])
                                    .environmentObject(pitchingChartViewModel),
                                    tag: gatherAllPitchers(forTeam: .Home).firstIndex(of: player) ?? 1,
                                selection: $state,
                                label: {
                                    EmptyView()
                                })
                            }.contentShape(Rectangle()).onTapGesture {
                                pitchingChartViewModel.loadPitcherInformation(
                                        withGameInformation: gameViewModel,
                                    withPitchers: [player])
                                self.state = gatherAllPitchers(forTeam: .Home).firstIndex(of: player) ?? 1
                            }
                            
                        }
                        HStack {
                            Text("All Home Team Pitchers")
                                .padding()
                            NavigationLink(
                                destination: PitchingChartReportView(pitcherViewing: gatherAllPitchers(forTeam: .Home))
                                    .environmentObject(pitchingChartViewModel),
                                tag: gatherAllPitchers(forTeam: .Home).count + 5,
                            selection: $state,
                            label: {
                                EmptyView()
                            })
                        }.contentShape(Rectangle()).onTapGesture {
                            pitchingChartViewModel.loadPitcherInformation(
                                    withGameInformation: gameViewModel,
                                withPitchers: gatherAllPitchers(forTeam: .Home))
                            self.state = gatherAllPitchers(forTeam: .Home).count + 5
                        }
                    }
                    Section(header: Text("\(gameViewModel.game?.awayTeam.teamName ?? "Away Team")")) {
                        ForEach(gatherAllPitchers(forTeam: .Away)) { player in
                            HStack {
                                Text(player.getFullName())
                                    .padding()
                                NavigationLink(
                                    destination: PitchingChartReportView(pitcherViewing: [player])
                                    .environmentObject(pitchingChartViewModel),
                                    tag: gatherAllPitchers(forTeam: .Away).firstIndex(of: player) ?? 1 + gatherAllPitchers(forTeam: .Away).count * 2,
                                selection: $state,
                                label: {
                                    EmptyView()
                                })
                        }.contentShape(Rectangle()).onTapGesture {
                            pitchingChartViewModel.loadPitcherInformation(
                                    withGameInformation: gameViewModel,
                                withPitchers: [player])
                            self.state = gatherAllPitchers(forTeam: .Away).firstIndex(of: player) ?? 1 + gatherAllPitchers(forTeam: .Away).count * 2
                        }
                            
                        }
                    }
                    HStack {
                        Text("All Away Team Pitchers")
                            .padding()
                        NavigationLink(
                            destination: PitchingChartReportView(pitcherViewing: gatherAllPitchers(forTeam: .Home))
                                .environmentObject(pitchingChartViewModel),
                            tag: gatherAllPitchers(forTeam: .Away).count + 5,
                        selection: $state,
                        label: {
                            EmptyView()
                        })
                    }.contentShape(Rectangle()).onTapGesture {
                        pitchingChartViewModel.loadPitcherInformation(
                                withGameInformation: gameViewModel,
                            withPitchers: gatherAllPitchers(forTeam: .Away))
                        self.state = gatherAllPitchers(forTeam: .Away).count + 5
                    }
                }
                .navigationBarTitle("Pitchers", displayMode: .inline)
            }
        }
    }
    
    func gatherAllPitchers(forTeam team: GameTeamType) -> [Member] {
        return gameViewModel.getAllPitchers(forTeam: team)
    }
}
