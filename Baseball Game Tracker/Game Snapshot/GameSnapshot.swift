// Copyright 2021-Present Benjamin Hilger

import Foundation

class GameSnapshot : Identifiable, Equatable {
    
    var id = UUID()
        
    var game : Game? = nil
    
    var currentInning : Inning? = nil
    var currentAtBat : AtBat? = nil
    var currentInningNum : Int = 1
    var currentHitter : MemberInGame? = nil
    
    var numberAtBat : Int
    
//    var currentStrikes = 0
//    var currentBalls = 0
    var pitchNumber = 0
//    var pitchTracker : [String : Int]
    
//    var homeScore = 0
//    var homeEarnedScore = 0
//    var awayScore = 0
//    var awayEarnedScore = 0

    var eventViewModel : EventViewModel!
    
    var newInning : Bool = false
    var newAtBat : Bool = false

    var lineup : Lineup
    
    var saved : Bool = false
    
    var snapshotIndex: Int
    
    init(withGame game : Game?,
         withCurrentInning curIn : Inning?,
         withCurrentAtBat atbat : AtBat?,
         withCurrentInningNum currentInning : Int,
         withCurrentHitter currentHitter : MemberInGame?,
         withAtBatNumber numberAtBat : Int,
         withPitchNumber pitchNum : Int,
         withEventViewModel event : EventViewModel,
         createNewInningAtSave nI : Bool,
         createNewAtBatAtSave nAT : Bool,
         withLineup l : Lineup,
         withSnapshotIndex index: Int) {
        self.game = game
        self.currentInning = curIn
        self.currentAtBat = atbat
        self.currentInningNum = currentInning
        self.currentHitter = currentHitter
        self.numberAtBat = numberAtBat
        self.pitchNumber = pitchNum
        self.eventViewModel = event
        self.newInning = nI
        self.newAtBat = nAT
        self.lineup = l
        self.snapshotIndex = index
      //  generateDescriptor()
    }
    
//    func generateDescriptor() {
//        if let pitchInfo = eventViewModel.pitchEventInfo, let hitter = currentHitter, let pitcher = getCurrentPitcher(), let pitchThrown = pitchInfo.selectedPitchThrown {
//            // Checks if the batter was looking
//            // TODO: Add strike check for K
//            if pitchInfo.selectedPitchOutcome == .StrikeCalled {
//                gameSnapshotDescriptor = "\(pitcher.member.lastName)'s \(pitchThrown.getPitchTypeString()) Came in For a Called Strike Against \(hitter.member.lastName)"
//            // Checks if the batter swing and miss
//            } else if pitchInfo.selectedPitchOutcome == .StrikeSwingMiss {
//                gameSnapshotDescriptor = "\(hitter.member.lastName) Was Unable To Make Contact With \(pitcher.member.lastName)'s \(pitchThrown.getPitchTypeString())"
//            // Checks if there was a BIP
//            } else if pitchInfo.selectedPitchOutcome == .BIP {
//                if pitchInfo.selectedBIPHit.contains(.FirstB) || pitchInfo.selectedBIPHit.contains(.SecondB) || pitchInfo.selectedBIPHit.contains(.ThirdB) || pitchInfo.selectedBIPHit.contains(.HR) || pitchInfo.selectedBIPHit.contains(.HRInPark) {
//                    gameSnapshotDescriptor = "\(hitter.member.lastName) Hit a \(pitchInfo.selectedBIPHit.contains(.FirstB) ? "Single" : pitchInfo.selectedBIPHit.contains(.SecondB) ? "Double" : pitchInfo.selectedBIPHit.contains(.ThirdB) ? "Third" : pitchInfo.selectedBIPHit.contains(.HR) ? "Home Run" : pitchInfo.selectedBIPHit.contains(.HRInPark) ? "In The Park Home Run" : "")"
//                    if let ballLoc = pitchInfo.ballLocation {
//                        gameSnapshotDescriptor += " to Zone \(ballLoc.getShortDescription())"
//                    }
//                    if let atBat = currentAtBat, atBat.numRBIs > 0 {
//                        gameSnapshotDescriptor += ", driving in \(atBat.numRBIs) run\(atBat.numRBIs == 1 ? "" : "s")"
//                    }
//                }
//            }
//        }
//    }
//
    func getCurrentPitcher() -> MemberInGame? {
        if let inning = currentInning, let game = game {
            return lineup.getPlayer(forTeam: inning.isTop ? .Home : .Away, atPosition: .Pitcher)
        }
        return nil
    }

