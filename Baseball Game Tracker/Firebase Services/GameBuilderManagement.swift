// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class GameBuilderManagement {
    
    private static let firestore = Firestore.firestore()
    
    static func rebuildGame(forGame game : Game, completion: @escaping (GameSnapshot?, EventViewModelBuilder?, PitchBuilder?) -> Void) {
        print("Loading Game: \(game.gameID)")
        let gameDoc = GameSaveManagement.generateGameDocumentLink(forGame: game)
        print("DOC: \(gameDoc.documentID)")
        let inningCollection = gameDoc.collection(FirestoreKeys.Season_Game_Innings_Collection_Name)
        inningCollection.getDocuments { (querySnapshot, error) in
            print("sdsdsd")
            if let error = error {
                print(error.localizedDescription)
            } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                // Get all of the innings
                for document in querySnapshot.documents {
                    if let inningNum = Int(document.documentID) {
                        inningCollection.document(document.documentID).collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).getDocuments { (queryS, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else if queryS?.isEmpty ?? true {
                                completion(nil, nil, nil)
                            } else if let queryS = queryS, !queryS.isEmpty {
                                for document in queryS.documents {
                                    if let numberAtBat = Int(document.documentID) {
                                        inningCollection.document("\(inningNum)").collection(FirestoreKeys.Season_Game_Innings_AtBat_Collection_Name).document("\(numberAtBat)").collection("Events").getDocuments { (query, error) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                            } else if let query = query, !query.isEmpty {
                                                for eventDocument in query.documents {
                                                    if let currentEventNum = Int(eventDocument.documentID) {
                                                        GameSnapshotSaveManagement.readInningInformation(fromGame: game, withInningNumber: inningNum) { (inning) in
                                                            GameSnapshotSaveManagement.readAtBatInformation(fromGame: game, withInning: inning, withAtBatNumber: numberAtBat) { (atBat) in
                                                                GameSnapshotSaveManagement.readEventInformation(fromGame: game, withInning: inning, withAtBat: atBat, withEventNumber: currentEventNum) { (builder) in
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
                                                                            if let pitchLocations = builder.pitchInfo["pitchLocation"] as? Int, let pitchLoc = PitchLocation(rawValue: pitchLocations) {
                                                                                pitchBuilder.pitchLocations = pitchLoc
                                                                            }
                                                                            if let exitVelo = builder.pitchInfo["hitterExitVelo"] as? Float {
                                                                                pitchBuilder.hitterExitVelo = exitVelo
                                                                            }
                                                                            if let outcomeInt = builder.pitchInfo["pitchResult"] as? Int {
                                                                                pitchBuilder.pitchOutcome = PitchOutcome(rawValue: outcomeInt) ?? .IllegalPitch
                                                                            }
                                                                            if let pitcherID = builder.pitchInfo["pitcherID"] as? String {
                                                                                pitchBuilder.pitcherID = pitcherID
                                                                            }
                                                                            if let hitterID = builder.pitchInfo["hitterID"] as? String {
                                                                                pitchBuilder.hitterID = hitterID
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
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

