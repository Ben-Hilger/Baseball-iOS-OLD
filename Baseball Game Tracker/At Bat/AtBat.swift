// Copyright 2021-Present Benjamin Hilger

import Foundation

struct AtBat : Equatable {
    
    var atBatID : String
    
    var pitcherID : [String]
    
    var hitterID : [String]
    
    var numberInInning : Int
        
    //var pitches : [Pitch] = []
    
    // var numRBIs : Int = 0
    
    static func == (lhs : AtBat, rhs : AtBat) -> Bool {
        return lhs.atBatID == rhs.atBatID
    }
    
    enum CodingKeys : String, CodingKey {
        case atBatID
        case pitcherID
        case hitterID
        case numberInInning
        case numRBIs
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        // Encodes the AtBat ID
//        try container.encode(atBatID, forKey: .atBatID)
//        // Encodes the Pitcher ID
//        try container.encode(pitcherID, forKey: .pitcherID)
//        // Encodes the HitterID
//        try container.encode(hitterID, forKey: .hitterID)
//        // Encodes the Number in Inning
//        try container.encode(numberInInning, forKey: .numberInInning)
//        // Encodes the number of RBIs
//        try container.encode(numRBIs, forKey: .numRBIs)
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        // Gets the atBatId
//        atBatID = try container.decode(String.self, forKey: .atBatID)
//        // Gets the list of pitchers
//        pitcherID = try container.decode([String].self, forKey: .pitcherID)
//        // Gets the list of hitters
//        hitterID = try container.decode([String].self, forKey: .hitterID)
//        // Gets the numberInInning
//        numberInInning = try container.decode(Int.self, forKey: .numberInInning)
//        // Gets the number of RBIs
//        numRBIs = try container.decode(Int.self, forKey: .numRBIs)
//    }
}

enum AtBatOutcome : Int {
    case KCalled = 0
    case KSwinging = 1
    case BIPOut = 2
    case BIPSac = 3
    case BIPHit = 4
    case Walk = 5
    case WalkIntentional = 6
    case HBP = 7
    case CatcherInterference = 8
    case OutonBasepath = 9
}

enum BallFieldLocation : Int {
    case HRLeftField = 0
    case HRLeftCenterField = 1
    case HRCenterField = 2
    case HRRightCenterField = 3
    case HRRightField = 4
    
    case DeepLeftField = 5
    case DeepLeftCenterField = 6
    case DeepCenterField = 7
    case DeepRightCenterField = 8
    case DeepRightField = 9
    
    case LeftField = 10
    case LeftCenterField = 11
    case CenterField = 12
    case RightCenterField = 13
    case RightField = 14
    
    case ShallowLeftField = 15
    case ShallowLeftCenterField = 16
    case ShallowCenterField = 17
    case ShallowRightCenterField = 18
    case ShallowRightField = 19
    
    case Pitcher = 31
    
    case Catcher = 33
    case CatcherFair = 38

    case DeepThirdBaseFoul = 34
    case ShallowThirdBaseFoul = 35
    case DeepFirstBaseFoul = 36
    case ShallowFirstBaseFoul = 37
    
    case ThirdBase = 25
    case ShallowThirdBase = 30
    case DeepThirdBase = 20

    case ShortStop = 26
    case DeepShortStop = 21
    
    case UpTheMiddle = 27
    case DeepUpTheMiddle = 22
    
    case SecondBase = 28
    case DeepSecondBase = 23
    
    case DeepFirstBase = 24
    case ShallowFirstBase = 32
    case FirstBase = 29
    
    case ThirdShortStop = 39
    case ShortStopMiddle = 40
    case MiddleSecond = 42
    case SecondFirst = 41
    
    func getShortDescription() -> String {
        switch self {
        case .ShallowLeftField:
            return "7-1"
        case .LeftField:
            return "7-2"
        case .DeepLeftField:
            return "7-3"
        case .HRLeftField:
            return "7-4"
            
        case .ShallowCenterField:
            return "8-1"
        case .CenterField:
            return "8-2"
        case .DeepCenterField:
            return "8-3"
        case .HRCenterField:
            return "8-4"
            
        case .ShallowRightField:
            return "9-1"
        case .RightField:
            return "9-2"
        case .DeepRightField:
            return "9-3"
        case .HRRightField:
            return "9-4"
            
        case .ShallowLeftCenterField:
            return "78-1"
        case .LeftCenterField:
            return "78-2"
        case .DeepLeftCenterField:
            return "78-3"
        case .HRLeftCenterField:
            return "78-4"
            
        case .ShallowRightCenterField:
            return "89-1"
        case .RightCenterField:
            return "89-2"
        case .DeepRightCenterField:
            return "89-3"
        case .HRRightCenterField:
            return "89-4"
            
        case .ShallowThirdBase:
            return "5-1"
        case .ThirdBase:
            return "5-2"
        case .DeepThirdBase:
            return "5-3"
            
        case .DeepShortStop:
            return "6-2"
        case .ShortStop:
            return "6-1"
            
        case .DeepUpTheMiddle:
            return "1-3"
        case .UpTheMiddle:
            return "1-2"
        case .Pitcher:
            return "1-1"
            
        case .DeepSecondBase:
            return "4-2"
        case .SecondBase:
            return "4-1"
            
        case .DeepFirstBase:
            return "3-3"
        case .FirstBase:
            return "3-2"
        case .ShallowFirstBase:
            return "3-1"
            
        case .ThirdShortStop:
            return "56-1"
        case .ShortStopMiddle:
            return "61-1"
        case .MiddleSecond:
            return "14-1"
        case .SecondFirst:
            return "43-1"
            
        case .DeepThirdBaseFoul:
            return "F7"
        case .ShallowThirdBaseFoul:
            return "F5"
        case .DeepFirstBaseFoul:
            return "F9"
        case .ShallowFirstBaseFoul:
            return "F3"
            
        case .Catcher:
            return "2-2"
        case .CatcherFair:
            return "2-1"
        }
    }

    
}
