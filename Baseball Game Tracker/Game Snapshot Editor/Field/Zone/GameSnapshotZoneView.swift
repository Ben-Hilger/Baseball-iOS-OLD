// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotZoneView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    var location : BallFieldLocation
    
    var widthModifier : CGFloat
    var heightModidfer : CGFloat
    
    var body: some View {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
            GeometryReader { (geometry) in
                Text("\(location.getShortDescription())")
                    .position(x: geometry.size.width * widthModifier, y: geometry.size.height * heightModidfer)
                    .foregroundColor(gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.ballLocation == location ? Color.yellow : location.rawValue >= 5 ? Color.white : Color.black).onTapGesture {
                        if let position = gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.ballLocation, position == location {
                            gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.ballLocation = nil
                            gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.ballFieldLocation = nil
                        } else {
                            gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.ballLocation = location
                            gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.ballFieldLocation = location
                        }
                        gameSnapshotViewModel.objectWillChange.send()
                    }
            }
        }
    }
}
