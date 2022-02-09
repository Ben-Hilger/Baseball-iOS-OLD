// Copyright 2021-Present Benjamin Hilger

import Foundation

struct SummaryStats : Equatable {
  
    var member : Member
    var gamesPlayed : [GameSummaryStats] = []

    static func == (lhs: SummaryStats, rhs: SummaryStats) -> Bool {
        return lhs.member == rhs.member
    }
}

struct GameSummaryStats {
    
    var dateOfGame : Date
    var zones : [ZoneData] = []
    
    var numPA : Int
    var numWalks : Int
    var numHBP : Int
    var numSacFly : Int
    var numSacBunt : Int
    var numAtBats : Int
}

struct ZoneData {
    
    var zone : Int
    var num1B : Int
    var num2B : Int
    var num3B : Int
    var numBABIP : Int
    var numBIP : Int
    var numHR : Int
    var numHit : Int
    var numSM : Int
    var numCS : Int
    var numFoulBall : Int
    var numBalls : Int
    var numBallsWildPitch : Int
    var numBallssPassedBall : Int

}
