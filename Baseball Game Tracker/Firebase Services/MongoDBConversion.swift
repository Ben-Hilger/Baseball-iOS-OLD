// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase


class MongoDBConversion {

    private static let db = Firestore.firestore()
    
    static func convertGame(gameToConvert gameViewModel: GameViewModel) {
        let game = gameViewModel.game!
        let newDoc = db.collection("Games").document()
        let dataToSave: [String: Any] = [
            "gameID" : game.gameID,
            "seasonID" : game.seasonID,
            "homeTeam" : game.homeTeam.teamID,
            "awayTeam" : game.awayTeam.teamID,
            "city" : game.city,
            "date" : game.date,
            "gameScheduleState" : game.gameScheduleState.rawValue
        ]
        newDoc.setData(dataToSave)
        let lineup = newDoc.collection("Lineup")
        
        
        var homeLineup : [[String : Int]] = []
        var awayLineup : [[String : Int]] = []
        
        var homeDhMap : [String : String] = [:]
        var awayDhMap : [String : String] = [:]
        
        for memberIndex in 0..<gameViewModel.lineup.currentHomeTeamLineup.count {
            homeLineup.append([gameViewModel.lineup.currentHomeTeamLineup[memberIndex].member.memberID : gameViewModel.lineup.currentHomeTeamLineup[memberIndex].positionInGame.rawValue])
            if let dh = gameViewModel.lineup.currentHomeTeamLineup[memberIndex].dh {
                homeDhMap.updateValue(dh.memberID, forKey: gameViewModel.lineup.currentHomeTeamLineup[memberIndex].member.memberID)
            }
       //     homeLineup[memberIndex].updateValue(change.newHomeTeamLineup[memberIndex].positionInGame.rawValue, forKey: change.newHomeTeamLineup[memberIndex].member.memberID)
        }
        for memberIndex in 0..<gameViewModel.lineup.curentAwayTeamLineup.count {
            awayLineup.append([gameViewModel.lineup.curentAwayTeamLineup[memberIndex].member.memberID: gameViewModel.lineup.curentAwayTeamLineup[memberIndex].positionInGame.rawValue])
           // awayLineup[memberIndex].updateValue(change.newAwayTeamLineup[memberIndex].positionInGame.rawValue, forKey: change.newAwayTeamLineup[memberIndex].member.memberID)
            if let dh = gameViewModel.lineup.curentAwayTeamLineup[memberIndex].dh {
                awayDhMap.updateValue(dh.memberID, forKey: gameViewModel.lineup.curentAwayTeamLineup[memberIndex].member.memberID)
            }
        }
//        GameSaveManagement.generateGameDocumentLink(forGame: game).collection("Lineup").addDocument(data: [
//            "pitchNumber" : change.pitchNumChanged,
//            "homeLineup" : homeLineup,
//            "awayLineup" : awayLineup
//        ])
        lineup.document("0").setData([
            "homeLineup" : homeLineup,
            "awayLineup" : awayLineup,
            "homeDHMap" : homeDhMap,
            "awayDHMap" : awayDhMap
        ])
        
    }
    