    func getLeadRunner() -> BaseState? {
        if let third = eventViewModel.playerAtThirdAfter {
            return third
        } else if let second = eventViewModel.playerAtSecondAfter {
            return second
        } else if let first = eventViewModel.playerAtFirstAfter {
            return first
        }
        return nil
    }
    
    static func == (lhs: GameSnapshot, rhs: GameSnapshot) -> Bool {
        lhs.eventViewModel == rhs.eventViewModel
    }
    
//    func submitLineupChange(forLineupViewModel lineupViewModel : LineupViewModel) {
//        if let inning = currentInning {
//            _ = lineup.updateLineup(withHomeTeamLineup: lineupViewModel.homeLineup, withAwayTeamLineup: lineupViewModel.awayLineup, atCurrentPitch: pitchNumber)
//            //LineupSaveManagement.saveLineupChange(gameToSave: game, changeToSubmit: change)
//            lineup.totalHomeTeamRoster = lineupViewModel.homeRoster
//            lineup.totalAwayTeamRoster = lineupViewModel.awayRoster
//            // Checks if the hitter has changed
//            if let hitter = lineupViewModel.currentHitter, hitter != currentHitter {
//                currentHitter = hitter
//                hitterBattingHand = hitter.member.hittingHand
//            } else {
//                // Automatically changes the hitter in case the order changed
//                if inning.isTop {
//                    if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
//                        placeInAwayLineup = 0
//                    }
//                    //currentHitter = game.lineup.curentAwayTeamLineup[min(placeInAwayLineup, game.lineup.curentAwayTeamLineup.count-1)]
//                    let newPlaceInAwayLineup = min(placeInAwayLineup, lineup.curentAwayTeamLineup.count-1)
//                    currentHitter = lineup.curentAwayTeamLineup[newPlaceInAwayLineup].dh == nil ?
//                        lineup.curentAwayTeamLineup[newPlaceInAwayLineup] :
//                        MemberInGame(member: lineup.curentAwayTeamLineup[newPlaceInAwayLineup].dh!, positionInGame: .DH)
//                    placeInAwayLineup = newPlaceInAwayLineup
//                } else {
//                    if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
//                        placeInHomeLineup = 0
//                    }
//                    //currentHitter = game.lineup.currentHomeTeamLineup[min(placeInHomeLineup, game.lineup.currentHomeTeamLineup.count-1)]
//                    let newPlaceInHomeLineup = min(placeInHomeLineup, lineup.currentHomeTeamLineup.count-1)
//                    currentHitter = lineup.currentHomeTeamLineup[newPlaceInHomeLineup].dh == nil ?
//                        lineup.currentHomeTeamLineup[newPlaceInHomeLineup] :
//                        MemberInGame(member: lineup.currentHomeTeamLineup[newPlaceInHomeLineup].dh!, positionInGame: .DH)
//                    placeInHomeLineup = min(placeInHomeLineup, lineup.currentHomeTeamLineup.count-1)
//                }
//            }
//            // Checks if the current pitcher has changed
//            if getCurrentPitcher() != lineupViewModel.getCurrentPitcher(editingAwayLineup: !inning.isTop) {
//                let newPitcher = lineupViewModel.getCurrentPitcher(editingAwayLineup: !inning.isTop)?.member
//                pitcherThrowingHand = newPitcher?.throwingHand
//            }
//        }
//    }
    
}
