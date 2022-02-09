// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotEditView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var snapshotEditing : GameSnapshotViewModel
    
    @State var pitchVelo : Float?
    @State var hitterVelo : Float?
    
    @State var isViewingSheet : Bool = false
    @State var sheetViewing : GameSnapshotEditViewSheetType = .Pitcher
    
    var body: some View {
        if let indexSelected = snapshotEditing.gameSnapshotIndexSelected {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Text("Pitcher")
                            .padding()
                            .frame(width: geometry.size.width * 0.3)
                            .border(Color.black)
                        Text("\(gameViewModel.gameSnapshots[indexSelected].getCurrentPitcher()?.member.getFullName() ?? "None")")
                            .padding()
                            .frame(width: geometry.size.width * 0.6)
                            .border(Color.black)
                            .onTapGesture {
                                self.sheetViewing = .Pitcher
                                self.isViewingSheet = true
                            }
                    }
                    HStack {
                        Text("Hitter")
                            .padding()
                            .frame(width: geometry.size.width * 0.3)
                            .border(Color.black)
                        Text("\(gameViewModel.gameSnapshots[indexSelected].currentHitter?.member.getFullName() ?? "None")")
                            .padding()
                            .frame(width: geometry.size.width * 0.6)
                            .border(Color.black)
                            .onTapGesture {
                                self.sheetViewing = .Hitter
                                self.isViewingSheet = true
                            }
                        
                    }
                    if let pitchVelo = pitchVelo {
                        VStack {
                            HStack {
                                Text("Pitch Velocity")
                                    .padding()
                                    .frame(width: geometry.size.width * 0.3)
                                    .border(Color.black)
                                Text("\(Int(pitchVelo)) MPH")
                                    .padding()
                                    .frame(width: geometry.size.width * 0.6)
                                    .border(Color.black)
                            }
                            Slider(value: Binding(get: {
                                gameViewModel.gameSnapshots[indexSelected].eventViewModel.pitchEventInfo?.completedPitch?.pitchVelo ?? 0
                            }, set: { (newVal) in
                                gameViewModel.gameSnapshots[indexSelected].eventViewModel.pitchEventInfo?.completedPitch?.pitchVelo = newVal
                                self.pitchVelo = newVal
                            }), in: 0...110, step: 1)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    if let hitterVelo = hitterVelo {
                        VStack {
                            HStack {
                                Text("Hitter Exit Velocity")
                                    .padding()
                                    .frame(width: geometry.size.width * 0.3)
                                    .border(Color.black)
                                Text("\(Int(hitterVelo)) MPH")
                                    .padding()
                                    .frame(width: geometry.size.width * 0.6)
                                    .border(Color.black)
                            }
                            Slider(value: Binding(get: {
                                gameViewModel.gameSnapshots[indexSelected].eventViewModel.pitchEventInfo?.completedPitch?.hitterExitVelo ?? 0
                            }, set: { (newVal) in
                                gameViewModel.gameSnapshots[indexSelected].eventViewModel.pitchEventInfo?.completedPitch?.hitterExitVelo = newVal
                                self.hitterVelo = newVal
                            }), in: 0...110, step: 1)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    PitchTypeEditSelection()
                        .environmentObject(gameViewModel)
                        .environmentObject(snapshotEditing)
                    PitchResultEditView()
                        .environmentObject(gameViewModel)
                        .environmentObject(snapshotEditing)
                    HandEditView(editing: .Pitcher)
                        .environmentObject(gameViewModel)
                        .environmentObject(snapshotEditing)
                    HandEditView(editing: .Hitter)
                        .environmentObject(gameViewModel)
                        .environmentObject(snapshotEditing)
                }.padding()
            }.onAppear(perform: {
                if let index = snapshotEditing.gameSnapshotIndexSelected {
                    pitchVelo = gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.pitchVelo
                    hitterVelo = gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.hitterExitVelo ?? 0
                }
            }).sheet(isPresented: $isViewingSheet, content: {
                if let index = snapshotEditing.gameSnapshotIndexSelected, let hitter = gameViewModel.gameSnapshots[index].currentHitter {
                    if sheetViewing == .Pitcher {
                        LiveLineupChangeView(editingAwayTeam: !(gameViewModel.gameSnapshots[index].currentInning?.isTop ?? false), state: .Fielder, position: .Pitcher, historyType: .Snapshot)
                            .environmentObject(gameViewModel)
                            .environmentObject(snapshotEditing)
                            .environmentObject(LineupViewModel(withLineup: gameViewModel.gameSnapshots[index].lineup, withCurrentHitter: hitter))
                    } else if sheetViewing == .Hitter {
                        LiveLineupChangeView(editingAwayTeam: (gameViewModel.gameSnapshots[index].currentInning?.isTop ?? false), state: .Hitter, historyType: .Snapshot)
                            .environmentObject(gameViewModel)
                            .environmentObject(snapshotEditing)
                            .environmentObject(LineupViewModel(withLineup: gameViewModel.gameSnapshots[index].lineup, withCurrentHitter: hitter))
                    }
                }
//            })
//            .onChange(of: snapshotEditing.gameSnapshotIndexSelected, perform: { value in
//                pitchVelo = gameViewModel.gameSnapshots[indexSelected].eventViewModel.pitchEventInfo?.completedPitch?.pitchVelo ?? 0
//                hitterVelo = gameViewModel.gameSnapshots[indexSelected].eventViewModel.pitchEventInfo?.completedPitch?.hitterExitVelo ?? 0
            })
//            .onDisappear(perform: {
//                // Saves the game snapshot when the user leaves the screen
//                //if gameViewModel.gameSnapshots[indexSelected].saved {
//                GameSnapshotSaveManagement.updateGameSnapshot(snapshotToUpdate: gameViewModel.gameSnapshots[snapshotEditing.gameSnapshotIndexSelected!])
//                //}
//            })
        } else {
            Text("No index selected")
        }
        
    }
}

