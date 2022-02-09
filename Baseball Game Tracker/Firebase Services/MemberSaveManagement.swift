// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class MemberSaveManagement {
    
    private static var firestore = Firestore.firestore()
    
    static func loadMembers(completion : @escaping ([Member]) -> Void) {
        firestore.collection("Member").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    var members : [Member] = []
                    for document in snapshot.documents {
                        let data = document.data()
                        if let firstName = data["firstName"] as? String,
                           let lastName = data["lastName"] as? String,
                           let nickName = data["nickname"] as? String
                            {
                            let positions = data["positions"] as? [Int] ?? []
                            let height = data["height"] as? Int ?? 0
                            let highSchool = data["highschool"] as? String ?? "No High School"
                            let hometown = data["hometown"] as? String ?? "No Hometown"
                            let weight = data["weight"] as? Int ?? 0
                            let bio = data["bio"] as? String ?? "No Bio"
                            let role = data["role"] as? Int ?? 0
                            var convertedPositions : [Positions] = []
                            for position in positions {
                                convertedPositions.append(Positions(rawValue: position) ?? .Bench)
                            }
                            let throwingHands = data["throwingHand"] as? Int ?? 0
                            let hittingHand = data["hittingHand"] as? Int ?? 0
                            let member = Member(withID: document.documentID, withFirstName: firstName, withLastName: lastName, withNickname: nickName, withHeight: height, withHighSchool: highSchool, withHometown: hometown, withPositions: convertedPositions, withWeight: weight, withBio: bio, withRole: role, withThrowingHands: HandUsed(rawValue: throwingHands) ?? .Right, withHittingHands: HandUsed(rawValue: hittingHand) ?? .Right)
                            members.append(member)
                        }
                    }
                    completion(members)
                } else {
                    completion([])
                }
            }
        }
    }
    
    static func loadMemberInformation(withSeasonID seasonID: String,
                                      withTeamID teamID: String,
                                      completion: @escaping (Member) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(seasonID)
            .collection(FirestoreKeys.Season_Team_Collection_Name).document(teamID)
            .collection(FirestoreKeys.Season_Team_Roster_Collection_Name).getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let snapshot = snapshot {
                    var ids : [String] = []
                    var memberTeamData : [String : [String : Any]] = [:]
                    for document in snapshot.documents {
                        ids.append(document.documentID)
                        let data = document.data()
                        if let playerClass = data["class"] as? Int,
                           let redshirt = data["redshirt"] as? Bool,
                           let  uniformNumber = data["uniformNumber"] as? Int {
                            memberTeamData.updateValue([
                                "class" : playerClass,
                                "redshirt" : redshirt,
                                "uniformNumber" : uniformNumber
                            ], forKey: document.documentID)
                        }
                    }
                    let arrays = ids.chunked(into: 10)
                    for array in arrays {
                        for playerID in array {
                            firestore.collection("Member").document(playerID).getDocument { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else if let snapshot = snapshot {
                                    if var member = loadMemberFromSnapshot(withSnapshot: snapshot) {
                                        let information = memberTeamData[member.memberID]
                                        if let playerClass = information?["class"] as? Int,
                                           let redshirt = information?["redshirt"] as? Bool,
                                           let uniformNum = information?["uniformNumber"] as? Int {
                                            member.playerClass = PlayerClass(rawValue: playerClass) ?? .Freshmen
                                            member.isRedshirt = redshirt
                                            member.uniformNumber = uniformNum
                                        }
                                        completion(member)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    static func loadMemberTeamInformation(withSeason season : Season, withTeam team : Team, completion : @escaping (Member) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(season.seasonID).collection(FirestoreKeys.Season_Team_Collection_Name).document(team.teamID).collection(FirestoreKeys.Season_Team_Roster_Collection_Name).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                var ids : [String] = []
                var memberTeamData : [String : [String : Any]] = [:]
                for document in snapshot.documents {
                    ids.append(document.documentID)
                    let data = document.data()
                    if let playerClass = data["class"] as? Int,
                       let redshirt = data["redshirt"] as? Bool,
                       let  uniformNumber = data["uniformNumber"] as? Int {
                        memberTeamData.updateValue([
                            "class" : playerClass,
                            "redshirt" : redshirt,
                            "uniformNumber" : uniformNumber
                        ], forKey: document.documentID)
                    }
                }
                let arrays = ids.chunked(into: 10)
                for array in arrays {
                    for playerID in array {
                        firestore.collection("Member").document(playerID).getDocument { (snapshot, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else if let snapshot = snapshot {
                                if var member = loadMemberFromSnapshot(withSnapshot: snapshot) {
                                    let information = memberTeamData[member.memberID]
                                    if let playerClass = information?["class"] as? Int,
                                       let redshirt = information?["redshirt"] as? Bool,
                                       let uniformNum = information?["uniformNumber"] as? Int {
                                        member.playerClass = PlayerClass(rawValue: playerClass) ?? .Freshmen
                                        member.isRedshirt = redshirt
                                        member.uniformNumber = uniformNum
                                    }
                                    completion(member)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private static func loadMemberFromSnapshot(withSnapshot snapshot : DocumentSnapshot) -> Member? {
        let data = snapshot.data() ?? [:]
        var id = snapshot.documentID
        if let firstName = data["firstName"] as? String,
           let lastName = data["lastName"] as? String,
           let nickName = data["nickname"] as? String,
           let height = data["height"] as? Int,
           let highSchool = data["highschool"] as? String,
           let hometown = data["hometown"] as? String,
           let weight = data["weight"] as? Int,
           let bio = data["bio"] as? String,
           let role = data["role"] as? Int {
            let positions = data["positions"] as? [Int] ?? []
            
            var convertedPositions : [Positions] = []
            for position in positions {
                convertedPositions.append(Positions(rawValue: position) ?? .Bench)
            }
            let throwingHands = data["throwingHand"] as? Int ?? 0
            let hittingHand = data["hittingHand"] as? Int ?? 0
            let member = Member(withID: id, withFirstName: firstName, withLastName: lastName, withNickname: nickName, withHeight: height, withHighSchool: highSchool, withHometown: hometown, withPositions: convertedPositions, withWeight: weight, withBio: bio, withRole: role, withThrowingHands: HandUsed(rawValue: throwingHands) ?? .Right, withHittingHands: HandUsed(rawValue: hittingHand) ?? .Right)
            return member
        }
        return nil
    }
}
