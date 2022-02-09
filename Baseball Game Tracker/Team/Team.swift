// Copyright 2021-Present Benjamin Hilger

import Foundation
import SwiftUI

class Team : Identifiable, Equatable, ObservableObject {
    
    @Published var id = UUID()
    
    /// Stores the teams name
    @Published var teamName : String
    
    /// Stores the teams unique ID
    @Published var teamID : String
    
    /// Stores the teams abbreviation
    @Published var teamAbbr : String
    
    /// Stores the teams nickname
    @Published var teamNickname : String
    
    /// Stores the teams city
    @Published var cityLocation : String
    
    /// Stores the teams state
    @Published var stateLocation : String
    
    /// Stores the conference of the team
    @Published var conference : ConferenceType
    
    /// Stores the division of the team
    @Published var teamType : TeamType
    
    /// Stores the primary color of the team
    @Published var teamPrimaryColor : Color
    
    /// Stores the secondary color of the team
    @Published var teamSecondaryColor : Color

    /// Stores the members of the team
    @Published var members : [Member]
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.teamID == rhs.teamID
    }

    init(teamID id : String, teamName tN : String, teamAbbr tA : String, teamNickname tNick : String, city : String, state : String, conference : Int, type : Int, colorPrimary : Color, colorSecondary : Color) {
        teamID = id
        teamName = tN
        teamAbbr = tA
        teamNickname = tNick
        cityLocation = city
        stateLocation = state
        self.conference = ConferenceType(rawValue: conference) ?? .NA
        self.teamType = TeamType(rawValue: type) ?? .Scrimmage
        teamPrimaryColor = colorPrimary
        teamSecondaryColor = colorSecondary
        members = []
    }
    
    init(teamID id : String, teamName tN : String, teamAbbr tA : String, teamNickname tNick : String, city : String, state : String, conference : Int, type : Int, colorPrimary : Color, colorSecondary : Color, withMembers m : [Member]) {
        teamID = id
        teamName = tN
        teamAbbr = tA
        teamNickname = tNick
        cityLocation = city
        stateLocation = state
        self.conference = ConferenceType(rawValue: conference) ?? .NA
        self.teamType = TeamType(rawValue: type) ?? .Scrimmage
        teamPrimaryColor = colorPrimary
        teamSecondaryColor = colorSecondary
        members = m
    }
    
    func getTypeString() -> String {
        switch teamType {
        case .Scrimmage:
            return "Scrimmage"
        case .D1:
            return "D1"
        case .D2:
            return "D2"
        case .D3:
            return "D3"
        case .JUCO:
            return "JUCO"
        }
    }
    
    func getConferenceString() -> String {
        switch conference {
        case .NA:
            return "N/A"
        case .Big10:
            return "Big 10"
        case .Big12:
            return "Big 12"
        case .BigEast:
            return "Big East"
        case .BigSouth:
            return "Big South"
        case .HorizonLeague:
            return "Horizon League"
        case .MAC:
            return "MAC"
        case .MVC:
            return "MVC"
        case .OVC:
            return "OVC"
        case .SummitLeague:
            return "Summit League"
        case .AthleticSun:
            return "Athletic Sun Conference"
        case .USA:
            return "USA"
        case .SunBelt:
            return "Sun Belt"
        case .Atlantic10Conference:
            return "Atlantic 10 Conference"
        }
    }
}

enum ConferenceType : Int, CaseIterable {
    case NA = 0
    case Big10 = 1
    case Big12 = 2
    case BigEast = 3
    case BigSouth = 4
    case HorizonLeague = 5
    case MAC = 6
    case MVC = 7
    case OVC = 8
    case SummitLeague = 9
    case AthleticSun = 10
    case USA = 11
    case SunBelt = 12
    case Atlantic10Conference = 13
    func getString() -> String {
        switch self {
        case .NA:
            return "N/A"
        case .Big10:
            return "Big 10"
        case .Big12:
            return "Big 12"
        case .BigEast:
            return "Big East"
        case .BigSouth:
            return "Big South"
        case .HorizonLeague:
            return "Horizon League"
        case .MAC:
            return "MAC"
        case .MVC:
            return "MVC"
        case .OVC:
            return "OVC"
        case .SummitLeague:
            return "Summit League"
        case .AthleticSun:
            return "Athletic Sun Conference"
        case .USA:
            return "USA"
        case .SunBelt:
            return "Sun Belt"
        case .Atlantic10Conference:
            return "Atlantic 10 Conference"
        }
    }
}

enum TeamType : Int, CaseIterable {
    case Scrimmage = 0
    case D1 = 1
    case D2 = 2
    case D3 = 3
    case JUCO = 4
    
    func getString() -> String {
        switch self {
        case .Scrimmage:
            return "Scrimmage"
        case .D1:
            return "D1"
        case .D2:
            return "D2"
        case .D3:
            return "D3"
        case .JUCO:
            return "JUCO"
        }
    }
}

