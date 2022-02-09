// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class GameSaveManagement {
    
    private static var firestore = Firestore.firestore()
    
//    static func generateGameViewModel(forGame game : Game, completion : @escaping (GameViewModel) -> Void) -> GameViewModel {
//
//        LineupSaveManagement.configureLineupUpdateReverseBuilder(forGame: game) { (lineupChangeBuilder) in
//            var awayLineup : [MemberInGame] = []
//            var homeLineup : [MemberInGame] = []
//
//            for player in lineupChangeBuilder.awayLineupChange {
//
//            }
//        }
//
//        return GameViewModel(withGame: game)
//    }
    static func generateGameDocumentLink(forGame game : Game) -> DocumentReference {
        print("SEASON: \(game.seasonID)")
        return firestore.collection(FirestoreKeys.Season_Collection_Name).document(game.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).document(game.gameID)
    }
    
    static func saveGameInformation(gameToSave game : Game) -> String {
        var doc_ref = firestore.collection(FirestoreKeys.Season_Collection_Name).document(game.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).document()
        if game.gameID != "" {
            doc_ref = generateGameDocumentLink(forGame: game)
        }
        doc_ref.setData([
            FirestoreKeys.Game_ID_Tag : doc_ref.documentID,
            FirestoreKeys.Season_ID_Tag : game.seasonID,
            FirestoreKeys.Away_Team_Tag : game.awayTeam.teamID,
            FirestoreKeys.Home_Team_Tag : game.homeTeam.teamID,
            FirestoreKeys.Date_Tag : game.date,
            FirestoreKeys.City_Tag : game.city,
            FirestoreKeys.State_Tag : game.state,
            "gameScheduleState" : game.gameScheduleState.rawValue
        ])
        return doc_ref.documentID
    }
    
    static func saveInningInformation(forGame game : Game, inningToSave inning : Inning) {
        generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inning.inningNum)").setData([
            "inningNum" : inning.inningNum,
            "isTop" : inning.isTop
        ])
    }
    
    static func saveAtBatInformation(forGame game : Game, forInning inning : Inning, atBatToSave atBat : AtBat) {
        generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inning.inningNum)").collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).document("\(atBat.atBatID)").setData([
            "atBatNum" : atBat.atBatID,
            "pitcherIds" : atBat.pitcherID,
            "hitterIds" : atBat.hitterID,
            "numInInning" : atBat.numberInInning
        ])
    }
    
    static func saveEventInformation(forGame game : Game, forInning inning : Inning, forAtBat atBat : AtBat, eventToSave event : EventViewModel, forIndex index: Int) {
        var dataToSave : [String : Any] = [
            "eventNum" : event.eventNum,
            "numberOfOuts" : event.numberOfOuts,
            "homeScore" : event.homeScore,
            "earnedHomeScore" : event.earnedHomeScore,
            "awayScore" : event.awayScore,
            "earnedAwayScore" : event.earnedAwayScore,
            "numBalls" : event.numBalls,
            "numStrikes" : event.numStrikes,
            "placeInHomeLineup" : event.placeInHomeLineup,
            "placeInAwayLineup" : event.placeInAwayLineup,
            "hitterID" : event.hitterID,
            "pitcherID" : event.pitcherID,
            "isEndOfAtBat" : event.isEndOfAtBat,
            "snapshotIndex" : index
        ]
//        var playersInvolved : [String : Int] = [:]
//        for member in event.playersInvolved {
//            playersInvolved.updateValue(member.positionInGame.rawValue, forKey: member.member.memberID)
//        }
//        if playersInvolved.count > 0 {
//            dataToSave.updateValue(playersInvolved, forKey: "membersInvolved")
//        }
//
//        var errorsInvolved : [String : Int] = [:]
//        for member in event.playerWhoCommittedError {
//            errorsInvolved.updateValue(member.type.rawValue, forKey: member.fielderInvolved.member.memberID)
//        }
//        if errorsInvolved.count > 0 {
//            dataToSave.updateValue(errorsInvolved, forKey: "errorCommitted")
//        }
        
        var eventTypes : [Int] = []
        for eventType in event.basePathInfo {
            eventTypes.append(eventType.type.rawValue)
        }
       
        if let pitchInfo = event.pitchEventInfo, let pitch = pitchInfo.completedPitch {
            eventTypes.append(BasePathType.Pitch.rawValue)
            let pitchDataToSave = generatePitchSaveData(fromPitch: pitch)
            dataToSave.updateValue(pitchDataToSave, forKey: "pitchEventInfo")
        }
        
        if eventTypes.count > 0 {
            dataToSave.updateValue(eventTypes, forKey: "eventTypes")
        }
        
        var eventSaves : [[String : Any]] = []
        for event in event.basePathInfo {
            eventSaves.append(generateBasePathSaveData(forBasePathInfo: event))
        }
        if eventSaves.count > 0 {
            dataToSave.updateValue(eventSaves, forKey: "basePathInfo")
        }
        
        if let first = event.playerAtFirstAfter {
            dataToSave.updateValue(generateBaseSaveData(fromBaseState: first),
                                   forKey: "playerAtFirstAfter")
        }
        
        if let second = event.playerAtSecondAfter {
            dataToSave.updateValue(generateBaseSaveData(fromBaseState: second),
                                   forKey: "playerAtSecondAfter")
        }
        
        if let third = event.playerAtThirdAfter {
            dataToSave.updateValue(generateBaseSaveData(fromBaseState: third),
                                   forKey: "playerAtThirdAfter")
        }
        
        var playerWhoScored: [String] = []
        for player in event.runnersWhoScored {
            playerWhoScored.append(player.memberID)
        }
        
        if playerWhoScored.count > 0 {
            dataToSave.updateValue(playerWhoScored, forKey: "playersWhoScored")
        }
        
        generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inning.inningNum)").collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).document("\(atBat.atBatID)").collection("Events").document("\(index)").setData(dataToSave)
    }
    
    static func generateBaseSaveData(fromBaseState baseState: BaseState) -> [String: Any]{
        var dataToSave : [String : Any] = [
            "playerOnBase" : baseState.playerOnBase.member.memberID,
        ]
        if let pinchRunner = baseState.pinchRunner {
            dataToSave.updateValue(pinchRunner.member.memberID, forKey: "pinchRunner")
        }
        return dataToSave
    }
    
    static func generatePitchSaveData(fromPitch pitch : Pitch) -> [String : Any] {
        var dataToSave : [String : Any] = [
            "pitchNumber" : pitch.pitchNumber,
        ]
        if let type = pitch.pitchType {
            dataToSave.updateValue(type.rawValue, forKey: "pitchThrown")
        }
        
        if pitch.pitchVelo > 0 {
            dataToSave.updateValue(pitch.pitchVelo, forKey: "pitchVelo")
        }
        
        if let locations = pitch.pitchLocation {
        
            dataToSave.updateValue(locations.rawValue, forKey: "pitchLocation")
        }
        
        if let hitterVelo = pitch.hitterExitVelo {
            dataToSave.updateValue(hitterVelo, forKey: "hitterExitVelo")
        }
        
        if let outcome = pitch.pitchResult {
            dataToSave.updateValue(outcome.rawValue, forKey: "pitchResult")
            dataToSave.updateValue(pitch.pitcherThrowingHand.rawValue, forKey: "pitcherThrowingHand")
            dataToSave.updateValue(pitch.hitterHittingHand.rawValue, forKey: "hitterHittingHand")
            dataToSave.updateValue(pitch.pitchingStyle.rawValue, forKey: "pitchingStyle")
        }
        
        if let ballLocation = pitch.ballFieldLocation {
            dataToSave.updateValue(ballLocation.rawValue, forKey: "ballFieldLocation")
        }
        
        if let bipType = pitch.bipType {
            dataToSave.updateValue(bipType.rawValue, forKey: "bipType")
        }
        var bipHits : [Int] = []
        for hit in pitch.bipHit {
            bipHits.append(hit.rawValue)
        }
        if bipHits.count > 0 {
            dataToSave.updateValue(bipHits, forKey: "bipHit")
        }
        
        return dataToSave
    }
    
    static func generateBasePathSaveData(forBasePathInfo info : BasePathEventInfo) -> [String : Any] {
        return [
            "runnerInvolved" : info.runnerInvolved.member.memberID,
            "type" : info.type.rawValue
        ]
    }
    
    static func saveLineupUpdate(gameToSave game : Game, withNewLineup lineupChange : LineupChange) {
        var homeTeamLineup : [String : Int] = [:]
        var awayTeamLineup : [String : Int] = [:]
        
        for homeTeamMember in lineupChange.newHomeTeamLineup {
            homeTeamLineup.updateValue(homeTeamMember.positionInGame.rawValue, forKey: homeTeamMember.member.memberID)
        }
        
        for awayTeamMember in lineupChange.newAwayTeamLineup {
            awayTeamLineup.updateValue(awayTeamMember.positionInGame.rawValue, forKey: awayTeamMember.member.memberID)
        }
        
        let dataToSave : [String : Any] = [
            "pitchNumChanged" : lineupChange.pitchNumChanged,
            "homeLineup" : homeTeamLineup,
            "awayLineup" : awayTeamLineup
        ]
        
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(game.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).document(game.gameID).collection(FirestoreKeys.Season_Game_Lineup_Collection_Name).document("\(lineupChange.pitchNumChanged)").setData(dataToSave)
    }
    
    static func loadGameList(withSeason season : Season, completion : @escaping ([Game]) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(season.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).getDocuments { (querySnapshot, error) in
            // Checks if there was an error in loadiang the game information
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let query = querySnapshot, !query.isEmpty {
                    var games : [Game] = []
                    for document in query.documents {
                        if let game = loadGameInformationFromGameDocument(withDocument: document, withCurrentSeason: season) {
                            games.append(game)
                        }
                    }
                    completion(games)
                } else {
                    completion([])
                }
            }
        }
    }
    
    private static func loadGameInformationFromGameDocument(withDocument snapshot : DocumentSnapshot, withCurrentSeason currentSeason : Season) -> Game? {
        let data = snapshot.data() ?? [:]
        if let awayTeamID = data[FirestoreKeys.Away_Team_Tag] as? String,
           let homeTeamID = data[FirestoreKeys.Home_Team_Tag] as? String,
           let date = (data[FirestoreKeys.Date_Tag] as? Timestamp)?.dateValue(),
           let city = data[FirestoreKeys.City_Tag] as? String,
           let state = data[FirestoreKeys.State_Tag] as? String,
           let gameScheduleState = data["gameScheduleState"] as? Int{
            var awayTeam : Team?
            var homeTeam : Team?
            for team in currentSeason.teams {
                if team.teamID == awayTeamID {
                    awayTeam = team
                }
                if team.teamID == homeTeamID {
                    homeTeam = team
                }
            }
            if let awayTeam = awayTeam, let homeTeam = homeTeam {
                let game = Game(withGameID: snapshot.documentID, withSeasonID: currentSeason.seasonID, withAwayTeam: awayTeam, withHomeTeam: homeTeam, withDate: date, withCity: city, withState: state, withGameSchedState: GameScheduleState(rawValue: gameScheduleState) ?? .Scheduled)
                return game
            } else {
                return nil
            }
          
        } else {
            return nil
        }
    }
    
    static func loadGameInformation(withSeason season : Season, withGameId gameID : String, completion : @escaping (Game?) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(season.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).document(gameID).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                // Ensures the document exists
                if let snapshot = snapshot, snapshot.exists {
                    let data = snapshot.data() ?? [:]
                    
                    if let awayTeamID = data[FirestoreKeys.Away_Team_Tag] as? String,
                       let homeTeamID = data[FirestoreKeys.Home_Team_Tag] as? String,
                       let date = data[FirestoreKeys.Date_Tag] as? Timestamp,
                       let city = data[FirestoreKeys.City_Tag] as? String,
                       let state = data[FirestoreKeys.State_Tag] as? String {
                        var awayTeam : Team?
                        var homeTeam : Team?
//                        if let currentSeason = currentSeason {
                        for team in season.teams {
                            print(team.teamID)
                            if team.teamID == awayTeamID {
                                awayTeam = team
                            }
                            if team.teamID == homeTeamID {
                                homeTeam = team
                            }
                        }
                        if let awayTeam = awayTeam, let homeTeam = homeTeam {
                            let game = Game(withGameID: gameID, withSeasonID: season.seasonID, withAwayTeam: awayTeam, withHomeTeam: homeTeam, withDate: date.dateValue(), withCity: city, withState: state)
                            completion(game)
                        } else {
                            completion(nil)
                        }
//                        } else {
//                            completion(nil)
//                        }
                    } else {
                        completion(nil)
                    }
                } else {
                    // Sends back nil since the document couldn't be found
                    completion(nil)
                }
            }
        }
    }
}
