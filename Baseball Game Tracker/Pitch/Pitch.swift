// Copyright 2021-Present Benjamin Hilger

import Foundation

struct Pitch {
    
    var pitchNumber : Int
    
    var pitchType : PitchType?
    
    var pitchVelo : Float = 0
    
    var pitchLocation : PitchLocation?
    
    var pitchResult : PitchOutcome?
    
    var bipType : BIPType?
    
    var bipHit : [BIPHit] = []
    
    var pitcherThrowingHand : HandUsed
    
    var hitterHittingHand : HandUsed
    
    var hitterExitVelo : Float?
    
    var ballFieldLocation : BallFieldLocation?
    
    var pitchingStyle: PitchingStyle
    
//    var playerOnFirstBeforePitch : BaseState?
//    
//    var playerOnSecondBeforePitch : BaseState?
//    
//    var playerOnThirdBeforePitch : BaseState?
}

//    enum CodingKeys : String, CodingKey {
//        case pitchNumber
//        case numBalls
//        case numStrikes
//        case pitchType
//        case pitchVelo
//        case pitchLocation
//        case pitchResult
//        case bipType
//        case bipHit
//        case pitcherID
//        case hitterID
//        case pitcherThrowingHand
//        case hitterHittingHand
//    }
    
//    func encode(to encoder: Encoder) throws {
//        // Retrieves the proper encoder
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        // Encodes the pitch number
//        try container.encode(pitchNumber, forKey: .pitchNumber)
//        // Encodess the number of balls
//        try container.encode(numBalls, forKey: .numBalls)
//        // Encodes the number of strikes
//        try container.encode(numStrikes, forKey: .numStrikes)
//        // Encodes the type of pitch if necessary
//        try container.encodeIfPresent(pitchType?.rawValue, forKey: .pitchType)
//        // Encodes the pitch velocity if necessary
//        if pitchVelo > 0 {
//            try container.encode(pitchVelo, forKey: .pitchVelo)
//        }
//        // Encodes the pitch locations if necessary
//        if let pitchLoc = pitchLocation {
//            var locations : [Int] = []
//            for loc in pitchLoc {
//                locations.append(loc.rawValue)
//            }
//            try container.encode(locations, forKey: .pitchLocation)
//        }
//        // Encodes the pitch result if present
//        try container.encodeIfPresent(pitchResult?.rawValue, forKey: .pitchResult)
//        // Encodes the bipType if present
//        try container.encodeIfPresent(bipType?.rawValue, forKey: .bipType)
//        // Encodes the bipHit types if necessary
//        if bipHit.count > 0 {
//            var hits : [Int] = []
//            for hit in bipHit {
//                hits.append(hit.rawValue)
//            }
//            try container.encode(hits, forKey: .bipHit)
//        }
//        // Encodes the pitcherId
//        try container.encode(pitcherID, forKey: .pitcherID)
//        // Encodes the hitterID
//        try container.encode(hitterID, forKey: .hitterID)
//        // Encodes the pitcher throwing hand
//        try container.encode(pitcherThrowingHand.rawValue, forKey: .pitcherThrowingHand)
//        // Encodes the hitter throwing hand
//        try container.encode(hitterHittingHand.rawValue, forKey: .hitterHittingHand)
//    }
//
//    init(from decoder: Decoder) throws {
//        // Retrieves the proper decoder
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        // Retrieves the pitch number
//        pitchNumber = try container.decode(Int.self, forKey: .pitchNumber)
//        // Retrieves the number of balls
//        numBalls = try container.decode(Int.self, forKey: .numBalls)
//        // Retrieves the number of strikes
//        numStrikes = try container.decode(Int.self, forKey: .numStrikes)
//        // Retrieves the type of Pitch Thrown
//        pitchType = (try container.decodeIfPresent(Int.self, forKey: .pitchType)).map { (PitchType(rawValue: $0) ?? .None) }
//        // Retrieves the pitch velocity
//        pitchVelo = try container.decodeIfPresent(Float.self, forKey: .pitchVelo) ?? 0
//        // Retrieves the pitch locations
//        pitchLocation =  (try container.decodeIfPresent([Int].self, forKey: .pitchLocation)).map {
//            var pitchLocs : [PitchLocation] = []
//            for i in $0 {
//                pitchLocs.append(PitchLocation(rawValue: i) ?? .Elevated)
//            }
//            return pitchLocs
//        }
//        // Retrieves the pitch results
//        pitchResult = (try container.decodeIfPresent(Int.self, forKey: .pitchResult)).map { (PitchOutcome(rawValue: $0) ?? .IllegalPitch) }
//        // Retrieves the bip type
//        bipType = (try container.decodeIfPresent(Int.self, forKey: .bipType)).map { (BIPType(rawValue: $0) ?? .GB) }
//        // Retrieves the bip hit types
//        bipHit = (try container.decodeIfPresent([Int].self, forKey: .bipHit)).map { values -> [BIPHit] in
//            var bipHits : [BIPHit] = []
//            for i in values {
//                bipHits.append(BIPHit(rawValue: i) ?? .Error)
//            }
//            return bipHits
//        }!
//        // Retrieves the pitcher id
//        pitcherID = try container.decode(String.self, forKey: .pitcherID)
//        // Retrieves the hitter id
//        hitterID = try container.decode(String.self, forKey: .hitterID)
//        // Retireves the pitcher throwing hand
//        pitcherThrowingHand = (try container.decodeIfPresent(Int.self, forKey: .pitcherThrowingHand)).map { (HandUsed(rawValue: $0) ?? .Right) }!
//        // Retrieves the hitter's batting hand used
//        hitterHittingHand = (try container.decodeIfPresent(Int.self, forKey: .hitterHittingHand)).map { (HandUsed(rawValue: $0) ?? .Right) }!
//    }


