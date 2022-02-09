// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct ForceAddEventView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var viewStrikeWarning : Bool = false
    @State var viewBallWarning : Bool = false
    @State var viewOutWarning : Bool = false
    
    @State var homeLineupRevertWarning: Bool = false
    @State var awayLineupRevertWarning: Bool = false
    @State var homeLineupAdvanceWarning: Bool = false
    @State var awayLineupAdvanceWarning: Bool = false
    
    var body: some View {
        VStack {
            Text("Force Add Events")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .border(Color.black, width: 1)
            Text("Emergency Use Only")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .border(Color.black, width: 1)
            HStack {
                Button(action: {
                    self.viewStrikeWarning = true
                }, label: {
                    Text("Add Strike")
                }).padding()
                .frame(maxWidth: .infinity)
                .border(Color.blue)
                .actionSheet(isPresented: $viewStrikeWarning) { () -> ActionSheet in
                    ActionSheet(title: Text("Force Add Strike"),
                                message: Text("Are you sure you want to force add a strike?"),
                    buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                        eventViewModel.pitchEventInfo = PitchEventInfo()
                        eventViewModel.pitchEventInfo?.selectedPitchOutcome
                            = .StrikeForce
                        eventViewModel.isAddingPitch = true
                        gameViewModel.addEvent(eventViewModel: eventViewModel)
                        eventViewModel.reset()
                    })])
                        

                }
                HStack {
                    Button(action: {
                        self.viewBallWarning = true
                    }, label: {
                        Text("Add Ball")
                            
                    }).padding()
                    .frame(maxWidth: .infinity)
                    .border(Color.blue)
                    .actionSheet(isPresented: $viewBallWarning) { () -> ActionSheet in
                        ActionSheet(title: Text("Force Add Ball"),
                                    message: Text("Are you sure you want to force add a ball?"),
                                    buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                            eventViewModel.pitchEventInfo = PitchEventInfo()
                            eventViewModel.pitchEventInfo?.selectedPitchOutcome
                                = .BallForce
                            eventViewModel.isAddingPitch = true
                            gameViewModel.addEvent(eventViewModel: eventViewModel)
                            eventViewModel.reset()
                        })])
                    }
                }
                HStack {
                    Button(action: {
                        self.viewOutWarning = true
                    }, label: {
                        Text("Add Out")
                            
                    }).padding()
                    .frame(maxWidth: .infinity)
                    .border(Color.blue)
                    .actionSheet(isPresented: $viewOutWarning) { () -> ActionSheet in
                        ActionSheet(title: Text("Force Add Out"),
                                    message: Text("Are you sure you want add an out? This will not affect the count or the current batter"),
                                    buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                                        eventViewModel.pitchEventInfo = PitchEventInfo()
                                        eventViewModel.pitchEventInfo?.selectedPitchOutcome = .BIP
                                        eventViewModel.pitchEventInfo?.selectedBIPHit.append(.ForceOut)
                                        eventViewModel.isAddingPitch = true

                                        gameViewModel.addEvent(eventViewModel: eventViewModel)
                                        eventViewModel.reset()
//                                        if (gameViewModel.gameSnapshots.count > 0) {
//                                            gameViewModel.gameSnapshots[gameViewModel.gameSnapshots.count - 1].eventViewModel.numberOfOuts -= 1
//                                        }
                        })])
                    }
                }
            }
            Text("\(gameViewModel.game?.homeTeam.teamName ?? "Home Team") Lineup Emergency Functions")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding()
                .border(Color.black)
            HStack {
                Button(action: {
                                    self.homeLineupRevertWarning = true
                                }, label: {
                                    Text("Revert One Batter")
                                }).frame(maxWidth: .infinity)
                                .padding()
                                .font(.body)
                                .border(Color.red, width: 1)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .actionSheet(isPresented: $homeLineupRevertWarning) { () -> ActionSheet in
                                    ActionSheet(title: Text("Revert One Batter"),
                                                message: Text("Are you sure you want to revert one batter? This won't change previous events"),
                                                buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                                                    if !(gameViewModel.currentInning?.isTop ?? false) {
                                                        gameViewModel.advanceToRelativeBatter(team: .Home, isAdvancingInLineup: false)
                                                        gameViewModel.setCurrentHitter(team: .Home)
                                                    }
                                    })])
                                }
                                Button(action: {
                                    self.homeLineupAdvanceWarning = true
                                }, label: {
                                    Text("Advance One Batter")
                                }).frame(maxWidth: .infinity)
                                .padding()
                                .font(.body)
                                .border(Color.red, width: 1)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .actionSheet(isPresented: $homeLineupAdvanceWarning) { () -> ActionSheet in
                                    ActionSheet(title: Text("Advance One Batter"),
                                                message: Text("Are you sure you want to advance one batter? This won't change previous events"),
                                                buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                                                    
                                                    if !(gameViewModel.currentInning?.isTop ?? false) {
                                                        gameViewModel.advanceToRelativeBatter(team: .Home, isAdvancingInLineup: true)
                                                        gameViewModel.setCurrentHitter(team: .Home)
                                                    }

                                    })])
                                }
            }
            Text("\(gameViewModel.game?.awayTeam.teamName ?? "Away Team") Lineup Emergency Functions")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding()
                .border(Color.black)
            HStack {
                Button(action: {
                    self.awayLineupRevertWarning = true
                }, label: {
                    Text("Revert One Batter")
                }).frame(maxWidth: .infinity)
                .padding()
                .font(.body)
                .border(Color.red, width: 1)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .actionSheet(isPresented: $awayLineupRevertWarning) { () -> ActionSheet in
                    ActionSheet(title: Text("Revert One Batter"),
                                message: Text("Are you sure you want to revert one batter? This won't change previous events"),
                                buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                                    if gameViewModel.currentInning?.isTop ?? false {
                                        gameViewModel.advanceToRelativeBatter(team: .Away, isAdvancingInLineup: false)
                                        gameViewModel.setCurrentHitter(team: .Away)
                                    }
                    })])
                }
                Button(action: {
                    self.awayLineupAdvanceWarning = true
                }, label: {
                    Text("Advance One Batter")
                }).frame(maxWidth: .infinity)
                .padding()
                .font(.body)
                .border(Color.red, width: 1)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .actionSheet(isPresented: $awayLineupAdvanceWarning) { () -> ActionSheet in
                    ActionSheet(title: Text("Advance One Batter"),
                                message: Text("Are you sure you want to advance one batter? This won't change previous events"),
                                buttons: [Alert.Button.cancel(Text("No")),Alert.Button.default(Text("Yes"), action: {
                                    if gameViewModel.currentInning?.isTop ?? false {
                                        gameViewModel.advanceToRelativeBatter(team: .Away, isAdvancingInLineup: true)
                                        gameViewModel.setCurrentHitter(team: .Away)
                                    }
                    })])
                }
            }
                Spacer()
            }
            
//                VStack {
//                    VStack(alignment: .center) {
//                        Text("If you need to forcefully add a strike, ball, or move to the next half inning, select the appropriate action below.")
//                            .multilineTextAlignment(.center)
//                            .font(.subheadline)
//                        Text("** This view should only be used when absolutely necessary!!! **")
//                            .multilineTextAlignment(.center)
//                            .font(.system(size: 25, weight: .bold))
//                            .padding(.bottom)
//                    }
//                    HStack(alignment: .center) {
//                        VStack {
//
//                        }
//                    }
//                }
         
        }
    }
