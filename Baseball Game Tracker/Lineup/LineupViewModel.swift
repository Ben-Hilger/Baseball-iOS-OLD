// Copyright 2021-Present Benjamin Hilger

import Foundation

class LineupViewModel : ObservableObject {
    
    @Published var homeLineup : [MemberInGame]
    @Published var homeRoster : [MemberInGame]
    
    @Published var awayLineup : [MemberInGame]
    @Published var awayRoster : [MemberInGame]
    
    //@Published var editingAwayLineup : Bool = true
    
    @Published var lineupMemberSelected : MemberInGame?
    @Published var availableMemberSelected : MemberInGame?
    
    @Published var currentHitter : MemberInGame?
    
    init(withLineup lineup : Lineup) {
        homeLineup = lineup.currentHomeTeamLineup
        homeRoster = lineup.totalHomeTeamRoster
        
        awayLineup = lineup.curentAwayTeamLineup
        awayRoster = lineup.totalAwayTeamRoster
    }
    
    init(withLineup lineup : Lineup, withCurrentHitter hitter : MemberInGame) {
        homeLineup = lineup.currentHomeTeamLineup
        homeRoster = lineup.totalHomeTeamRoster
        
        awayLineup = lineup.curentAwayTeamLineup
        awayRoster = lineup.totalAwayTeamRoster
        
        currentHitter = hitter
    }
    
    init(homeLineup : [MemberInGame], awayLineup : [MemberInGame], homeRoster : [MemberInGame], awayRoster : [MemberInGame]) {
        self.homeLineup = homeLineup
        self.awayLineup = awayLineup
        self.homeRoster = homeRoster
        self.awayRoster = awayRoster
    }
    
    init(homeLineup : [MemberInGame], awayLineup : [MemberInGame], homeRoster : [MemberInGame], awayRoster : [MemberInGame], currentHitter : MemberInGame) {
        self.homeLineup = homeLineup
        self.awayLineup = awayLineup
        self.homeRoster = homeRoster
        self.awayRoster = awayRoster
        self.currentHitter = currentHitter
    }
    