struct PitchBuilder {
    var pitchNumber : Int
    var pitchType : PitchType?
    var pitchVelo : Float?
    var pitchLocations : PitchLocation?
    var hitterExitVelo : Float?
    var pitchOutcome : PitchOutcome?
    var pitcherID : String?
    var hitterID : String?
    var pitcherHand : HandUsed?
    var hitterHand : HandUsed?
    var bipType : BIPType?
    var bipHits : [BIPHit] = []
    var ballFieldLocation : BallFieldLocation?
    var pitchingStyle: PitchingStyle?
}

enum PitchingStyle: Int, CaseIterable {
    case Stretch = 0
    case Windup = 1
    case Unknown = 2
    
    func getString() -> String {
        switch self {
        case .Stretch:
            return "Stretch"
        case .Windup:
            return "Windup"
        case .Unknown:
            return "Unknown"
        }
    }
}

enum PitchLocation : Int, CaseIterable {
    // Main 9 zones
    case TopLeft = 1
    case TopMiddle = 2
    case TopRight = 3
    case MiddleLeft = 4
    case Middle = 5
    case MiddleRight = 6
    case LowLeft = 7
    case LowMiddle = 8
    case LowRight = 9
    
    // Top 5 zones
    case OutTopLeftCorner = 10
    case OutTopLeft = 11
    case OutTopMiddle = 12
    case OutTopRight = 13
    case OutTopRightCorner = 14
    
    // Bottom 5 zones
    case OutBottomLeftCorner = 15
    case OutBottomLeft = 16
    case OutBottomMiddle = 17
    case OutBottomRight = 18
    case OutBottomRightCorner = 19
    
    // Left 3 zones
    case OutLeftTop = 20
    case OutLeftMiddle = 21
    case OutLeftLow = 22
    
    // Right 3 zones
    case OutRightTop = 23
    case OutRightMiddle = 24
    case OutRightLow = 25
    
    func isInZone() -> Bool {
        return self.rawValue >= 1 && self.rawValue <= 9
    }
    
    func convertToMiamiPitcherNumbers(withHand hand: HandUsed) -> [Int] {
        switch self {
        case .Middle:
            return [1]
        case .MiddleLeft, .OutLeftMiddle:
            return hand == .Right ? [3] : [4]
        case .MiddleRight, .OutRightMiddle:
            return hand == .Right ? [4] : [3]
        case .TopMiddle, .OutTopMiddle:
            return [5]
        case .LowMiddle, .OutBottomMiddle:
            return [2]
        case .LowLeft, .OutBottomLeft, .OutLeftLow, .OutBottomLeftCorner:
            return hand == .Right ? [2, 3] : [4, 2]
        case .LowRight, .OutBottomRight, .OutBottomRightCorner, .OutRightLow:
            return hand == .Right ? [4, 2] : [2, 3]
        case .TopRight, .OutTopRight, .OutTopRightCorner, .OutRightTop:
            return hand == .Right ? [5, 4] : [5, 3]
        case .TopLeft, .OutTopLeftCorner, .OutTopLeft, .OutLeftTop:
            return hand == .Right ? [5, 3] : [5, 4]
        }
    }
}

enum HandUsed : Int, CaseIterable {
    case Left = 0
    case Right = 1
    case Switch = 2
    case NA = 3
    
    func getString() -> String {
        switch self {
        case .Left:
            return "Left"
        case .Right:
            return "Right"
        case .Switch:
            return "Switch"
        case .NA:
            return "N/A"
        }
    }
}
