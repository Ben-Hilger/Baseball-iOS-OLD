// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class SummaryStatsGameManagement {
    
    private static let firestore = Firestore.firestore()
    
    static func loadPlayerSummaryData(forSeason season : String, forTeam team : String, forMember member : Member, completion : @escaping (SummaryStats) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(season).collection(FirestoreKeys.Season_Team_Collection_Name).document(team).collection(FirestoreKeys.Season_Team_Roster_Collection_Name).document(member.memberID).collection("HittingData").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                var summaryStats = SummaryStats(member: member)
                for document in snapshot.documents {
                    let data = document.data() ?? [:]
                    let zoneData = data["zoneData"] as? [String : Any] ?? [:]
                    let numPA = data["numPA"] as? Int ?? 0
                    let numWalks = data["numWalks"] as? Int ?? 0
                    let numHBP = data["numHBP"] as? Int ?? 0
                    let numSacFly = data["numSacFly"] as? Int ?? 0
                    let numSacBunt = data["numSacBunt"] as? Int ?? 0
                    let numAtBats = data["numAtBats"] as? Int ?? 0
                    var summaryData = GameSummaryStats(dateOfGame: Date(), numPA: numPA, numWalks: numWalks, numHBP: numHBP, numSacFly: numSacFly, numSacBunt: numSacBunt, numAtBats: numAtBats)
                    for zone in zoneData {
                        let zoneD = zone.value as? [String : Int] ?? [:]
                        let num1B = zoneD["num1B"] ?? 0
                        let num2B = zoneD["num2B"] ?? 0
                        let num3B = zoneD["num3B"] ?? 0
                        let numBABIP = zoneD["numBABIP"] ?? 0
                        let numBIP = zoneD["numBIP"] ?? 0
                        let numHR = zoneD["numHR"] ?? 0
                        let numHit = zoneD["numHit"] ?? 0
                        let numSM = zoneD["numSM"] ?? 0
                        let numCS = zoneD["numCS"] ?? 0
                        let numFB = zoneD["numFoulBall"] ?? 0
                        let numBalls = zoneD["numBalls"] ?? 0
                        let numBallsWildPitch = zoneD["numBallsWildPitch"] ?? 0
                        let numBallsPassedBall = zoneD["numBallsPassedBall"] ?? 0
                        summaryData.zones.append(ZoneData(zone: Int(zone.key) ?? 0, num1B: num1B, num2B: num2B, num3B: num3B, numBABIP: numBABIP, numBIP: numBIP, numHR: numHR, numHit: numHit, numSM: numSM, numCS: numCS, numFoulBall: numFB, numBalls: numBalls, numBallsWildPitch: numBallsWildPitch, numBallssPassedBall: numBallsPassedBall))
                        summaryStats.gamesPlayed.append(summaryData)
                    }
                }
                completion(summaryStats)
            }
        }
    }
    
}