    static func convertGameSnapshot(gameSnapshot snapshot: GameSnapshot){
        var dataToSave: [String: Any] = [
            "seasonID" : snapshot.game!.seasonID,
            "gameID" : snapshot.game!.gameID,
            "snapshotIndex" : snapshot.snapshotIndex,
            "currentInning" : snapshot.currentInning!.inningNum,
            "currentAtBat" : snapshot.currentAtBat!.numberInInning,
            "currentStrikes" : snapshot.eventViewModel.numStrikes,
            "currentBalls" : snapshot.eventViewModel.numBalls,
            "homeScore" : snapshot.eventViewModel.homeScore + snapshot.eventViewModel.earnedHomeScore,
            "awayScore" : snapshot.eventViewModel.awayScore + snapshot.eventViewModel.earnedAwayScore,
            "numberOuts" : snapshot.eventViewModel.numberOfOuts,
            "placeInHomeLineup" : snapshot.eventViewModel.placeInHomeLineup,
            "placeInAwayLineup" : snapshot.eventViewModel.placeInAwayLineup,
            "pitcherID" : snapshot.eventViewModel.pitcherID,
            "hitterID" : snapshot.eventViewModel.hitterID
        ]
        
        if let playerAtFirst = snapshot.eventViewModel.playerAtFirstAfter {
            dataToSave.updateValue(playerAtFirst.pinchRunner?.member.memberID ??
                playerAtFirst.playerOnBase.member.memberID, forKey: "playerAtFirstAfter")
        }
        
        if let playerAtSecond = snapshot.eventViewModel.playerAtSecondAfter {
            dataToSave.updateValue(playerAtSecond.pinchRunner?.member.memberID ??
                playerAtSecond.playerOnBase.member.memberID, forKey: "playerAtSecondAfter")
                
        }
        
        if let playerAtSecond = snapshot.eventViewModel.playerAtThirdAfter {
            dataToSave.updateValue(playerAtSecond.pinchRunner?.member.memberID ??
                                    playerAtSecond.playerOnBase.member.memberID, forKey: "playerAtThirdAfter")
        }
        
        var basePathEvents: [[String: Any]] = []
        for event in snapshot.eventViewModel.basePathInfo {
            basePathEvents.append([
                "type": event.type.rawValue,
                "memberInvolved": event.runnerInvolved.member.memberID
            ])
        }
        if basePathEvents.count > 0 {
            dataToSave.updateValue(basePathEvents, forKey: "basePathEvents")
        }
        
        dataToSave.updateValue(snapshot.eventViewModel.isEndOfAtBat, forKey: "isEndOfAtBat")
        dataToSave.updateValue(snapshot.eventViewModel.pitchEventInfo?.completedPitch != nil, forKey: "isAddingPitch")
        dataToSave.updateValue(snapshot.currentInning!.isTop ? snapshot.game?.homeTeam.teamName == "Miami University Redhawks" : snapshot.game?.awayTeam.teamName == "Miami University Redhawks", forKey: "isMiami")
        
        if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
            dataToSave.updateValue(pitch.pitchNumber, forKey: "pitchNumber")
            dataToSave.updateValue(pitch.pitcherThrowingHand.rawValue, forKey: "pitcherThrowingHand")
            dataToSave.updateValue(pitch.hitterHittingHand.rawValue, forKey: "hitterHittingHand")
            dataToSave.updateValue(pitch.pitchingStyle.rawValue, forKey: "pitchingStyle")
            if let exitVelo = pitch.hitterExitVelo {
                dataToSave.updateValue(exitVelo, forKey: "hitterExitVelo")
            }
            if let ballLoc = pitch.ballFieldLocation {
                dataToSave.updateValue(ballLoc.rawValue, forKey: "ballFieldLocation")
            }
            if let pitchThrown = pitch.pitchType {
                dataToSave.updateValue(pitchThrown.rawValue, forKey: "pitchThrown")
            }
            dataToSave.updateValue(pitch.pitchVelo, forKey: "pitchVelo")
            
            if let pitchLocation = pitch.pitchLocation {
                dataToSave.updateValue(pitchLocation.rawValue, forKey: "pitchLocation")
            }
            if let pitchResult = pitch.pitchResult {
                dataToSave.updateValue(pitchResult.rawValue, forKey: "pitchResult")
            }
            if let bipType = pitch.bipType {
                dataToSave.updateValue(bipType.rawValue, forKey: "bipType")
            }
            var convertedOutcomes: [Int] = []
            for outcome in pitch.bipHit {
                convertedOutcomes.append(outcome.rawValue)
            }
            if convertedOutcomes.count > 0 {
                dataToSave.updateValue(convertedOutcomes, forKey: "bipOutcome")
            }
        }
        let gameSnapDoc = db.collection("GameSnapshots").document("\(snapshot.game!.gameID)-\(snapshot.snapshotIndex)")
        gameSnapDoc.setData(dataToSave)
    }
    
}
