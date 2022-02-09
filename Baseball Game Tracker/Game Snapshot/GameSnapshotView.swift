// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotView: View {
    
    // Store the game view model
    @EnvironmentObject var gameViewModel : GameViewModel
    // Store the current settings
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    // Store information about the selected snapshot
    @State var gameSnapshotSelected : GameSnapshotViewModel =
        GameSnapshotViewModel()
    
    // Store if the user is viewing the options
    @State var isViewingSnapshotOptions : Bool = false
    // Store if the view is viewing the detailed editor sheet
    @State var isViewingGameSnapshotEditView : Bool = false
    // Store if the user is selecting a different inning to view
    @State var selectInningAlertSheet : Bool = false
    
    // Store the at bat results
    @State var atBatResults : [GameSnapshotCellInfo] = []
    
    var body: some View {
        VStack {
            HStack {
                // Undo Button
                Button(action: {
                    gameViewModel.undo()
                }, label: {
                    Text("Undo")
                })
                // Title
                Text("Game History")
                    .padding()
                    .multilineTextAlignment(.center)
                // Redo button
                Button(action: {
                    gameViewModel.redo()
                }, label: {
                    Text("Redo")
                })
            }
            // Button to show the current inning that's being viewed
            Text("Inning Viewing: \(settingsViewModel.inningToViewHistory)")
                // Action sheet to allow the user to select the inning
                // Toggled view by if the user clicks on this text
                .actionSheet(isPresented: $selectInningAlertSheet, content: {
                    ActionSheet(title: Text("Select Inning to View"), buttons:
                                    // Generates a list of the available
                                    // innings
                                    generateInningSelection())
                }).onTapGesture {
                    // Toggles the inning action sheet
                    selectInningAlertSheet = true
                }
                .foregroundColor(.blue)
                .padding()
                .border(Color.blue)
            // Displays a list of the snapshots in the selected inning
            List {
                // Explores the at bat results
                ForEach(0..<atBatResults.count, id: \.self) { result in
                    GameSnapshotViewCell(result: atBatResults[result])
                        .environmentObject(gameSnapshotSelected)
                        .environmentObject(gameViewModel)
                        .environmentObject(settingsViewModel)
                        
                }
            }.border(Color.black, width: 1)
            .onReceive(gameViewModel.$gameSnapshots, perform: { _ in
                // Gets the at bat results when the screen loads
                atBatResults = gameSnapshotSelected.getAtBatResults(
                    fromGameViewModel: gameViewModel,
                    fromInning: settingsViewModel.inningToViewHistory)
            }).onReceive(gameViewModel.$snapShotIndex, perform: { _ in
                atBatResults = gameSnapshotSelected.getAtBatResults(
                    fromGameViewModel: gameViewModel,
                    fromInning: settingsViewModel.inningToViewHistory)
            }).onReceive(gameSnapshotSelected.$atBatSelected, perform: { _ in
                atBatResults = gameSnapshotSelected.getAtBatResults(
                    fromGameViewModel: gameViewModel,
                    fromInning: settingsViewModel.inningToViewHistory)
            }).onChange(of: settingsViewModel.inningToViewHistory, perform: { _ in
                atBatResults = gameSnapshotSelected.getAtBatResults(
                    fromGameViewModel: gameViewModel,
                    fromInning: settingsViewModel.inningToViewHistory)
            })
            .onAppear {
                // Gets the at bat results when the screen loads
                atBatResults = gameSnapshotSelected.getAtBatResults(
                    fromGameViewModel: gameViewModel,
                    fromInning: settingsViewModel.inningToViewHistory)
            }
            // Remove navigaton bar
            .navigationBarTitle("").navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func generateInningSelection() -> [Alert.Button] {
        // Store the buttons
        var buttons : [Alert.Button] = []
    
        // Navigate all of the current innings
        // number of innings + extra innings (if necesssary)
        for index in 0..<Int(settingsViewModel.numberOfInnings) {
            // Add button to change to the specified inning
            buttons.append(Alert.Button.default(Text("\(index+1)"), action: {
                settingsViewModel.inningToViewHistory = index+1
            }))
        }
        // Return the buttons
        return buttons
    }
}

struct GameSnapshotViewCell: View {
    
    // Store the game snapshot view model
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    // Store the game snapshot cell to view
    var result : GameSnapshotCellInfo
    
    // Track if the detailed editor is being shown
    @State var isViewingGameSnapshotEditView : Bool = false
    
    var body : some View {
        // Check if there is a valid at bat result
        if let atBatResult = result.atBatResultInfo {
            Text(atBatResult)
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .border(Color.black)
                .onTapGesture {
                    gameSnapshotViewModel.atBatSelected = gameSnapshotViewModel.atBatSelected == result.atBatID ? nil : result.atBatID
                }
        } else {
            VStack {
                VStack {
                    ForEach(result.homeLineupChanges) { change in
                        Text("\(change.positionInGame.getPositionString())")
                            .font(.system(size: 12))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(3)
                    }
                    ForEach(result.awayLineupChanges) { change in
                        Text("\(change.positionInGame.getPositionString())")
                            .font(.system(size: 12))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(3)
                    }
                }
                VStack {
                    if let pitchType = result.pitchType {
                        HStack {
                            Text(pitchType)
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 12))
                                .padding(1)
                        }
                    }
                    HStack {
                        Text("\(result.pitchNumber ?? 0)")
                            .font(.system(size: 12))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(3)
                            .overlay(Circle()
                                    .stroke(getCircleColor(), lineWidth: 5))
                        Text(result.pitchResult?.getPitchOutcomeString() ?? "")
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                    }
                    if let velo = result.pitchVelo, velo != -1 {
                        HStack {
                            Text("\(Int(velo)) MPH")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 12))
                                .padding(1)
                        }
                    }
                }.padding().border(Color.black).onTapGesture {
                    // Get the snapsoht index's that are apart of
                    // the at bat
                    gameSnapshotViewModel.gameSnapshotIndex =
                        result.snapshotIndex
                    // Set the default (first) snapshot in the at bat
                    gameSnapshotViewModel.gameSnapshotIndexSelected = result.snapshotIndex?[0]
                    // View the detailed snapshot editor
                    self.isViewingGameSnapshotEditView = true
                }.sheet(isPresented: $isViewingGameSnapshotEditView, content: {
                    // Detailed Snapshot Editor view sheet
                    GameSnapshotEditTab()
                        .environmentObject(gameSnapshotViewModel)
                        .environmentObject(gameViewModel)
                        .environmentObject(settingsViewModel)
                })
            }
        }
        if result.numOuts == 3 {
            Divider()
        }
    }
    
    func getCircleColor() -> Color {
        if let result = result.pitchResult {
            switch result {
            case .Ball, .BallWildPitch, .BallPassedBall, .PitchOutBall:
                return Color.green
            case .StrikeCalled, .StrikeSwingMiss, .PassedBallStrikeSwinging, .WildPitchStrikeSwinging,
                 .DroppedThirdLookingOut, .DroppedThirdLookingSafe, .DroppedThirdSwingingOut, .DroppedThirdSwingingSafe, .DroppedThirdLookingSafePassedBall, .DroppedThirdSwingingSafePassedBall, .PitchOutSwinging, .PitchOutLooking, .WildPitchStrikeLooking, .PassedBallStrikeLooking:
                return Color.red
            case .FoulBall, .HBP, .Balk, .IntentionalBall, .IllegalPitch,
                 .BatterInter, .CatcherInter, .FoulBallDropped:
                return Color.gray
            case .BIP:
                return Color.blue
            case .StrikeForce, .BallForce:
                return Color.yellow
            }
        }
        return Color.black
        
    }
}
