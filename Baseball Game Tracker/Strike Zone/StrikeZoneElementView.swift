// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct StrikeZoneElementView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var pitchLocationsToAdd : PitchLocation? = nil
    
    var width : CGFloat
    var height : CGFloat
    
    // Store if the zone should be filled
    var shouldFill : Bool = true
    // Store if it should show the border
    var shouldShowBorder : Bool = true
    var body: some View {
        Rectangle()
            .if(shouldFill, transform: {
                $0.fill(getColor())
            })
            .if(isMainZone() && shouldShowBorder, transform: {
                $0.border(getCurrentTeamPrimaryColor(), width: 3)
            })
            .frame(width: width, height: height)
            .opacity(0.5)
            .padding(0)
            .onTapGesture {
                if pitchLocationsToAdd != nil {
                    setPitchLocation()
                }
            }
    }
    
    func getColor() -> Color {
        return eventViewModel.pitchEventInfo?.pitchLocations
            == pitchLocationsToAdd && gameViewModel.currentInning != nil &&
            gameViewModel.game != nil ?
            getCurrentTeamPrimaryColor() : Color.white
    }
    
    func getCurrentTeamPrimaryColor() -> Color {
        return gameViewModel.currentInning!.isTop ?
            gameViewModel.game!.homeTeam.teamPrimaryColor :
            gameViewModel.game!.awayTeam.teamPrimaryColor
    }
    
    func isMainZone() -> Bool {
        if let pitchLocationsToAdd = pitchLocationsToAdd {
            return pitchLocationsToAdd.rawValue >=
                PitchLocation.TopLeft.rawValue &&
                pitchLocationsToAdd.rawValue <= PitchLocation.LowRight.rawValue
        }
        return false
    }
    
    func setPitchLocation() {
        eventViewModel.pitchEventInfo?.pitchLocations = pitchLocationsToAdd
    }
}
