// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class LineupSaveManagement {
    
    private static let firestore = Firestore.firestore()
    
    static func saveLineupChange(gameToSave game : Game, changeToSubmit change : LineupChange) {
        var homeLineup : [[String : Int]] = []
        var awayLineup : [[String : Int]] = []
        
        var homeDhMap : [String : String] = [:]
        var awayDhMap : [String : String] = [:]
        
        for memberIndex in 0..<change.newHomeTeamLineup.count {
            homeLineup.append([change.newHomeTeamLineup[memberIndex].member.memberID : change.newHomeTeamLineup[memberIndex].positionInGame.rawValue])
            if let dh = change.newHomeTeamLineup[memberIndex].dh {
                homeDhMap.updateValue(dh.memberID, forKey: change.newHomeTeamLineup[memberIndex].member.memberID)
            }
       //     homeLineup[memberIndex].updateValue(change.newHomeTeamLineup[memberIndex].positionInGame.rawValue, forKey: change.newHomeTeamLineup[memberIndex].member.memberID)
        }
        for memberIndex in 0..<change.newAwayTeamLineup.count {
            awayLineup.append([change.newAwayTeamLineup[memberIndex].member.memberID: change.newAwayTeamLineup[memberIndex].positionInGame.rawValue])
           // awayLineup[memberIndex].updateValue(change.newAwayTeamLineup[memberIndex].positionInGame.rawValue, forKey: change.newAwayTeamLineup[memberIndex].member.memberID)
            if let dh = change.newAwayTeamLineup[memberIndex].dh {
                awayDhMap.updateValue(dh.memberID, forKey: change.newAwayTeamLineup[memberIndex].member.memberID)
            }
        }
//        GameSaveManagement.generateGameDocumentLink(forGame: game).collection("Lineup").addDocument(data: [
//            "pitchNumber" : change.pitchNumChanged,
//            "homeLineup" : homeLineup,
//            "awayLineup" : awayLineup
//        ])
        GameSaveManagement.generateGameDocumentLink(forGame: game).collection("Lineup").document("0").setData([
            "pitchNumber" : change.pitchNumChanged,
            "homeLineup" : homeLineup,
            "awayLineup" : awayLineup,
            "homeDHMap" : homeDhMap,
            "awayDHMap" : awayDhMap
        ])
    }
    
    static func loadInitialLineupBuilder(forGame game : Game, completion : @escaping (LineupChangeBuilder) -> Void) {
        GameSaveManagement.generateGameDocumentLink(forGame: game).collection("Lineup").document("0").getDocument { (snapshot, error) in
            // Checks if there was an error
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot, snapshot.exists {
                // Gets the newest snapshot
                let data = snapshot.data() ?? [:]
                if let pitchNumber = data["pitchNumber"] as? Int,
                   let homeLineup = data["homeLineup"] as? [[String : Int]],
                   let awayLineup = data["awayLineup"] as? [[String : Int]],
                   let homeDHMap = data["homeDHMap"] as? [String : String],
                   let awayDHMap = data["awayDHMap"] as? [String : String]{
                    completion(LineupChangeBuilder(homeLineupChange: homeLineup,
                                                   awayLineupChange: awayLineup,
                                                   pitchNumberChanged: pitchNumber,
                                                   homeDHMap: homeDHMap,
                                                   awayDHMap: awayDHMap))
                }
                
            }
        }
    }
    
    static func configureLineupUpdateReverseBuilder(forGame game : Game, completion: @escaping (LineupChangeBuilder) -> Void) {
        GameSaveManagement.generateGameDocumentLink(forGame: game).collection("Lineup").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                // Gets the newest snapshot
                if let document = snapshot.documentChanges.last?.document {
                    let data = document.data()
                    if let pitchNumber = data["pitchNumber"] as? Int,
                       let homeLineup = data["homeLineup"] as? [[String : Int]],
                       let awayLineup = data["awayLineup"] as? [[String : Int]],
                       let homeDHMap = data["homeDHMap"] as? [String : String],
                       let awayDHMap = data["awayDHMap"] as? [String : String] {
                        completion(LineupChangeBuilder(homeLineupChange: homeLineup,
                                                       awayLineupChange: awayLineup,
                                                       pitchNumberChanged: pitchNumber,
                                                       homeDHMap: homeDHMap,
                                                       awayDHMap: awayDHMap))
                    }
                }
            }
        }
    }
    
}
