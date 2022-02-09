// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class GameSnapshotSaveManagement {
    
    private static var firestore = Firestore.firestore()

    static func updateCurrentGameInformation(snapshotToUpdate gameSnap : GameSnapshot, forSnapshotIndex index : Int) {
        if let game = gameSnap.game, let hitter = gameSnap.currentHitter {
            
            let dataToSave : [String : Any] = [
                "currentInningNum" : gameSnap.currentInningNum,
                "numberAtBat" : gameSnap.numberAtBat,
                "currentEventNum" : gameSnap.eventViewModel.eventNum,
                "currentHitter" : hitter.member.memberID,
                "snapshotIndex" : index
            ]
//
//            if let pitcherHand = gameSnap.pitcherThrowingHand?.rawValue {
//                dataToSave.updateValue(pitcherHand, forKey: "pitcherThrowingHand")
//            }
//            if let hitterHand = gameSnap.hitterBattingHand?.rawValue {
//                dataToSave.updateValue(hitterHand, forKey: "hitterBattingHand")
//            }
//            if let playerAtFirst = gameSnap.playerAtFirst {
//                dataToSave.updateValue(playerAtFirst.playerOnBase.member.memberID, forKey: "playerAtFirst")
//                //dataToSave.updateValue(playerAtFirst.isEarnedRun, forKey: "isFirstEarnedRun")
//            }
//            if let playerAtSecond = gameSnap.playerAtSecond {
//                dataToSave.updateValue(playerAtSecond.playerOnBase.member.memberID, forKey: "playerAtSecond")
//               // dataToSave.updateValue(playerAtSecond.isEarnedRun, forKey: "isSecondEarnedRun")
//            }
//            if let playerAtThird = gameSnap.playerAtThird {
//                dataToSave.updateValue(playerAtThird.playerOnBase.member.memberID, forKey: "playerAtThird")
//               // dataToSave.updateValue(playerAtThird.isEarnedRun, forKey: "isThirdEarnedRun")
//            }
            firestore.collection(FirestoreKeys.Season_Collection_Name).document(game.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).document(game.gameID).setData(dataToSave, merge: true)
        }
    }
    static func saveMostRecentGameSnapshot(snapshotToSave gameSnap : GameSnapshot, forSnapshotIndex index : Int) {
        updateCurrentGameInformation(snapshotToUpdate: gameSnap, forSnapshotIndex: index)
        updateGameSnapshot(snapshotToUpdate: gameSnap)
    }
    
    static func updateGameSnapshot(snapshotToUpdate gameSnap : GameSnapshot) {
        if let game = gameSnap.game, let inning = gameSnap.currentInning, let atBat = gameSnap.currentAtBat {
            // Saves the information about the inning if necessary
            if gameSnap.newInning {
                GameSaveManagement.saveInningInformation(forGame: game, inningToSave: inning)
            }
            // Saves the informaiton about the at bat if necessary
            if gameSnap.newAtBat {
                GameSaveManagement.saveAtBatInformation(forGame: game, forInning: inning, atBatToSave: atBat)
            }
            // Saves the event information
            GameSaveManagement.saveEventInformation(forGame: game, forInning: inning, forAtBat: atBat, eventToSave: gameSnap.eventViewModel, forIndex: gameSnap.snapshotIndex)
        }
    }
    
    static func setupSnapshotIndexListener(forGame game : Game, onUpdate: @escaping (Int) -> Void) {
        // Adds a listener to the main game information
        GameSaveManagement.generateGameDocumentLink(forGame: game).addSnapshotListener { (snapshot, error) in
            // Checks if there was an error
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Checks if the snapshot data is valid and exists
                if let snapshot = snapshot, snapshot.exists {
                    let data = snapshot.data() ?? [:]
                    // Gets the current index
                    let currentIndex = data["snapshotIndex"] as? Int ?? 0
                    // Calls the onUpdate method with the specified index
                    onUpdate(currentIndex)
                }
            }
        }
    }
