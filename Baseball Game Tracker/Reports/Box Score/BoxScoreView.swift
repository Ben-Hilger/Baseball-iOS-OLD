// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct BoxScoreView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var analyticsCalc = BoxScoreAnalytics()
    
    @State var teamViewing : GameTeamType = .Away
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Box Score")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding()
                    .border(Color.black, width: 3)
                HStack {
                    Text("\(gameViewModel.game?.homeTeam.teamName ?? "Home Team")")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .border(teamViewing == .Home ? gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black : Color.black, width: 3)
                        .onTapGesture {
                            teamViewing = .Home
                        }
                    Text("\(gameViewModel.game?.awayTeam.teamName ?? "Away Team")")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .border(teamViewing == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : Color.black, width: 3)
                        .onTapGesture {
                            teamViewing = .Away
                        }
                }
                List {
                    HStack {
                        Text("Hitters")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.1, alignment: .leading)
                        Text("AB")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("R")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("H")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("RBI")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("BB")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("K")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("AVG")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("OBP")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                        Text("SLG")
                            .padding()
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: geometry.size.width*0.085)
                    }
                    ForEach(analyticsCalc.getAllHitterIDs(fromGameViewModel: gameViewModel, fromCurrentTeam: teamViewing), id: \.self) { hitter in
                        HStack {
                            // Hitter Name
                            Text(analyticsCalc.getHitterName(fromId: hitter, fromLineup: gameViewModel.lineup, fromCurrentTeam: teamViewing))
                                .padding(1)
                                .frame(width: geometry.size.width*0.1, alignment: .leading)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                            
                            // At Bats
                            Text("\(AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: teamViewing, settingsViewModel: settingsViewModel, withSpecificHitter: hitter))")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // Runs
                            Text("0")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // Hits
                            Text("\(AnalyticsCore.getTotalHits(fromGameViewModel: gameViewModel, forTeam: teamViewing, settingsViewModel: settingsViewModel, withSpecificHitter: hitter))")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // RBI
                            Text("0")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // Walks
                            Text("\(AnalyticsCore.getTotalWalks(fromGameViewModel: gameViewModel, forTeam: teamViewing, settingsViewModel: settingsViewModel, withSpecificHitter: hitter))")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // K
                            Text("0")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // AVG
                            Text("\(BattingAverage(teamToAnalyze: teamViewing).getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel, forSpecificHitter: hitter, includeSummaryData: true))")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // OBP
                            Text("\(OnBasePercentage(teamToAnalyze: teamViewing).getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel, forSpecificHitter: hitter, includeSummaryData: true))")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                            // SLG
                            Text("\(SluggingPercentage(teamToAnalyze: teamViewing).getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel, forSpecificHitter: hitter, includeSummaryData: true))")
                                .padding(1)
                                .frame(width: geometry.size.width*0.085)
                                .font(.system(size: 10))

                        }
                    }
                }
            }
        }
        
    }
}
