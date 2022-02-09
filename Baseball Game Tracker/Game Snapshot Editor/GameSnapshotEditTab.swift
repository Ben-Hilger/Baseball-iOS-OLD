// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotEditTab: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text("Events")
                        .padding()
                        .frame(maxWidth: .infinity)
                    List {
                        ForEach(gameSnapshotViewModel.gameSnapshotIndex!.indices, id: \.self) { index in
                            if let pitch = gameViewModel.gameSnapshots[gameSnapshotViewModel.gameSnapshotIndex![index]].eventViewModel.pitchEventInfo?.completedPitch {
                                Text("\(pitch.pitchType?.getPitchTypeString() ?? "Pitch #\(index+1)")")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .if(gameSnapshotViewModel.gameSnapshotIndexSelected == gameSnapshotViewModel.gameSnapshotIndex![index]) {
                                        $0.border(Color.black, width: 3)
                                    }.onTapGesture {
                                        gameSnapshotViewModel.gameSnapshotIndexSelected = gameSnapshotViewModel.gameSnapshotIndex![index]
                                    }
                            } else {
                                Text("Base Event")
                            }
                        }
                    }
                }.frame(maxWidth: geometry.size.width*0.3).border(Color.black)
                VStack {
                    TabView {
                        GameSnapshotEditView()
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                            .tabItem { Text("Event Information") }
//                        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.selectedPitchOutcome == .BIP {
//                            GameSnapshotFieldEditView().environmentObject(gameViewModel)
//                                .environmentObject(gameSnapshotViewModel)
//                                .environmentObject(settingsViewModel)
//                                .frame(height: geometry.size.height * 0.75)
//                                .tabItem { Text("Field Edit") }
//                        }
                        if let fieldEditView = needsFieldEdit() {
                            fieldEditView.environmentObject(gameViewModel)
                                .environmentObject(gameSnapshotViewModel)
                                .environmentObject(settingsViewModel)
                                .frame(height: geometry.size.height * 0.75)
                                .tabItem { Text("Field Edit") }
                        }
                        if let strikeZone = needsStrikeZoneView() {
                            strikeZone
                                .environmentObject(gameViewModel)
                                .environmentObject(gameSnapshotViewModel)
                                .tabItem { Text("Strike Zone") }
                        }
//                        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.pitchLocations != nil {
//                            StrikeZoneSnapshotEditView()
//                                .environmentObject(gameViewModel)
//                                .environmentObject(gameSnapshotViewModel)
//                        }
                    }.onDisappear {
                        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
                            GameSnapshotSaveManagement.updateGameSnapshot(snapshotToUpdate: gameViewModel.gameSnapshots[index])
                        }
                    }
                    if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
                        Button(action: {
                            GameSnapshotSaveManagement.updateGameSnapshot(snapshotToUpdate: gameViewModel.gameSnapshots[index])
                        }, label: {
                            Text("Save")
                                .padding()
                                .frame(maxWidth: .infinity)
                        })
                    }
                    
                }
            }
        }
    }
    
    func needsFieldEdit() -> GameSnapshotFieldEditView? {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.selectedPitchOutcome == .BIP {
            return GameSnapshotFieldEditView()
        }
        return nil
    }
    
    func needsStrikeZoneView() -> StrikeZoneSnapshotEditView? {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.pitchLocations != nil {
            return StrikeZoneSnapshotEditView()
        }
        return nil
    }
}