//
//    static func buildSnapshot(fromGame game: Game, withInningNumber currentInningNum: Int,
//                              withNumberAtBat numberAtBat: Int,
//                              withEventNum currentEventNum: Int,
//
//                       completion : @escaping (GameSnapshot, EventViewModelBuilder, [BaseStateBuilder], PitchBuilder?) -> ()) {
//        readInningInformation(fromGame: game, withInningNumber: currentInningNum) { (inning) in
//            print("Read inning \(inning.inningNum) \(numberAtBat)")
//            var curInning = inning
//            readAtBatInformation(fromGame: game, withInning: inning, withAtBatNumber: numberAtBat) { (atBat) in
//                print("Read at bat info")
//                readEventInformation(fromGame: game, withInning: inning, withAtBat: atBat, withEventNumber: currentEventNum) { (builder, currentOuts) in
//                    curInning.outsInInning = currentOuts
//                    print("Read event info")
//                    let snapshot = GameSnapshot(withGame: game, withCurrentInning: curInning, withCurrentAtBat: atBat, withCurrentInningNum: currentInningNum, withCurrentHitter: nil, withPlaceInHomeLineup: placeInHomeLineup, withPlaceInAwayLineup: placeInAwayLine, withAtBatNumber: numberAtBat, withCurrentStrikes: currentStrikes, withCurrentBalls: currentBalls, withPitchNumber: 0, withPlayerAtFirst: nil, withPlayerAtSecond: nil, withPlayerAtThird: nil, withHomeScore: homeUnearnedScore, withHomeEarnedScore: homeEarnedScore, withAwayScore: awayUnearnedScore, withAwayEarnedScore: awayEarnedScore, withEventViewModel: EventViewModel(), withPitcherThrowingHand: currentPitcherHand, withHitterBattingHand: currentHitterHand, createNewInningAtSave: false, createNewAtBatAtSave: false, withLineup: Lineup(currentHomeTeamLineup: [], totalHomeTeamRoster: [], curentAwayTeamLineup: [], totalAwayTeamRoster: []), withPitchTracker: pitchTracker)
//                    if !builder.pitchInfo.isEmpty {
//                        let pitchNumber = builder.pitchInfo["pitchNumber"] as? Int ?? 0
//                        var pitchBuilder = PitchBuilder(pitchNumber: pitchNumber)
//                        if let type = builder.pitchInfo["pitchType"] as? Int {
//                            pitchBuilder.pitchType = PitchType(rawValue: type) ?? .Fastball
//                        }
//                        if let pitchVelo = builder.pitchInfo["pitchVelo"] as? Float {
//                            pitchBuilder.pitchVelo = pitchVelo
//                        }
//                        if let pitchLocations = builder.pitchInfo["pitchLocations"] as? [Int] {
//                            var convertedLocs : [PitchLocation] = []
//                            for loc in pitchLocations {
//                                convertedLocs.append(PitchLocation(rawValue: loc) ?? .Middle)
//                            }
//                        }
//                        if let exitVelo = builder.pitchInfo["hitterExitVelo"] as? Float {
//                            pitchBuilder.hitterExitVelo = exitVelo
//                        }
//                        if let numBalls = builder.pitchInfo["numBalls"] as? Int {
//                            pitchBuilder.numBalls = numBalls
//                        }
//                        if let numStrikes = builder.pitchInfo["numStrikes"] as? Int {
//                            pitchBuilder.numStrikes = numStrikes
//                        }
//                        if let outcomeInt = builder.pitchInfo["pitchOutcome"] as? Int {
//                            pitchBuilder.pitchOutcome = PitchOutcome(rawValue: outcomeInt) ?? .IllegalPitch
//                        }
//                        if let pitcherID = builder.pitchInfo["pitcherID"] as? String {
//                            pitchBuilder.pitcherID = pitcherID
//                        }
//                        if let hitterID = builder.pitchInfo["hitterID"] as? String {
//                            pitchBuilder.hitterID = hitterID
//                        }
//                        if let pitcherHand = builder.pitchInfo["pitcherHand"] as? Int {
//                            pitchBuilder.pitcherHand = HandUsed(rawValue: pitcherHand)
//                        }
//                        if let hitterHand = builder.pitchInfo["hitterHand"] as? Int {
//                            pitchBuilder.hitterHand = HandUsed(rawValue: hitterHand)
//                        }
//                        if let ballFieldLocation = builder.pitchInfo["ballFieldLocation"] as? Int {
//                            pitchBuilder.ballFieldLocation = BallFieldLocation(rawValue: ballFieldLocation)
//                        }
//                        if let bipType = builder.pitchInfo["bipType"] as? Int {
//                            pitchBuilder.bipType = BIPType(rawValue: bipType) ?? .GB
//                        }
//                        if let bipHit = builder.pitchInfo["bipHitType"] as? [Int] {
//                            var convertedHits : [BIPHit] = []
//                            for loc in bipHit {
//                                convertedHits.append(BIPHit(rawValue: loc) ?? .Error)
//                            }
//                            pitchBuilder.bipHits = convertedHits
//                        }
//                        completion(snapshot, builder, baseStateBuilder, pitchBuilder)
//                    } else {
//                        completion(snapshot, builder, baseStateBuilder,  nil)
//                    }
//                }
//            }
//        }
//    }
    
    static func setupGameSnapshotReverseBuilder(forGame game : Game, completion : @escaping (GameSnapshot, EventViewModelBuilder, PitchBuilder?) -> ()) -> ListenerRegistration {
        let listener = firestore.collection(FirestoreKeys.Season_Collection_Name).document(game.seasonID).collection(FirestoreKeys.Season_Game_Collection_Name).document(game.gameID).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot, snapshot.exists {
                let data = snapshot.data() ?? [:]
                let placeInHomeLineup = data["placeInHomeLineup"] as? Int ?? 0
                let placeInAwayLine = data["placeInAwayLineup"] as? Int ?? 0
                let currentInningNum = data["currentInningNum"] as? Int ?? 0
                let numberAtBat = data["numberAtBat"] as? Int ?? 0
                let currentEventNum = data["currentEventNum"] as? Int ?? 0
                readInningInformation(fromGame: game, withInningNumber: currentInningNum) { (inning) in
                    readAtBatInformation(fromGame: game, withInning: inning, withAtBatNumber: numberAtBat) { (atBat) in
                        readEventInformation(fromGame: game, withInning: inning, withAtBat: atBat, withEventNumber: currentEventNum) { (builder) in
                            let snapshot = GameSnapshot(withGame: game,
                                                        withCurrentInning: inning,
                                                        withCurrentAtBat: atBat,
                                                        withCurrentInningNum: inning.inningNum,
                                                        withCurrentHitter: nil,
                                                        withAtBatNumber: Int(atBat.atBatID) ?? 0,
                                                        withPitchNumber: 0,
                                                        withEventViewModel: EventViewModel(),
                                                        createNewInningAtSave: false,
                                                        createNewAtBatAtSave: false,
                                                        withLineup: Lineup(withAwayMembers: [], withHomeMembers: []), withSnapshotIndex: builder.snapshotIndex)
                            if !builder.pitchInfo.isEmpty {
                                let pitchNumber = builder.pitchInfo["pitchNumber"] as? Int ?? 0
                                var pitchBuilder = PitchBuilder(pitchNumber: pitchNumber)
                                if let type = builder.pitchInfo["pitchThrown"] as? Int {
                                    pitchBuilder.pitchType = PitchType(rawValue: type) ?? .Fastball
                                }
                                if let pitchVelo = builder.pitchInfo["pitchVelo"] as? Float {
                                    pitchBuilder.pitchVelo = pitchVelo
                                }
                                if let pitchLocations = builder.pitchInfo["pitchLocation"] as? [Int] {
                                    var convertedLocs : [PitchLocation] = []
                                    for loc in pitchLocations {
                                        convertedLocs.append(PitchLocation(rawValue: loc) ?? .Middle)
                                    }
                                }
                                if let exitVelo = builder.pitchInfo["hitterExitVelo"] as? Float {
                                    pitchBuilder.hitterExitVelo = exitVelo
                                }
                                if let outcomeInt = builder.pitchInfo["pitchResult"] as? Int {
                                    pitchBuilder.pitchOutcome = PitchOutcome(rawValue: outcomeInt) ?? .IllegalPitch
                                }
                                if let pitcherHand = builder.pitchInfo["pitcherThrowingHand"] as? Int {
                                    pitchBuilder.pitcherHand = HandUsed(rawValue: pitcherHand)
                                }
                                if let hitterHand = builder.pitchInfo["hitterHittingHand"] as? Int {
                                    pitchBuilder.hitterHand = HandUsed(rawValue: hitterHand)
                                }
                                if let ballFieldLocation = builder.pitchInfo["ballFieldLocation"] as? Int {
                                    pitchBuilder.ballFieldLocation = BallFieldLocation(rawValue: ballFieldLocation)
                                }
                                if let bipType = builder.pitchInfo["bipType"] as? Int {
                                    pitchBuilder.bipType = BIPType(rawValue: bipType) ?? .GB
                                }
                                if let bipHit = builder.pitchInfo["bipHit"] as? [Int] {
                                    var convertedHits : [BIPHit] = []
                                    for loc in bipHit {
                                        convertedHits.append(BIPHit(rawValue: loc) ?? .Error)
                                    }
                                    pitchBuilder.bipHits = convertedHits
                                }
                                if let pitchingStyle = builder.pitchInfo["pitchingStyle"] as? Int {
                                    pitchBuilder.pitchingStyle = PitchingStyle(rawValue: pitchingStyle) ?? .Stretch
                                }
                                completion(snapshot, builder, pitchBuilder)
                            } else {
                                completion(snapshot, builder,  nil)
                            }
                        }
                    }
                }
            }
        }
        return listener
    }
    
    static func readInningInformation(fromGame game : Game, withInningNumber inningNum : Int, completion : @escaping (Inning) -> ()) {
        GameSaveManagement.generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inningNum)").getDocument { (snapshot, error) in
            if let snapshot = snapshot, snapshot.exists {
                let data = snapshot.data() ?? [:]
                let isTop = data["isTop"] as? Bool ?? false
                let inning = Inning(inningNum: inningNum, isTop: isTop, atBats: [])
                completion(inning)
            }
        }
    }
    
    static func readAtBatInformation(fromGame game : Game, withInning inning : Inning, withAtBatNumber atBatNum : Int, completion : @escaping (AtBat) -> ()) {
        GameSaveManagement.generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inning.inningNum)").collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).document("\(atBatNum)").getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot, snapshot.exists {
                let data = snapshot.data() ?? [:]
                let pitcherIDs = data["pitcherIds"] as? [String] ?? []
                let hitterIDs = data["hitterIds"] as? [String] ?? []
                let numInInning = data["numInInning"] as? Int ?? 0
                let atBat = AtBat(atBatID: "\(atBatNum)", pitcherID: pitcherIDs, hitterID: hitterIDs, numberInInning: numInInning)
                completion(atBat)
            }
        }
    }
    
    static func readEventInformation(fromGame game : Game, withInning inning : Inning, withAtBat atBat : AtBat, withEventNumber eventNum : Int, completion : @escaping (EventViewModelBuilder) -> ()) {
        GameSaveManagement.generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inning.inningNum)").collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).document("\(atBat.atBatID)").collection("Events").document("\(eventNum)").getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot, snapshot.exists {
                let data = snapshot.data() ?? [:]
                let eventNum = data["eventNum"] as? Int ?? 0
                