    func getCurrentPitcher(editingAwayLineup : Bool) -> MemberInGame? {
        let lineup = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)
        for player in lineup {
            if player.positionInGame == .Pitcher {
                return player
            }
        }
        return nil
    }
    
    func getCurrentPlayer(atPosition pos : Positions, editingAwayLineup : Bool) -> MemberInGame? {
        let lineup = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)
        for player in lineup {
            if player.positionInGame == pos {
                return player
            }
        }
        return nil
    }
    
    func switchCurrentHitter(editingAwayLineup : Bool, playerToSwitchWithIndex index : Int) {
        guard let currentHitter = currentHitter, let hitterIndex =
                getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)
                .firstIndex(of: currentHitter)
        else {
            return
        }
        if editingAwayLineup {
            self.currentHitter = awayRoster[index]
        } else {
            self.currentHitter = homeRoster[index]
        }
        replacePlayerInLineup(editingAwayLineup: editingAwayLineup,
                              playerIndexCurrentlyInLineup: hitterIndex,
                              playerIndexCurrentlyInRoster: index)
        self.lineupMemberSelected = currentHitter
    }
    
    func getCurrentLineupEditing(editingAwayLineup : Bool, removeDHedPlayer: Bool = false) -> [MemberInGame] {
        var lineup = editingAwayLineup ? awayLineup : homeLineup
        
        // Check if the dhed player needs to be removed
        if removeDHedPlayer {
            // Find the player(s) with dhs
            for player in lineup {
                if player.dh != nil, let playerIndex = lineup.firstIndex(of: player) {
                    // Remove the player from the lineup
                    lineup.remove(at: playerIndex)
                }
            }
        }
        
        return lineup
    }
    
    func getCurrentRosterEditing(editingAwayLineup : Bool) -> [MemberInGame] {
        return editingAwayLineup ? awayRoster : homeRoster
    }
    
    func playerInLineup(editingAwayLineup: Bool, playerToCheck player : MemberInGame) -> Bool {
        for member in getCurrentLineupEditing(editingAwayLineup: editingAwayLineup) {
            if player == member {
                return true
            }
        }
        return false
    }
    
    func removePlayerFromCurrentLineup(editingAwayLineup : Bool, atIndex index : Int) {
        let player = editingAwayLineup ? awayLineup.remove(at: index) : homeLineup.remove(at: index)
        if let rosterIndex = (editingAwayLineup ? awayRoster : homeRoster).firstIndex(of: player) {
            assignPlayerToBench(editingAwayLineup: editingAwayLineup, playerIndex: rosterIndex)
        }
        if index < getCurrentLineupEditing(editingAwayLineup: editingAwayLineup).count {
            //self.lineupMemberSelected = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)[index]
        } else {
            //self.lineupMemberSelected = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)[index-1]
        }
    }
    
    func addPlayerToCurrentLineup(editingAwayLineup : Bool, playerToAdd player : MemberInGame) {
        editingAwayLineup ? awayLineup.append(player) : homeLineup.append(player)
        updateRoster(editingAwayLineup: editingAwayLineup, playerToUpdate: player)
//        if let rosterIndex = (editingAwayLineup ? awayRoster : homeRoster).firstIndex(of: player) {
//            if editingAwayLineup {
//                awayRoster[rosterIndex].positionInGame = player.positionInGame
//            } else {
//                homeRoster[rosterIndex].positionInGame = player.positionInGame
//            }
//        }
    }
    
    func swapPlayersInLineup(editingAwayLineup : Bool, firstIndexToSwap firstIndex : Int, secondIndexToSwap secondIndex : Int) {
        if editingAwayLineup {
            let player = awayLineup[firstIndex]
            awayLineup[firstIndex] = awayLineup[secondIndex]
            awayLineup[secondIndex] = player
            //updateRoster(editingAwayLineup: editingAwayLineup, playerToUpdate: player)
        } else {
            let player = homeLineup[firstIndex]
            homeLineup[firstIndex] = homeLineup[secondIndex]
            homeLineup[secondIndex] = player
            //updateRoster(editingAwayLineup: editingAwayLineup, playerToUpdate: player)
        }
    }
    
    func replacePlayerInLineup(editingAwayLineup : Bool, playerIndexCurrentlyInLineup playerLineup : Int, playerIndexCurrentlyInRoster playerRoster : Int) {
        if editingAwayLineup {
            let player = awayLineup[playerLineup]
            let dh = player.dh
            awayLineup[playerLineup] = awayRoster[playerRoster]
            awayLineup[playerLineup].dh = dh
            awayLineup[playerLineup].positionInGame = player.positionInGame
            //self.lineupMemberSelected = awayLineup[playerLineup]
            if let index = awayRoster.firstIndex(of: player) {
                assignPlayerToBench(editingAwayLineup: editingAwayLineup, playerIndex: index)
                //self.availableMemberSelected = awayRoster[playerRoster]
            }
        } else {
            let player = homeLineup[playerLineup]
            let dh = player.dh
            homeLineup[playerLineup] = homeRoster[playerRoster]
            homeLineup[playerLineup].dh = dh
            homeLineup[playerLineup].positionInGame = player.positionInGame
            //self.lineupMemberSelected = homeLineup[playerLineup]
            if let index = homeRoster.firstIndex(of: player) {
                assignPlayerToBench(editingAwayLineup: editingAwayLineup, playerIndex: index)
                //self.availableMemberSelected = homeRoster[playerRoster]
            }
        }
    }
    
    func switchPitcher(editingAwayLineup : Bool, pitcherIndex index : Int, switchPitcherTo newPitcher : MemberInGame) {
        if let lineupIndex = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: newPitcher) {
            let player = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)[index]
            if editingAwayLineup {
                awayLineup[index].positionInGame = awayLineup[lineupIndex].positionInGame
                awayLineup[lineupIndex].positionInGame = .Pitcher
                self.lineupMemberSelected = awayLineup[lineupIndex]
            } else {
                homeLineup[index].positionInGame = homeLineup[lineupIndex].positionInGame
                homeLineup[lineupIndex].positionInGame = .Pitcher
                self.lineupMemberSelected = homeLineup[lineupIndex]
            }
            if let oldRosterIndex = getCurrentRosterEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: player), let rosterIndex = getCurrentRosterEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: newPitcher) {
                if editingAwayLineup {
                    awayRoster[oldRosterIndex].positionInGame = awayLineup[lineupIndex].positionInGame
                    awayRoster[rosterIndex].positionInGame = .Pitcher
                } else {
                    homeRoster[oldRosterIndex].positionInGame = awayLineup[lineupIndex].positionInGame
                    homeRoster[rosterIndex].positionInGame = .Pitcher
                }
            }
        } else {
            let oldPitcher = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)[index]
            if editingAwayLineup {
                awayLineup[index] = newPitcher
                awayLineup[index].dh = oldPitcher.dh
                awayLineup[index].positionInGame = .Pitcher
                self.lineupMemberSelected = awayLineup[index]
            } else {
                homeLineup[index] = newPitcher
                homeLineup[index].dh = oldPitcher.dh
                homeLineup[index].positionInGame = .Pitcher
                self.lineupMemberSelected = homeLineup[index]
            }
            if let rosterIndex = getCurrentRosterEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: oldPitcher) {
                assignPlayerToBench(editingAwayLineup: editingAwayLineup, playerIndex: rosterIndex)
            }
        }
        self.availableMemberSelected = nil
    }
    
    func switchPosition(editingAwayLineup : Bool, pitcherIndex index : Int, switchPitcherTo newPitcher : MemberInGame, forPosition pos : Positions) {
        if let lineupIndex = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: newPitcher) {
            var player = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)[index]
            if editingAwayLineup {
                awayLineup[index].positionInGame = awayLineup[lineupIndex].positionInGame
                awayLineup[lineupIndex].positionInGame = pos
                self.lineupMemberSelected = awayLineup[lineupIndex]
            } else {
                homeLineup[index].positionInGame = homeLineup[lineupIndex].positionInGame
                homeLineup[lineupIndex].positionInGame = pos
                self.lineupMemberSelected = homeLineup[lineupIndex]
            }
            if let oldRosterIndex = getCurrentRosterEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: player), let rosterIndex = getCurrentRosterEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: newPitcher) {
                if editingAwayLineup {
                    awayRoster[oldRosterIndex].positionInGame = awayLineup[lineupIndex].positionInGame
                    awayRoster[rosterIndex].positionInGame = pos
                } else {
                    homeRoster[oldRosterIndex].positionInGame = awayLineup[lineupIndex].positionInGame
                    homeRoster[rosterIndex].positionInGame = pos
                }
            }
        } else {
            let oldPitcher = getCurrentLineupEditing(editingAwayLineup: editingAwayLineup)[index]
            if editingAwayLineup {
                awayLineup[index] = newPitcher
                awayLineup[index].dh = oldPitcher.dh
                awayLineup[index].positionInGame = .Pitcher
                self.lineupMemberSelected = awayLineup[index]
            } else {
                homeLineup[index] = newPitcher
                homeLineup[index].dh = oldPitcher.dh
                homeLineup[index].positionInGame = .Pitcher
                self.lineupMemberSelected = homeLineup[index]
            }
            if let rosterIndex = getCurrentRosterEditing(editingAwayLineup: editingAwayLineup).firstIndex(of: oldPitcher) {
                assignPlayerToBench(editingAwayLineup: editingAwayLineup, playerIndex: rosterIndex)
            }
        }
        self.availableMemberSelected = nil
    }
    
    func assignPlayerToBench(editingAwayLineup : Bool, playerIndex : Int) {
        if editingAwayLineup {
            awayRoster[playerIndex].positionInGame = .Bench
        } else {
            homeRoster[playerIndex].positionInGame = .Bench
        }
    }
    
    func assignPlayerAsDH(editingAwayLineup : Bool, lineupPlayerIndex lineupIndex : Int, rosterPlayerIndex rosterIndex : Int) {
        if editingAwayLineup {
            awayLineup[lineupIndex].dh = awayRoster[rosterIndex].member
            awayRoster[rosterIndex].positionInGame = .DH
            awayLineup.append(awayRoster[rosterIndex])
        } else {
            homeLineup[lineupIndex].dh = homeRoster[rosterIndex].member
            homeRoster[rosterIndex].positionInGame = .DH
            homeLineup.append(homeRoster[rosterIndex])
        }
    }
    
    func replaceDH(editingAwayLineup: Bool, lineupPlayerIndex lineupIndex: Int, rosterPlayerIndex rosterIndex: Int) {
        if editingAwayLineup {
            let oldDH = awayLineup[lineupIndex].dh!
            awayLineup[lineupIndex].dh = nil
            if let dHIndex = awayLineup.firstIndex(of: MemberInGame(member: oldDH, positionInGame: .DH)) {
                awayLineup.remove(at: dHIndex)
            }
        } else {
            let oldDH = homeLineup[lineupIndex].dh!
            homeLineup[lineupIndex].dh = nil
            if let dHIndex = homeLineup.firstIndex(of: MemberInGame(member: oldDH, positionInGame: .DH)) {
                homeLineup.remove(at: dHIndex)
            }
        }
        assignPlayerAsDH(editingAwayLineup: editingAwayLineup, lineupPlayerIndex: lineupIndex, rosterPlayerIndex: rosterIndex)
    }
    
    func removePlayerAsDH(editingAwayLineup : Bool, withPlayer player : MemberInGame) {
        if editingAwayLineup {
            if let index = awayLineup.firstIndex(of: player) {
                let prevDH = awayLineup[index].dh
                awayLineup[index].dh = nil
                if let prevDH = prevDH,
                   let prevIndex = awayRoster.firstIndex(
                    of: MemberInGame(member: prevDH, positionInGame: .DH)),
                   let lineupIndex = awayLineup.firstIndex(of: MemberInGame(member: prevDH, positionInGame: .DH)) {
                    awayRoster[prevIndex].positionInGame = .Bench
                    awayLineup.remove(at: lineupIndex)
                }
            }
        } else {
            if let index = homeLineup.firstIndex(of: player) {
                let prevDH = homeLineup[index].dh
                homeLineup[index].dh = nil
                if let prevDH = prevDH, let prevIndex =
                    homeRoster.firstIndex(
                        of: MemberInGame(member: prevDH, positionInGame: .DH)),
                   let lineupIndex = homeLineup.firstIndex(of: MemberInGame(member: prevDH, positionInGame: .DH)){
                    homeRoster[prevIndex].positionInGame = .Bench
                    homeLineup.remove(at: lineupIndex)
                }
            }
        }
    }
    
    func updateRoster(editingAwayLineup : Bool, playerToUpdate player : MemberInGame) {
        if let rosterIndex = (editingAwayLineup ? awayRoster : homeRoster).firstIndex(of: player) {
            if editingAwayLineup {
                awayRoster[rosterIndex].positionInGame = player.positionInGame
            } else {
                homeRoster[rosterIndex].positionInGame = player.positionInGame
            }
        }
    }
    
    func getAvailablePlayers(editingAwayLineup : Bool, forState state : LiveLineupChangeViewType, forPosition pos : Positions?) -> [MemberInGame] {
        var roster = editingAwayLineup ? awayRoster : homeRoster
        let lineup = editingAwayLineup ? awayLineup : homeLineup
        for player in lineup {
            if let index = roster.firstIndex(of: player), (state == .Fielder || state == .Runner ? roster[index].positionInGame == pos : state == .Hitter || state == .Default || player.positionInGame == .DH) {
                roster.remove(at: index)
            }
        }
        
        for index in (0..<roster.count).reversed() {
            if roster[index].positionInGame == .DH {
                roster.remove(at: index)
            }
        }
        
        return roster
    }
    func copy() -> LineupViewModel {
        let model = LineupViewModel(homeLineup: self.homeLineup, awayLineup: self.awayLineup, homeRoster: self.homeRoster, awayRoster: self.awayRoster)
        return model
    }
    
    func getPositionInLineup(editingAwayLineup editingAwayLineup : Bool,
                     forPlayer player: MemberInGame) -> Int {
        var currentPosition = 1
        
        for p in getCurrentLineupEditing(editingAwayLineup: editingAwayLineup) {
            if p == player {
                return currentPosition
            } else if p.dh == nil {
                currentPosition += 1
            }
        }
        
        return 0
    }
}