enum GameSnapshotEditViewSheetType {
    case Pitcher
    case Hitter
}

struct PitchTypeEditSelection : View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var snapshotEditing : GameSnapshotViewModel
    
    @State var viewActionSheet : Bool = false
    
    var body: some View {
        if let index = snapshotEditing.gameSnapshotIndexSelected {
            GeometryReader { geometry in
                HStack {
                    Text("Pitch Type")
                        .padding()
                        .frame(width: geometry.size.width * 0.3)
                        .border(Color.black)
                    Spacer()
                    Button(action: {
                        viewActionSheet = true
                    }, label: {
                        Text("\(gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.selectedPitchThrown?.getPitchTypeString() ?? "No Pitch Thrown")")
                            .padding()
                            .border(Color.black)
                    }).actionSheet(isPresented: $viewActionSheet, content: {
                        ActionSheet(title: Text("Select Pitch Thrown"), buttons: generatePitchTypeOptions())
                    })
                }
            }
        }
    }
    
    func generatePitchTypeOptions() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        
        for type in PitchType.allCases {
            buttons.append(Alert.Button.default(Text("\(type.getPitchTypeString())"), action: {
                if let index = snapshotEditing.gameSnapshotIndexSelected {
                    // Sets the pitch type
                    gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.pitchType = type
                    gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.selectedPitchThrown = type
                }
            }))
        }
        
        return buttons
    }
}

struct PitchResultEditView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var snapshotViewModel: GameSnapshotViewModel
    
    @State var viewAcionSheet: Bool = false
    
    var body: some View {
        if let snapshotIndex = snapshotViewModel.gameSnapshotIndexSelected, let pitch = gameViewModel.gameSnapshots[snapshotIndex].eventViewModel.pitchEventInfo?.completedPitch {
            GeometryReader { geometry in
                HStack {
                    Text("Pitch Result")
                        .padding()
                        .frame(width: geometry.size.width * 0.3)
                        .border(Color.black)
                    Spacer()
                    Button(action: {
                        self.viewAcionSheet = true
                    }, label: {
                        Text("\(pitch.pitchResult?.getPitchOutcomeString() ?? "No Outcome")")
                            .padding()
                            .border(Color.black)
                    })
                }
            }.actionSheet(isPresented: $viewAcionSheet, content: {
                ActionSheet(title: Text("Change Outcome"), message: Text("You may select any of these other, equivalent outcomes to change this pitch to"), buttons: generateEquivalentOptions())
            })
        }
    }
    
    func generateEquivalentOptions() -> [Alert.Button] {
        var buttons: [Alert.Button] = []
        
        if let snapshotIndex = snapshotViewModel.gameSnapshotIndexSelected, let pitch = gameViewModel.gameSnapshots[snapshotIndex].eventViewModel.pitchEventInfo?.completedPitch {
            for equivalent in pitch.pitchResult?.getEquivalentOutcomes() ?? [] {
                buttons.append(Alert.Button.default(Text("\(equivalent.getPitchOutcomeString())"), action: {
                    gameViewModel.gameSnapshots[snapshotIndex].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult = equivalent
                    gameViewModel.gameSnapshots[snapshotIndex].eventViewModel.pitchEventInfo?.selectedPitchOutcome = equivalent
                }))
            }
        }
        
        return buttons
    }
}

struct HandEditView : View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var snapshotEditing : GameSnapshotViewModel
    
    var editing : PersonEditing
    
    var body: some View {
        HStack {
            Text("\(editing.getString()) \(editing == .Pitcher ? "Throwing" : "Batting") Hand")
            Spacer()
            Button(action: {
                changeHand(toHand: .Left)
            }, label: {
                Text("Left")
                    .padding()
                    .border(isSelected(hand: .Left) ? Color.blue : Color.black, width: 3)
                    .foregroundColor(isSelected(hand: .Left) ? Color.blue : Color.black)
            })
            Button(action: {
                changeHand(toHand: .Right)
            }, label: {
                Text("Right")
                    .padding()
                    .border(isSelected(hand: .Right) ? Color.blue : Color.black, width: 3)
                    .foregroundColor(isSelected(hand: .Right) ? Color.blue : Color.black)
            })
        }
    }
    
    func isSelected(hand : HandUsed) -> Bool {
        if let index = snapshotEditing.gameSnapshotIndexSelected  {
            return editing == .Pitcher ? gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.pitcherThrowingHand == hand : gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand == hand
        }
        return false
    }
    
    func changeHand(toHand hand: HandUsed) {
        if let index = snapshotEditing.gameSnapshotIndexSelected {
            if editing == .Pitcher {
                gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.pitcherThrowingHand = hand
              
            } else if editing == .Hitter {
                gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand = hand
            }
            snapshotEditing.objectWillChange.send()
        }
    }
}
