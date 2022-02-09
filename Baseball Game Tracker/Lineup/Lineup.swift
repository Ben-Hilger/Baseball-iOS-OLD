// Copyright 2021-Present Benjamin Hilger

import Foundation

struct Lineup : Equatable {
   
    var currentHomeTeamLineup : [MemberInGame]
    var totalHomeTeamRoster : [MemberInGame]
    var hiddenHomeTeam : [MemberInGame] = []
    
    var curentAwayTeamLineup : [MemberInGame]
    var totalAwayTeamRoster : [MemberInGame]
    
    var hiddenAwayTeam : [MemberInGame] = []
    
    var lineupChanges : [LineupChange] = []
    
    mutating func updateLineup(withHomeTeamLineup hTL : [MemberInGame], withAwayTeamLineup atL : [MemberInGame], atCurrentPitch pitchNum : Int) -> LineupChange {
        let newChange = LineupChange(prevHomeTeamLineup: currentHomeTeamLineup,
                                     prevAwayTeamLineup: curentAwayTeamLineup,
                                     newHomeTeamLineup: hTL,
                                     newAwayTeamLineup: atL,
                                     pitchNumChanged: pitchNum)
        lineupChanges.append(newChange)
        
        for member in currentHomeTeamLineup {
            if let index = totalHomeTeamRoster.firstIndex(of: member) {
                totalHomeTeamRoster[index].positionInGame = .Bench
            }
        }
        
        for member in curentAwayTeamLineup {
            if let index = totalAwayTeamRoster.firstIndex(of: member) {
                totalAwayTeamRoster[index].positionInGame = .Bench
            }
        }
        
        currentHomeTeamLineup = hTL
        curentAwayTeamLineup = atL
        
        for member in currentHomeTeamLineup {
            if let index = totalHomeTeamRoster.firstIndex(of: member) {
                totalHomeTeamRoster[index].positionInGame = member.positionInGame
                if let dh = member.dh, let dhIndex = totalHomeTeamRoster.firstIndex(of: MemberInGame(member: dh, positionInGame: .DH)) {
                    totalHomeTeamRoster[dhIndex].positionInGame = .DH
                }
            }
        }
        
        for member in curentAwayTeamLineup {
            if let index = totalAwayTeamRoster.firstIndex(of: member) {
                totalAwayTeamRoster[index].positionInGame = member.positionInGame
                if let dh = member.dh, let dhIndex = totalAwayTeamRoster.firstIndex(of: MemberInGame(member: dh, positionInGame: .DH)) {
                    totalAwayTeamRoster[dhIndex].positionInGame = .DH
                }
            }
        }
        return newChange
    }
    
    
    init(withAwayMembers awayMembers : [Member], withHomeMembers homeMembers : [Member]) {
        currentHomeTeamLineup = []
        curentAwayTeamLineup = []
        totalHomeTeamRoster = []
        totalAwayTeamRoster = []
        for member in awayMembers {
            totalAwayTeamRoster.append(MemberInGame(member: member, positionInGame: .Bench))
        }
        for member in homeMembers {
            totalHomeTeamRoster.append(MemberInGame(member: member, positionInGame: .Bench))
        }
    }
    
    init(currentHomeTeamLineup: [MemberInGame], totalHomeTeamRoster: [MemberInGame], curentAwayTeamLineup: [MemberInGame], totalAwayTeamRoster: [MemberInGame]) {
        self.currentHomeTeamLineup = currentHomeTeamLineup
        self.curentAwayTeamLineup = curentAwayTeamLineup
        self.totalHomeTeamRoster = totalHomeTeamRoster
        self.totalAwayTeamRoster = totalAwayTeamRoster
    }
    
//    func getHomePlayer(atPosition pos : Positions) -> MemberInGame? {
//        for player in currentHomeTeamLineup {
//            if player.positionInGame == pos {
//                return player
//            }
//        }
//        for player in hiddenHomeTeam {
//            if player.positionInGame == pos {
//                return player
//            }
//        }
//        return nil
//    }
//    
//    func getAwayPlayer(atPosition pos : Positions) -> MemberInGame? {
//        for player in curentAwayTeamLineup {
//            if player.positionInGame == pos {
//                return player
//            }
//        }
//        for player in hiddenAwayTeam {
//            if player.positionInGame == pos {
//                return player
//            }
//        }
//        return nil
//    }
    
    func getBenchPlayers(forType type : LineupEditingType) -> [MemberInGame] {
        var players : [MemberInGame] = []
        let lineup = type == .Away ? curentAwayTeamLineup : currentHomeTeamLineup
        for player in lineup {
            if player.positionInGame == .Bench {
                players.append(player)
            }
        }
        return players
    }
    
    func getPlayer(forTeam type : LineupEditingType, atPosition pos : Positions) -> MemberInGame? {
        let lineup = type == .Away ? curentAwayTeamLineup : currentHomeTeamLineup
        for player in lineup {
            if player.positionInGame == pos {
                return player
            }
        }
        return nil
    }
    
    static func == (lhs: Lineup, rhs: Lineup) -> Bool {
        return lhs.curentAwayTeamLineup == rhs.curentAwayTeamLineup &&
            rhs.currentHomeTeamLineup == rhs.currentHomeTeamLineup
    }
    
}

struct LineupChange {
    
    /// Stores the previous home team lineup
    var prevHomeTeamLineup : [MemberInGame]
    
    /// Stores the previous away team lineup
    var prevAwayTeamLineup : [MemberInGame]
    
    /// Stores the member ID's in batting order and references their positon
    var newHomeTeamLineup : [MemberInGame]
    
    /// Stores the member ID's in batting order and reference their position
    var newAwayTeamLineup : [MemberInGame]
    
    var pitchNumChanged : Int

    func getChangeInLineup(forTeam team : GameTeamType) -> [MemberInGame] {
        var difference : [MemberInGame] = team == .Home ? newHomeTeamLineup : newAwayTeamLineup
        for oldMember in (team == .Home ? prevHomeTeamLineup : prevAwayTeamLineup) {
            if let index = difference.firstIndex(of: oldMember) {
                if difference[index].positionInGame == oldMember.positionInGame {
                    difference.remove(at: index)
                } else {
                    print("Found same player with different position")
                }
            }
        }
        return difference
    }
}

struct LineupChangeBuilder {
    var homeLineupChange : [[String : Int]]
    var awayLineupChange : [[String : Int]]
    var pitchNumberChanged : Int
    var homeDHMap : [String : String]
    var awayDHMap : [String : String]
}

enum LineupEditingType {
    case Home
    case Away
}

extension Array where Element : Hashable {
    func difference(from other : [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
