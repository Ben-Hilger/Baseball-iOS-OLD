// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotFieldEditView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var body: some View {
        VStack {
            FieldAccessoryView()
                .environmentObject(gameViewModel)
            HStack {
                Text("Ball Landing Zone")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .border(gameSnapshotViewModel.snapshotFieldEditMode == .BallZone ? Color.blue : Color.black, width: 3)
                    .foregroundColor(gameSnapshotViewModel.snapshotFieldEditMode == .BallZone ? Color.blue : Color.black)
                    .onTapGesture {
                        gameSnapshotViewModel.snapshotFieldEditMode = .BallZone
                    }
            
//                Button(action: {}, label: {
//                    Text("Fielder Sequence")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .border(Color.blue, width: 3)
//                        .border(gameSnapshotViewModel.snapshotFieldEditMode == .PlayerSequence ? Color.blue : Color.black, width: 3)
//                        .foregroundColor(gameSnapshotViewModel.snapshotFieldEditMode == .PlayerSequence ? Color.blue : Color.black)
//                        .onTapGesture {
//                            gameSnapshotViewModel.snapshotFieldEditMode = .PlayerSequence
//                        }
//                })
            }.padding()
            ZStack {
                GeometryReader { (geometry) in
                    Image("baseball-field")
                        .resizable()
                    if gameSnapshotViewModel.snapshotFieldEditMode == .PlayerSequence {
                        GameSnapshotPositionView()
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                            .environmentObject(settingsViewModel)
                    } else if gameSnapshotViewModel.snapshotFieldEditMode == .BallZone {
                        GameSnapshotFieldZoneView()
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                    }
                    
                }
            }
        }
    }
}

enum GameSnapshotFieldEditType {
    case BallZone
    case PlayerSequence
}
