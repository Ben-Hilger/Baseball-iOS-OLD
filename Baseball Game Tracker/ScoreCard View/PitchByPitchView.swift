// Copyright 2021-Present Benjamin Hilger

//import SwiftUI
//
//struct PitchByPitchView: View {
//
//    @EnvironmentObject var gameViewModel : GameViewModel
//    @EnvironmentObject var settingsViewModel : SettingsViewModel
//
//    @State var isViewingPitcherOptions : Bool = false
//    @State var isViewingHitterOptions : Bool = false
//    @State var viewLiveLineupChange : Bool = false
//    @State var viewLiveLineupChangeHitter : Bool = false
//    @State var isViewingStatCustom : Bool = false
//    @State var isViewingSettings : Bool = false
//
//    var body: some View {
//        if let currentInning = gameViewModel.currentInning, let game = gameViewModel.game, let hitter = gameViewModel.currentHitter {
//            // Begin Strike, Ball and Out Section
//                GeometryReader { (geometry) in
//                    // Display Inning Information
//                    Text("\(currentInning.isTop ? "Top" : "Bottom") of \(Int(ceil(Double(gameViewModel.currentInning?.inningNum ?? 0)/2.0)))\(NumberUtil.getNumberEnding(forNumber: Int(ceil(Double(gameViewModel.currentInning?.inningNum ?? 0)/2.0))))")
//                        .position(x: geometry.size.width*0.5, y: geometry.size.height*0.1)
//                    // Display Score
//                    Text("\(gameViewModel.homeScore)-\(gameViewModel.awayScore)")
//                        .position(x: geometry.size.width*0.5, y: geometry.size.height*0.25)
//                    HStack {
//                        Text("Balls")
//                        Image(systemName: gameViewModel.getCurrentBalls() >= 1 ? "circle.fill" : "circle")
//                        Image(systemName: gameViewModel.getCurrentBalls() >= 2 ? "circle.fill" : "circle")
//                        Image(systemName: gameViewModel.getCurrentBalls() >= 3 ? "circle.fill" : "circle")
//
//                        Text("Strikes")
//                        Image(systemName: gameViewModel.getCurrentStrikes() >= 1 ? "circle.fill" : "circle")
//                        Image(systemName: gameViewModel.getCurrentStrikes() >= 2 ? "circle.fill" : "circle")
//
//                        Text("Outs")
//                        Image(systemName: currentInning.outsInInning >= 1 ? "circle.fill" : "circle")
//                        Image(systemName: currentInning.outsInInning >= 2 ? "circle.fill" : "circle")
//                    }.position(x: geometry.size.width*0.5, y: geometry.size.height*0.4)
//                    HStack {
//                        Text(game.awayTeam.teamName)
//                        if currentInning.isTop {
//                            Image(systemName: "circle.fill")
//                                .foregroundColor(game.awayTeam.teamPrimaryColor)
//                        }
//                    }.position(x: geometry.size.width*0.75, y: geometry.size.height*0.25)
//                    HStack {
//                        if !currentInning.isTop {
//                            Image(systemName: "circle.fill")
//                                .foregroundColor(game.homeTeam.teamPrimaryColor)
//                        }
//                        Text(game.homeTeam.teamName)
//                    }.position(x: geometry.size.width*0.25, y: geometry.size.height*0.25)
//                    VStack {
//                        Text("Stat #1").padding(1)
//                           // .position(x: geometry.size.width * 0.9 ,y: geometry.size.height*0.125)
//                        Text("Stat #2").padding(1)
//                        Text("Stat #3").padding(1).actionSheet(isPresented: $isViewingStatCustom) { () -> ActionSheet in
//                            return ActionSheet(title: Text("Statistics"), message: nil, buttons: [Alert.Button.default(Text("Customize Statistics")) {
//
//                            }])
//                        }
//                    }.onTapGesture {
//                        self.isViewingStatCustom = true
//                    }.position(x: geometry.size.width * 0.9 ,y: geometry.size.height*0.325)
//                    VStack {
//                        Image(systemName: "gear")
//                            .font(.system(size: 25))
//                            .onTapGesture {
//                                self.isViewingSettings = true
//                            }.sheet(isPresented: $isViewingSettings, content: {
//                                SettingsView()
//                                    .environmentObject(settingsViewModel)
//                            })
//                    }.position(x: geometry.size.width * 0.05 ,y: geometry.size.height*0.325)
//                    HStack {
//                        HStack {
//                            Text("\(gameViewModel.getCurrentPitcher()?.member.getFullName() ?? "") #\(gameViewModel.getCurrentPitcher()?.member.uniformNumber ?? 0)").padding()
//                            Spacer()
//                            Text("\(gameViewModel.pitchTracker[gameViewModel.getCurrentPitcher()?.member.memberID ?? ""] ?? 0) Pitches")
//                        }.actionSheet(isPresented: $isViewingPitcherOptions) {
//                            return ActionSheet(title: Text("Pitcher Options"), buttons: [Alert.Button.default(Text("Change Pitcher"), action: {
//                                self.viewLiveLineupChange = true
//                            })])
//                        }.sheet(isPresented: $viewLiveLineupChange) {
//                            LiveLineupChangeView(editingAwayTeam: !(gameViewModel.currentInning?.isTop ?? false), state: .Fielder, position: .Pitcher)
//                                .environmentObject(gameViewModel)
//                                .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup, withCurrentHitter: hitter))
//                        }
//                        Spacer()
//                        Text("P").padding().border(Color.black, width: 1)
//                    }.frame(width: UIScreen.main.bounds.width*0.5).border(Color.black, width: 1).padding(.top).padding(.bottom).position(x: geometry.size.width*0.25, y: geometry.size.height*0.8).onTapGesture { isViewingPitcherOptions = true }
//                    HStack {
//                        HStack {
//                            Text("\(gameViewModel.getCurrentHitter()?.member.getFullName() ?? "")  #\(gameViewModel.getCurrentHitter()?.member.uniformNumber ?? 0)").padding()
//                            Spacer()
//                            Text("H").padding().border(Color.black, width: 1)
//                        }.actionSheet(isPresented: $isViewingHitterOptions) {
//                            ActionSheet(title: Text("Hitter Options"), message: nil, buttons: [Alert.Button.default(Text("Pinch Hitter"), action: {
//                                self.viewLiveLineupChangeHitter = true
//                            })])
//
//                    }.frame(width: UIScreen.main.bounds.width*0.5).border(Color.black, width: 1).padding(.top).padding(.bottom).position(x: geometry.size.width*0.75, y: geometry.size.height*0.8).onTapGesture { isViewingHitterOptions = true }
//                    }.sheet(isPresented: $viewLiveLineupChangeHitter) {
//                        LiveLineupChangeView(editingAwayTeam: (gameViewModel.currentInning?.isTop ?? false), state: .Hitter)
//                            .environmentObject(gameViewModel)
//                            .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup, withCurrentHitter: hitter))
//                    }
//            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.2).border(Color.black, width: 1)
//        }
//    }
//}
