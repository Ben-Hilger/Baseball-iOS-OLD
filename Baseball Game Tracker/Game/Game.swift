// Copyright 2021-Present Benjamin Hilger

import Foundation

class Game : Identifiable, Equatable, ObservableObject {
    
    var id = UUID()
    
    /// Stores the unique ID of the game
    var gameID : String
    
    /// Stores the unique ID of the season the game is within
    var seasonID : String = ""
    
    /// Stores the away team ID
    var awayTeam : Team
    
    /// Stroes the home team
    var homeTeam : Team
    
    /// Stores the date of the game
    var date : Date
    
    /// Stores the city location of the game
    var city : String
    
    /// Stores the state location of the game
    var state : String
    
    /// Stores the innings of the game
    var innings : [Inning] = []
    
    /// Store the game scheduled state
    var gameScheduleState : GameScheduleState = .Scheduled
    
    init(withGameID gID : String, withAwayTeam aTeam : Team, withHomeTeam hT: Team, withDate d : Date, withCity c : String, withState s : String) {
        gameID = gID
        awayTeam = aTeam
        homeTeam = hT
        date = d
        city = c
        state = s
        innings = []
    }
    
    init(withGameID gID : String, withSeasonID sID : String, withAwayTeam aTeam : Team, withHomeTeam hT: Team, withDate d : Date, withCity c : String, withState s : String) {
        gameID = gID
        seasonID = sID
        awayTeam = aTeam
        homeTeam = hT
        date = d
        city = c
        state = s
        innings = []
    }
    
    init(withGameID gID : String, withSeasonID sID : String, withAwayTeam aTeam : Team, withHomeTeam hT: Team, withDate d : Date, withCity c : String, withState s : String, withGameSchedState schedState : GameScheduleState) {
        gameID = gID
        seasonID = sID
        awayTeam = aTeam
        homeTeam = hT
        date = d
        city = c
        state = s
        innings = []
        gameScheduleState = schedState
    }
    
    static func == (lhs : Game, rhs : Game) -> Bool {
        return lhs.gameID == rhs.gameID
    }
    
    enum CodeKeys : String, CodingKey {
        case gameID
        case seasonID
        case awayTeam
        case homeTeam
        case date
        case city
        case state
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodeKeys.self)
//        try container.encode(gameID, forKey: .gameID)
//        try container.encode(seasonID, forKey: .seasonID)
//        try container.encode(awayTeam.teamID, forKey: .awayTeam)
//        try container.encode(homeTeam.teamID, forKey: .homeTeam)
//        try container.encode(date, forKey: .date)
//        try container.encode(city, forKey: .city)
//        try container.encode(state, forKey: .state)
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodeKeys.self)
//        gameID = try container.decode(String.self, forKey: .gameID)
//        seasonID = try container.decode(String.self, forKey: .seasonID)
//        date = try container.decode(Date.self, forKey: .date)
//        city = try container.decode(String.self, forKey: .city)
//        state = try container.decode(String.self, forKey: .state)
//
//        let awayTeamID = try container.decode(String.self, forKey: .awayTeam)
//        let homeTeamID = try container.decode(String.self, forKey: .homeTeam)
//
//        var currentSeason : Season? = nil
//        for season in FirebaseMemory.getSeasonList() {
//            if season.seasonID == seasonID {
//                currentSeason = season
//            }
//        }
//
//        var awayTeam : Team?
//        var homeTeam : Team?
//        if let currentSeason = currentSeason {
//            for team in currentSeason.teams {
//                if team.teamID == awayTeamID {
//                    awayTeam = team
//                }
//                if team.teamID == homeTeamID {
//                    homeTeam = team
//                }
//            }
//            if let awayTeam = awayTeam, let homeTeam = homeTeam {
//                self.awayTeam = awayTeam
//                self.homeTeam = homeTeam
//            } else {
//                awayTeam = seasonTestData[0].teams[0]
//                homeTeam = seasonTestData[0].teams[0]
//                throw TeamLoadError.UnableToFindTeams
//            }
//        } else {
//            awayTeam = seasonTestData[0].teams[0]
//            homeTeam = seasonTestData[0].teams[0]
//            throw TeamLoadError.UnableToFindSeason
//        }
//    }
}

enum TeamLoadError : Error {
    case UnableToFindTeams
    case UnableToFindSeason
}

struct Inning: Equatable {

    var inningNum : Int
        
    var isTop : Bool
        
    var atBats : [AtBat] = []
    
//    var numberOfHits : Int = 0
//
//    var numberOfRuns : Int = 0
//
//    var numberOfErrors : Int = 0
    
    static func == (lhs: Inning, rhs: Inning) -> Bool {
        return lhs.inningNum == rhs.inningNum
    }
    
    enum CodingKeys : String, CodingKey {
        case inningNum
        case isTop
        case LOB
        case outsInInning
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(inningNum, forKey: .inningNum)
//        try container.encode(isTop, forKey: .isTop)
//        try container.encode(LOB, forKey: .LOB)
//        try container.encode(outsInInning, forKey: .outsInInning)
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        inningNum = try container.decode(Int.self, forKey: .inningNum)
//        isTop = try container.decode(Bool.self, forKey: .isTop)
//        LOB = try container.decode(Int.self, forKey: .LOB)
//        outsInInning = try container.decode(Int.self, forKey: .outsInInning)
//    }
    
}

enum GameScheduleState : Int {
    case Scheduled = 0
    case InProgress = 1
    case Finished = 2
}
