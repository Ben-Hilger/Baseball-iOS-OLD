// Copyright 2021-Present Benjamin Hilger

import Foundation

struct Member : Identifiable, Equatable, Hashable {
    
    var id = UUID()
    
    /// Stores the member
    var memberID : String
    
    /// Stores the first name of the member
    var firstName : String
    
    /// Stores the last name of the member
    var lastName : String
    
    /// Stores the nickname of the member
    var nickName : String
    
    /// Stores the height of the member in inches
    var height : Int
    
    /// Stores the high school of the user
    var highSchool : String
    
    /// Stores the home town of the user
    var hometown : String
    
    /// Stores the positions of the member
    var positions : [Positions] = []
    
    /// Stores the weight of the member
    var weight : Int
    
    /// Stores the bio of the member
    var bio : String
    
    /// Stores the role of the member
    var role : MemberRole
    
    /// Stores the uniform number of the member
    var uniformNumber : Int = 23
    
    var throwingHand : HandUsed
    
    var hittingHand : HandUsed
    
    var playerClass : PlayerClass = .Freshmen
    var isRedshirt : Bool = false
    
    init(withID id : String, withFirstName fN : String, withLastName lN : String, withNickname nN : String, withHeight h : Int, withHighSchool hS : String, withHometown ht : String, withPositions p : [Positions], withWeight w : Int, withBio b: String, withRole r : Int, withThrowingHands TH : HandUsed, withHittingHands HH : HandUsed) {
        memberID = id
        firstName = fN
        lastName = lN
        nickName = nN
        height  = h
        highSchool = hS
        hometown = ht
        positions = p
        weight = w
        bio = b
        role = MemberRole(rawValue: r) ?? .Unknown
        throwingHand = TH
        hittingHand = HH
    }
    
    init(withID id : String,
         withFirstName fN : String,
         withLastName lN : String,
         withNickname nN : String,
         withHeight h : Int,
         withHighSchool hS : String,
         withHometown ht : String,
         withPositions p : [Int],
         withWeight w : Int,
         withBio b: String,
         withRole r : Int,
         withThrowingHands TH : Int,
         withHittingHands HH : Int) {
        memberID = id
        firstName = fN
        lastName = lN
        nickName = nN
        height  = h
        highSchool = hS
        hometown = ht
        // Add valid positions
        for pos in p {
            if let position = Positions(rawValue: pos) {
                positions.append(position)
            }
        }
        weight = w
        bio = b
        role = MemberRole(rawValue: r) ?? .Unknown
        throwingHand = HandUsed(rawValue: TH) ?? .Switch
        hittingHand = HandUsed(rawValue: HH) ?? .Switch
    }
    
    /// Combines the users first and last name to get the full name
    /// - Returns: A string containing the members full name
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }

    func getHeight() -> String {
        return "\(height/12)\' \(height%12)\""
    }
    
    func getPositions() -> String {
        var stringPos = ""
        for pos in positions {
            stringPos += "\(pos),"
        }
        if let index = stringPos.lastIndex(of: ",") {
            return String(stringPos[...index])
        }
        return stringPos
    }
    
    func getPositionString(pos : Positions) -> String {
        switch pos {
        case .Pitcher:
            return "LHP"
        case .Catcher:
            return "Catcher"
        case .FirstBase:
            return "1B"
        case .SecondBase:
            return "2B"
        case .ThirdBase:
            return "3B"
        case .ShortStop:
            return "SS"
        case .LeftField:
            return "LF"
        case .CenterField:
            return "CF"
        case .RightField:
            return "RF"
        case .DH:
            return "DH"
        case .EH:
            return "EH"
        case .PH:
            return "PH"
        case .Bench:
            return "Bench"
        case .Unknown:
            return "Unknown"
        case .Infield:
            return "Infield"
        case .Outfield:
            return "Outfield"
        }
    }

    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.memberID == rhs.memberID
    }

}

enum MemberRole : Int {
    case Player = 0
    case Coach = 1
    case Manager = 2
    case Trainer = 3
    case Unknown = 4
    
    func getString() -> String {
        switch self {
        case .Player:
            return "Player"
        case .Coach:
            return "Coach"
        case .Manager:
            return "Manager"
        case .Trainer:
            return "Trainer"
        case .Unknown:
            return "Unkown"
        }
    }
}

enum Positions : Int, CaseIterable {
    case Pitcher = 1
    case Catcher = 2
    case FirstBase = 3
    case SecondBase = 4
    case ThirdBase = 5
    case ShortStop = 6
    case LeftField = 7
    case CenterField = 8
    case RightField = 9
    case DH = 10
    case EH = 11
    case PH = 12
    case Bench = 13
    case Unknown = 14
    case Infield = 15
    case Outfield = 16
    
    func getPositionString() -> String {
        switch self {
        case .Pitcher:
            return "P"
        case .Catcher:
            return "C"
        case .FirstBase:
            return "1B"
        case .SecondBase:
            return "2B"
        case .ThirdBase:
            return "3B"
        case .ShortStop:
            return "SS"
        case .LeftField:
            return "LF"
        case .CenterField:
            return "CF"
        case .RightField:
            return "RF"
        case .DH:
            return "DH"
        case .EH:
            return "EH"
        case .PH:
            return "PH"
        case .Bench:
            return "B"
        case .Unknown:
            return "Unknown"
        case .Infield:
            return "Infield"
        case .Outfield:
            return "Outfield"
        }
    }
}

enum PlayerClass : Int, CaseIterable {
    case Freshmen = 0
    case Sophomore = 1
    case Junior = 2
    case Senior = 3
    
    func getString() -> String {
        switch self {
        case .Freshmen:
            return "Freshmen"
        case .Sophomore:
            return "Sophomore"
        case .Junior:
            return "Junior"
        case .Senior:
            return "Senior"
        }
    }
}

struct MemberInGame : Equatable, Identifiable {
    
    var id = UUID()
    
    var member : Member
    var positionInGame : Positions

    var dh : Member?
    
    static func == (lhs : MemberInGame, rhs : MemberInGame) -> Bool {
        return lhs.member == rhs.member 
    }
}
