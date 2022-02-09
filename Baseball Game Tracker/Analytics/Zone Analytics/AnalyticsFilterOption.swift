//
//  AnalyticsFilterOption.swift
//  MU baseball game tracker
//
//  Created by Benjamin Hilger on 2/5/21.
//

import Foundation

struct AnalyticsFilterOptions {
    
    var pitchThrown : PitchType? = nil
    
    var pitcher : MemberInGame? =  nil
    
    var hitter : MemberInGame? = nil
    
    var strikeZone : PitchLocation? = nil
    
    var withPlayerOnFirst : Bool? = nil
    
    var withPlayerOnSecond : Bool? = nil
    
    var withPlayerOnThird : Bool? = nil

    var ballFieldLoc : BallFieldLocation? = nil
    
    var numberBalls : Int? = nil
    
    var numberStrikes : Int? = nil
    
    var pitcherHand: HandUsed? = nil
    
    var team : GameTeamType? = nil
    
    /// Checks if the designated pitch checks against the filter options
    ///  Current Filter Options:
    ///  * Pitcher
    ///  * Pitch Thrown
    ///  * Strike Zone Location
    ///  * Ball Field Location
    ///  * Player on First, Second or Third
    /// - Parameters:
    ///   - pitch: The pitch to check against the filter
    ///   - analyticsOptions: The filter options to use to check against the pitch
    /// - Returns: True if it passes the filter, false otherwise
    func passesFilter (withGameInformation gameInfo : GameSnapshot,
                       withPitch pitch: Pitch,
                       withPrevStrikeCount strikes: Int,
                       withPrevBallCount balls: Int)
    -> Bool {
//        if hitter?.member.memberID == gameInfo.eventViewModel.hitterID {
//            print("HITTER FOUND")
//        }
//        print("\(pitch.pitcherThrowingHand.getString()) - \(pitcherHand?.getString()) - \(pitchThrown) \(pitch.pitchType)")
//        
//        if pitch.pitcherThrowingHand == pitcherHand {
//            print("PITCHER THROWING HAAND OUND")
//        }
//
//        if gameInfo.eventViewModel.pitchEventInfo?.completedPitch?.pitchType == pitchThrown {
//            print("Pitch thrown found")
//        }
//        
//        if hitter?.member.memberID == gameInfo.eventViewModel.hitterID,
//           pitch.pitcherThrowingHand == pitcherHand {
//            print("BOTH BOTH FOUND")
//        }
        
        return (pitchThrown == nil ? true : pitch.pitchType ==
                pitchThrown) &&
            (pitcher == nil ? true : gameInfo.eventViewModel.pitcherID ==
                pitcher?.member.memberID) &&
            (strikeZone == nil ? true : pitch.pitchLocation ==
                strikeZone) &&
            (ballFieldLoc == nil ? true :
                pitch.ballFieldLocation ==
                ballFieldLoc) &&
            (withPlayerOnFirst == nil ? true :
                withPlayerOnFirst ?? false ?
                gameInfo.eventViewModel.playerAtFirstAfter != nil :
                gameInfo.eventViewModel.playerAtFirstAfter == nil) &&
            (withPlayerOnSecond == nil ? true :
                withPlayerOnSecond ?? false ?
                gameInfo.eventViewModel.playerAtSecondAfter != nil :
                gameInfo.eventViewModel.playerAtSecondAfter == nil) &&
            (withPlayerOnThird == nil ? true :
                withPlayerOnThird ?? false ?
                gameInfo.eventViewModel.playerAtThirdAfter != nil :
                gameInfo.eventViewModel.playerAtThirdAfter == nil) &&
            (numberBalls == nil ? true : balls ==
                numberBalls) &&
            (numberStrikes == nil ? true :
                strikes == numberStrikes) &&
            (hitter == nil ? true : gameInfo.eventViewModel.hitterID ==
                hitter?.member.memberID) &&
            (pitcherHand == nil ? true :
                pitcherHand == pitch.pitcherThrowingHand) &&
            (team == nil ? true : team ==
                (gameInfo.currentInning?.isTop ?? false ? .Away : .Home))
    }
}
