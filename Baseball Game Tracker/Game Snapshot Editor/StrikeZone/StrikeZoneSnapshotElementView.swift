// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct StrikeZoneSnapshotElementView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    var pitchLocationsToAdd : PitchLocation
    
    var width : CGFloat
    var height : CGFloat
    
    var body: some View {
        Rectangle()
            //.if(isSelected(), transform: {
            .fill(getFillColor())
            //})
            // Check if the zone is one of the main 9 zones
            .if(isMainZone(), transform: {
                // Set the border to help visually identify the zone
                $0.border(getColor(), width: 3)
            })
            // Set the frame width and height
            .frame(width: width, height: height)
            // Set the opacity
            .opacity(0.5)
            // Ensure no padding on all sides
            .padding(0)
            // Set the tap action
            .onTapGesture {
                // Set the selected pitch location to this zone
                setPitchLocation()
            }
    }
    
    func getColor() -> Color {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
            return gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.pitchLocations
                == pitchLocationsToAdd && gameViewModel.currentInning != nil && gameViewModel.game != nil ?
                getCurrentTeamPrimaryColor() : Color.white
        }
        return Color.black
    }
    
    func getFillColor() -> Color {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
            if  gameViewModel.gameSnapshots[index].eventViewModel
                    .pitchEventInfo?.pitchLocations == pitchLocationsToAdd &&
                    gameViewModel.currentInning != nil &&
                    gameViewModel.game != nil {
                return getCurrentTeamPrimaryColor()
            }
        }
        return Color.gray
    }
    
    func getCurrentTeamPrimaryColor() -> Color {
        return gameViewModel.currentInning!.isTop ? gameViewModel.game!.homeTeam.teamPrimaryColor : gameViewModel.game!.awayTeam.teamPrimaryColor
    }
    
    func isSelected() -> Bool {
        if let currentIndex = gameSnapshotViewModel.gameSnapshotIndexSelected {
            if gameViewModel.gameSnapshots[currentIndex].eventViewModel.pitchEventInfo?.completedPitch?.pitchLocation == pitchLocationsToAdd {
                return true
            }
        }
        return false
    }
    
    func isMainZone() -> Bool {
        return pitchLocationsToAdd.rawValue >= PitchLocation.TopLeft.rawValue &&
            pitchLocationsToAdd.rawValue <= PitchLocation.LowRight.rawValue
    }
    
    func setPitchLocation() {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
            gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.pitchLocations =
                pitchLocationsToAdd
            gameViewModel.gameSnapshots[index].eventViewModel.pitchEventInfo?.completedPitch?.pitchLocation =
                pitchLocationsToAdd
            gameSnapshotViewModel.objectWillChange.send()
        }
        
    }
}