//                let playersInvolved = data["membersInvolved"] as? [String : Int] ?? [:]
//                let errorsInvolved = data["errorCommitted"] as? [String : Int] ?? [:]
                let eventTypes = data["eventTypes"] as? [Int] ?? []
                let pitchInfo = data["pitchEventInfo"] as? [String : Any] ?? [:]
                let eventSaves = data["basePathInfo"] as? [[String : Any]] ?? []
                let numberOuts = data["numberOfOuts"] as? Int ?? 0
                
                let runnersWhoScored = data["playersWhoScored"] as? [String] ?? []
                
                let playerAtFirstAfter = data["playerAtFirstAfter"] as? [String : Any] ?? [:]
                let playerAtSecondAfter = data["playerAtSecondAfter"] as? [String : Any] ?? [:]
                let playerAtThirdAfter = data["playerAtThirdAfter"] as? [String : Any] ?? [:]
                
                let homeScore = data["homeScore"] as? Int ?? 0
                let homeScoreEarned = data["earnedHomeScore"] as? Int ?? 0
                let awayScore = data["awayScore"] as? Int ?? 0
                let awayScoreEarned = data["earnedAwayScore"] as? Int ?? 0
                
                let placeInHomeLineup = data["placeInHomeLineup"] as? Int ?? 0
                let placeInAwayLineup = data["placeInAwayLineup"] as? Int ?? 0
                
                let numBalls = data["numBalls"] as? Int ?? 0
                let numStrikes = data["numStrikes"] as? Int ?? 0
                
                let pitcherID = data["pitcherID"] as? String ?? ""
                let hitterID = data["hitterID"] as? String ?? ""
                
                let isEndOfAtBat = data["isEndOfAtBat"] as? Bool ?? false

                let snapshotIndex = data["snapshotIndex"] as? Int ?? 0
                
                let builder = EventViewModelBuilder(eventNum: eventNum,
                                                    numberOfOuts: numberOuts,
                                                    homeScore: homeScore,
                                                    homeScoreEarned: homeScoreEarned,
                                                    awayScore: awayScore,
                                                    awayScoreEarned: awayScoreEarned,
                                                    eventTypes: eventTypes,
                                                    pitchInfo: pitchInfo,
                                                    basePathEvent: generateBasePathBuilders(withInfo: eventSaves),
                                                    playerAtFirstAfter: playerAtFirstAfter,
                                                    playerAtSecondAfter: playerAtSecondAfter,
                                                    playerAtThirdAfter: playerAtThirdAfter,
                                                    runnersWhoScored: runnersWhoScored,
                                                    placeInHomeLineup: placeInHomeLineup,
                                                    placeInAwayLineuo: placeInAwayLineup,
                                                    numBalls: numBalls,
                                                    numStrikes: numStrikes,
                                                    pitcherID: pitcherID,
                                                    hitterID: hitterID,
                                                    isEndOfAtBat: isEndOfAtBat,
                                                    snapshotIndex: snapshotIndex)
                completion(builder)
            }
        }
    }
    
    static func processEventWhenUpdated() {
        
    }

    static func updateSnapshotWhenUpdated(snapshotToMonitor snapshot : GameSnapshot, completion : @escaping (GameSnapshot, [BasePathEventInfoBuilder], [String : Any],
                                                                                                             [String : Any], [String : Any]) -> Void) {
        if let game = snapshot.game, let inning = snapshot.currentInning, let atbat = snapshot.currentAtBat {
            GameSaveManagement.generateGameDocumentLink(forGame: game).collection(FirestoreKeys.Season_Game_Innings_Collection_Name).document("\(inning.inningNum)").collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).document(atbat.atBatID).collection("Events").document("\(snapshot.snapshotIndex)").addSnapshotListener { (snap, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let snap = snap, snap.exists {
                    var currentSnapshot = snapshot
                    
                    let data = snap.data() ?? [:]
                    if let pitchInfo = data["pitchEventInfo"] as? [String : Any] {
                        if let pitchType = pitchInfo["pitchThrown"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.selectedPitchThrown = PitchType(rawValue: pitchType) ?? .None
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchType = PitchType(rawValue: pitchType) ?? .None
                        }
                        if let velo = pitchInfo["pitchVelo"] as? Float {
                            currentSnapshot.eventViewModel.pitchEventInfo?.pitchVelo = velo
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchVelo = velo
                        }
                        if let exitVelo = pitchInfo["hitterExitVelo"] as? Float {
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterExitVelo = exitVelo
                        }
                        if let locations = pitchInfo["pitchLocation"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?
                                .pitchLocations =
                                PitchLocation(rawValue: locations) ?? .Middle
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchLocation = PitchLocation(rawValue: locations)
                                ?? .Middle
                        }
                        if let outcome = pitchInfo["pitchResult"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.selectedPitchOutcome = PitchOutcome(rawValue: outcome)
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult = PitchOutcome(rawValue: outcome)
                        }
                        if let pitcherHand = pitchInfo["pitcherThrowingHand"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitcherThrowingHand = HandUsed(rawValue: pitcherHand) ?? .Right
                        }
                        if let hitterHand = pitchInfo["hitterHittingHand"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand = HandUsed(rawValue: hitterHand) ?? .Right
                        }
                        if let ballFieldLocation = pitchInfo["ballFieldLocation"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.ballLocation = BallFieldLocation(rawValue: ballFieldLocation)
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.ballFieldLocation = BallFieldLocation(rawValue: ballFieldLocation)
                        }
                        if let bipType = pitchInfo["bipType"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.selectedBIPType = BIPType(rawValue: bipType)
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipType = BIPType(rawValue: bipType)
                        }
                        if let bipHits = pitchInfo["bipHit"] as? [Int] {
                            var convertedHits : [BIPHit] = []
                            for bipHit in bipHits {
                                convertedHits.append(BIPHit(rawValue: bipHit) ?? .Error)
                            }
                            currentSnapshot.eventViewModel.pitchEventInfo?.selectedBIPHit = convertedHits
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipHit = convertedHits
                        }
                        if let pitchingStyle = pitchInfo["pitchingStyle"] as? Int {
                            currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchingStyle = PitchingStyle(rawValue: pitchingStyle) ?? .Unknown
                        }
                    }
                    var newBasePathInfoList : [BasePathEventInfoBuilder] = []
                    if let basePathEvents = data["basePathInfo"] as? [[String : Any]] {
//                        for event in basePathEvents {
//                            if let memberInvolved = event["memberInvolved"] as? String, let type = event["eventType"] as? Int {
//                                newBasePathInfoList.append(BasePathEventInfoBuilder(runnerInvolved: memberInvolved, type: BasePathType(rawValue: type) ?? .Pitch))
//                            }
//                        }
                        newBasePathInfoList = generateBasePathBuilders(withInfo: basePathEvents)
                    }
                    
                    let playerAtFirstAfter = data["playerAtFirstAfter"] as? [String : Any] ?? [:]
                    let playerAtSecondAfter = data["playerAtSecondAfter"] as? [String : Any] ?? [:]
                    let playerAtThirdAfter = data["playerAtThirdAfter"] as? [String : Any] ?? [:]
                    
                    completion(currentSnapshot, newBasePathInfoList, playerAtFirstAfter, playerAtSecondAfter, playerAtThirdAfter)
                }
            }
        }
    }
    
    static func generateBasePathBuilders(withInfo basePathEvents : [[String : Any]]) -> [BasePathEventInfoBuilder] {
        var newBasePathInfoList : [BasePathEventInfoBuilder] = []
        for event in basePathEvents {
            if let memberInvolved = event["runnerInvolved"] as? String, let type = event["type"] as? Int {
                newBasePathInfoList.append(BasePathEventInfoBuilder(runnerInvolved: memberInvolved, type: BasePathType(rawValue: type) ?? .Pitch))
            }
        }
        return newBasePathInfoList
    }
}
