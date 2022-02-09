// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase
import SwiftUI

class FirestoreManager {
    
    private static var dB : Firestore = Firestore.firestore()
    
    private static var currentListeners : [ListenerRegistration] = []
    
    static func resetAllListeners() {
        for listener in  currentListeners {
            listener.remove()
        }
        currentListeners = []
    }
    
    static func loadSeasonList(completion : @escaping ([Season]) -> Void) {
        // Stores the loaded seasons
        var seasons : [Season] = []
        // Queries the database for all of the season documents
        let observer = dB.collection(Season_Collection_Name).addSnapshotListener { (querySnapshot, error) in
            // Checks if there is an error
            if let error = error {
                print(error)
            } else {
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let seasonID : String = data[Season_ID_Field_Name] as? String ?? "Unknown"
                        let seasonYear : Int = data[Season_Year_Field_Name] as? Int ?? 0
                        let season : String = data[Season_Time_Field_Name] as? String ?? "Unknown"
                        seasons.append(Season(withSeasonID: seasonID, withSeasonYear: seasonYear, withSeasonName: season, withTeams: []))
                    }
                }
                completion(seasons)
            }
        }
        currentListeners.append(observer)
    }
    
    static func loadTeamList(forSeason seasonID : String, completion : @escaping ([Team]) -> Void) {
        // Stores the loaded teams
        var teams : [Team] = []
        // Queries the database for all of the team documents
        let observer = dB.collection(Season_Collection_Name).document(seasonID.trimmingCharacters(in: .whitespaces)).collection(Season_Team_Collection_Name).addSnapshotListener { (querySnapshot, error) in
            // Checks if there's an error
            if let error = error {
                print(error)
            } else {
                var ids: [String] = []
                
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.documentID
                        ids.append(data)
                    }
                }
                print(ids)
                if ids.count == 0 {
                    completion([])
                    return
                }
                let splitArray = ids.chunked(into: 10)
                for array in splitArray {
                    dB.collection(Team_Collection_Name).whereField("teamID", in: array).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print(error)
                        } else {
                            teams = []
                            if let documents = querySnapshot?.documents {
                                for document in documents {
                                    let data = document.data()
                                    let teamID = data["teamID"] as? String ?? "Unknown"
                                    let conference = data["conference"] as? Int ?? 0
                                    let type = data["type"] as? Int ?? 0
                                    let abbreviation = data["abbreviation"] as? String ?? "Unknown"
                                    let city = data["cityLocation"] as? String ?? "Unknown"
                                    let nickname = data["nickname"] as? String ?? "Unknown"
                                    let state = data["stateLocation"] as? String ?? "Unknown"
                                    let teamName = data["teamName"] as? String ?? "Unknown"
                                    let teamPrimaryColor = data["teamPrimaryColor"] as? String ?? "Unknown"
                                    let teamSecondaryColor = data["teamSecondaryColor"] as? String ?? "Unknown"
                                    teams.append(Team(teamID: teamID, teamName: teamName, teamAbbr: abbreviation, teamNickname: nickname, city: city, state: state, conference: conference, type: type, colorPrimary: Color.red, colorSecondary: Color.red))
                                }
                            }
                            completion(teams)
                        }
                    }
                }
            }
        }
        currentListeners.append(observer)
    }
    
    static func loadMembers(forSeason seasonID : String, forTeam teamID : String, completion : @escaping ([Member]) -> Void) {
        // Stores the loaded members
        var members : [Member] = []
        // Queries Firestore for the current team roster
        dB.collection(Season_Collection_Name).document(seasonID).collection(Season_Team_Collection_Name).document(teamID).collection(Season_Roster_Collection_Name).getDocuments { (querySnapshot, error) in
            // Checks if there was an error
            if let error = error {
                // Prints the error to the console
                print(error)
            } else {
                // Checks if documents exist
                if let documents = querySnapshot?.documents {
                    // Stores the Member ID's pulled
                    var ids : [String] = []
                    // Explores the documents, storing the member id
                    for document in documents {
                        ids.append(document.documentID)
                    }
                    print(ids)
                    if ids.count == 0 {
                        completion([])
                        return
                    }
                    let splitArray = ids.chunked(into: 10)
                    for array in splitArray {
                        // Queries Firestore for the members from the roster list
                        //dB.collection(Member_Collection_Name).whereField(Member_ID_Field_Name, in: array).getDocuments { (querySnapshot, error) in
                        let observer = dB.collection(Member_Collection_Name).whereField(Member_ID_Field_Name, in: array).addSnapshotListener { (querySnapshot, error) in
                            // Checks if there was an error
                            if let error = error {
                                // Prints the error to the console
                                print(error)
                            } else {
                                members = []
                                // Checks if the documents exist
                                if let documents = querySnapshot?.documents {
                                    // Explores the documents
//                                    for document in documents {
//                                        // Gets the data from the current document
//                                        let data = document.data()
//                                        let bio = data[Member_Bio_Field_Name] as? String ?? "Unknown"
//                                        let firstName = data[Member_First_Name_Field_Name] as? String ?? "Unknown"
//                                        let height = data[Member_Height_Field_Name] as? Int ?? 0
//                                        let highSchool = data[Member_High_School_Field_Name] as? String ?? "Unknown"
//                                        let history = data[Member_History_Field_Name] as? String ?? "Unknown"
//                                        let homeTown = data[Member_Hometown_Field_Name] as? String ?? "Unknown"
//                                        let lastName = data[Member_Last_Name_Field_Name] as? String ?? "Unknown"
//                                        let memberID = data[Member_ID_Field_Name] as? String ?? "Unknown"
//                                        let nickname = data[Member_Nickname_Field_Name] as? String ?? "Unknown"
//                                        let positions = data[Member_Positions_Field_Name] as? [Int] ?? []
//                                        let role = data[Member_Role_Field_Name] as? Int ?? 0
//                                        let weight = data[Member_Weight_Field_Name] as? Int ?? 0
//                                        var convertedPositon : [Positions] = []
//                                        for position in positions {
//                                            convertedPositon.append(Positions(rawValue: position) ?? .Bench)
//                                        }
//                                        let member = loadMembersFromDocuments(documents: [document])
//                                        members.append(member)
//                                    }
                                    members = loadMembersFromDocuments(documents: documents)
                                    completion(members)
                                }
                            }
                        }
                        self.currentListeners.append(observer)
                    }
                }
            }
        }
    }
    
    static func addMemberChangeListener(forSeason seasonID : String, forTeam teamID : String, forMembers : [String], completion : @escaping ([Member]) -> Void) {
        let splitArray = forMembers.chunked(into: 10)
        for array in splitArray {
            let observer = dB.collection(Member_Collection_Name).whereField(Member_ID_Field_Name, in: array).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
                if let documents = querySnapshot?.documents {
                    let loadedMembers = loadMembersFromDocuments(documents: documents)
                    completion(loadedMembers)
                }
            }
            currentListeners.append(observer)
        }
    }
    
    static func loadMembersFromDocuments(documents : [DocumentSnapshot]) -> [Member] {
        var members : [Member] = []
        for document in documents {
            // Gets the data from the current document
            let data = document.data() ?? [:]
            let bio = data[Member_Bio_Field_Name] as? String ?? "Unknown"
            let firstName = data[Member_First_Name_Field_Name] as? String ?? "Unknown"
            let height = data[Member_Height_Field_Name] as? Int ?? 0
            let highSchool = data[Member_High_School_Field_Name] as? String ?? "Unknown"
            let history = data[Member_History_Field_Name] as? String ?? "Unknown"
            let homeTown = data[Member_Hometown_Field_Name] as? String ?? "Unknown"
            let lastName = data[Member_Last_Name_Field_Name] as? String ?? "Unknown"
            let memberID = data[Member_ID_Field_Name] as? String ?? "Unknown"
            let nickname = data[Member_Nickname_Field_Name] as? String ?? "Unknown"
            let positions = data[Member_Positions_Field_Name] as? [Int] ?? []
            let role = data[Member_Role_Field_Name] as? Int ?? 0
            let weight = data[Member_Weight_Field_Name] as? Int ?? 0
            var convertedPositions : [Positions] = []
            for position in positions {
                convertedPositions.append(Positions(rawValue: position) ?? .Bench)
            }
            let member = Member(withID: memberID, withFirstName: firstName, withLastName: lastName, withNickname: nickname, withHeight: height, withHighSchool: highSchool, withHometown: homeTown, withPositions: convertedPositions, withWeight: weight, withBio: bio,  withRole: role, withThrowingHands: .Right, withHittingHands: .Right)
            members.append(member)
        }
        return members
    }
    
    static func getAvailableRoles(forSeason sID : String, forGame gID : String, completion : @escaping ([GameRole]) -> Void) {
        dB.collection(Season_Collection_Name).document(sID).collection("Games").document(gID).collection("Roles").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion([])
            } else {
                if let snapshot = snapshot {
                    var roles = GameRole.allCases
                    for document in snapshot.documents {
                        if let id = Int(document.documentID), let role = GameRole(rawValue: id), let index = roles.firstIndex(of: role) {
                            roles.remove(at: index)
                        }
                    }
                    completion(roles)
                } else {
                    completion([])
                }
            }
        }
    }
    
    static func setiPadToRoles(forSeason sID: String, forGame gID : String, forRoles roles : [GameRole]) {
        for role in roles {
            dB.collection(Season_Collection_Name).document(sID).collection("Games").document(gID).collection("Roles").document(String(role.rawValue)).setData([
                "roleNum" : role.rawValue,
                "iPadID" : UIDevice.current.identifierForVendor!.uuidString
            ])
        }
    }
    
    static func updateNextPitch(forGame game : Game, withPitchInfo pitch : PitchEventInfo, currentInning : Int, currentAtBat : Int, lastEvent : Int, completion : @escaping (Bool, Int, Int, Int) -> ()) {
        var curInning = currentInning
        let curEvent = lastEvent
        var curAtBat = currentAtBat
        dB.collection(Season_Collection_Name).document("SqsNEQTf1U8YRls1y2Yi").collection(Season_Games_Collection_Name).document(game.gameID).collection(Season_Games_Innings_Collection_Name).document("\(curInning)").collection(Season_Games_Innings_AtBats_Name).document("\(curAtBat)").collection(Season_Games_Innings_AtBats_Event).getDocuments { (snapshot, error) in
            if let snapshot = snapshot, !snapshot.isEmpty {
                checkForPitchToUpdate(forGame: game, forPitch: pitch, withDocuments: snapshot.documents, forLastEvent: curEvent, forCurrentInning: curInning, forCurrentAtBat: curAtBat) { (success, newEvent) in
                    if success {
                        completion(true, curInning, curAtBat, newEvent)
                    } else {
                        var maxNum = newEvent
                        for doc in snapshot.documents {
                            if let event = Int(doc.documentID) {
                                maxNum = max(event, maxNum)
                            }
                        }
                        if maxNum == newEvent {
                            curAtBat += 1
                            dB.collection(Season_Collection_Name).document("SqsNEQTf1U8YRls1y2Yi").collection(Season_Games_Collection_Name).document(game.gameID).collection(Season_Games_Innings_Collection_Name).document("\(curInning)").collection(Season_Games_Innings_AtBats_Name).getDocuments { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let snapshot = snapshot, !snapshot.isEmpty {
                                        var maxAtBat = curAtBat
                                        for doc in snapshot.documents {
                                            if let atBat = Int(doc.documentID) {
                                                maxAtBat = max(atBat, maxAtBat)
                                            }
                                        }
                                        if maxAtBat == curAtBat {
                                            curInning += 1
                                            curAtBat = 0
                                        }
                                        FirestoreManager.updateNextPitch(forGame: game, withPitchInfo: pitch, currentInning: curInning, currentAtBat: curAtBat, lastEvent: newEvent, completion: completion)
                                    }
                                }
                            }
                        } else {
                            FirestoreManager.updateNextPitch(forGame: game, withPitchInfo: pitch, currentInning: curInning, currentAtBat: curAtBat, lastEvent: newEvent, completion: completion)
                        }
                    }
                }
            } else {
                completion(false, curInning, curAtBat, curEvent)
            }
        }
    }
    
    static func checkForPitchToUpdate(forGame game : Game, forPitch pitch : PitchEventInfo, withDocuments docs : [DocumentSnapshot], forLastEvent lastEvent : Int, forCurrentInning curInning : Int, forCurrentAtBat curAtBat : Int, completion : @escaping (Bool, Int) -> Void) {
        var selectedDocument : DocumentSnapshot?
        for document in docs {
            if let curEvent = Int(document.documentID) {
                if lastEvent < curEvent {
                    let data = document.data() ?? [:]
                    let types = data["eventTypes"] as? [Int] ?? []
                    if types.contains(BasePathType.Pitch.rawValue) {
                        selectedDocument = document
                        break
                    }
                }
            }
        }
        if let doc = selectedDocument, let id = Int(doc.documentID) {
            var locations : Int = pitch.pitchLocations?.rawValue ?? 5
            dB.collection(Season_Collection_Name).document("SqsNEQTf1U8YRls1y2Yi").collection(Season_Games_Collection_Name).document(game.gameID).collection(Season_Games_Innings_Collection_Name).document("\(curInning)").collection(Season_Games_Innings_AtBats_Name).document("\(curAtBat)").collection(Season_Games_Innings_AtBats_Event).document("\(doc.documentID)").collection("Pitch").getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false, id)
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        for doc in snapshot.documents {
                            var dataToSet : [String : Any] = ["pitchLocations" : locations, "pitchThrown" : pitch.selectedPitchThrown!.rawValue]
                            if let velo = pitch.pitchVelo {
                                dataToSet.updateValue(velo, forKey: "pitchVelo")
                            }
                            dB.collection(Season_Collection_Name).document("SqsNEQTf1U8YRls1y2Yi").collection(Season_Games_Collection_Name).document(game.gameID).collection(Season_Games_Innings_Collection_Name).document("\(curInning)").collection(Season_Games_Innings_AtBats_Name).document("\(curAtBat)").collection(Season_Games_Innings_AtBats_Event).document("\(id)").collection("Pitch").document(doc.documentID).setData(dataToSet, merge: true)
                        }
                        completion(true, id)
                    } else {
                        print("No pitch found to update")
                        completion(false, id)
                    }
                }
            }
        } else {
            completion(false, lastEvent)
        }
    }
    
    static func updateInning(currentGame game : Game, inningToUpdate currentIn : Inning) {
        let inning = dB.collection(Season_Collection_Name).document("SqsNEQTf1U8YRls1y2Yi").collection(Season_Games_Collection_Name).document(game.gameID).collection(Season_Games_Innings_Collection_Name).document("\(currentIn.inningNum)")
        inning.setData([
            "inningNum" : currentIn.inningNum,
            "isTop" : currentIn.isTop
        ])
    }

    static func saveGameViewModelSnapshot(gameViewModelToSave gameViewModel : GameSnapshot, updateInning : Bool, updateAtBat : Bool) {
        if let game = gameViewModel.game, let currentIn = gameViewModel.currentInning, let currentAtBat = gameViewModel.currentAtBat, let currentPitcher = gameViewModel.getCurrentPitcher(), let currentHitter = gameViewModel.currentHitter {
            let inning = dB.collection(Season_Collection_Name).document("SqsNEQTf1U8YRls1y2Yi").collection(Season_Games_Collection_Name).document(game.gameID).collection(Season_Games_Innings_Collection_Name).document("\(currentIn.inningNum)")
            if updateInning {
                FirestoreManager.updateInning(currentGame: game, inningToUpdate: currentIn)
            }
            let atBat = inning.collection(Season_Games_Innings_AtBats_Name).document("\(currentAtBat.numberInInning)")
            if updateAtBat {
                
                var dataToSet : [String : Any] = [
                    "pitcherID" : currentAtBat.pitcherID, //currentPitcher.member.memberID,
                    "hitterID" : currentAtBat.hitterID, //currentHitter.member.memberID,
                    "numberInInning" : currentAtBat.numberInInning
                ]
                if let info = gameViewModel.eventViewModel.pitchEventInfo {
                    if let outcome = info.selectedBIPType {
                        dataToSet.updateValue(outcome.rawValue, forKey:"bipType")
                    }
                    if let location = info.ballLocation {
                        dataToSet.updateValue(location.rawValue, forKey: "ballLocation")
                    }
                    var hitTypes : [Int] = []
                    for hitType in info.selectedBIPHit {
                        hitTypes.append(hitType.rawValue)
                    }
                    dataToSet.updateValue(hitTypes, forKey: "bipHitTypes")
                }
                atBat.setData(dataToSet)
            }
            let event = atBat.collection(Season_Games_Innings_AtBats_Event).document("\(gameViewModel.eventViewModel.eventNum)")
            var membersInvolved : [String] = []
            for member in gameViewModel.eventViewModel.playersInvolved {
                membersInvolved.append(member.member.memberID)
            }
            var positionsInvolved : [Int] = []
            for member in gameViewModel.eventViewModel.playersInvolved {
                positionsInvolved.append(member.positionInGame.rawValue)
            }
            var types : [Int] = []
            if gameViewModel.eventViewModel.pitchEventInfo != nil {
                types.append(BasePathType.Pitch.rawValue)
            }
            for type in gameViewModel.eventViewModel.basePathInfo {
                types.append(type.type.rawValue)
            }
            var dataToSet : [String : Any] = [
                "eventNum" : gameViewModel.eventViewModel.eventNum,
                "membersInvolved" : membersInvolved,
                "eventTypes" : types,
                "positionsInvolved" : positionsInvolved
            ]
            var playerErrors : [String] = []
            var error : [Int] = []
            for playerError in gameViewModel.eventViewModel.playerWhoCommittedError {
                playerErrors.append(playerError.fielderInvolved.member.memberID)
                error.append(playerError.type.rawValue)
            }
            if playerErrors.count > 0 {
                dataToSet.updateValue(playerErrors, forKey: "playersWhoCommittedError")
            }
            if error.count > 0 {
                dataToSet.updateValue(error, forKey: "errorTypes")
            }
            event.setData(dataToSet)
            // Saves pitch information 
            if let newPitchInfo = gameViewModel.eventViewModel.pitchEventInfo, let newPitch = newPitchInfo.completedPitch {
                let pitch = event.collection("Pitch").document("\(newPitch.pitchNumber)")
                var dataToSet : [String : Any] = [
                    "pitchNum" : newPitch.pitchNumber
                ]
                if let locations = newPitchInfo.pitchLocations {
                    dataToSet.updateValue(locations, forKey: "pitchLocations")
                }
                if let thrown = newPitchInfo.selectedPitchThrown {
                    dataToSet.updateValue(thrown.rawValue, forKey: "pitchThrown")
                }
                if let outcome = newPitchInfo.selectedPitchOutcome {
                    dataToSet.updateValue(outcome.rawValue, forKey: "pitchOutcome")
                }
                if let velo = newPitchInfo.pitchVelo {
                    dataToSet.updateValue(velo, forKey: "pitchVelo")
                }
                if newPitchInfo.numRBI > 0 {
                    dataToSet.updateValue(newPitchInfo.numRBI, forKey: "numRBIs")
                }
                pitch.setData(dataToSet)
            }
            // Saves all other event info
            var eventIndex = 0
            for eventInfo in gameViewModel.eventViewModel.basePathInfo {
                let dataToSet : [String : Any] = [
                    "runnerInvolved" : eventInfo.runnerInvolved.member.memberID,
                    "eventType" : eventInfo.type.rawValue
                ]
                event.collection("Events").document("\(eventIndex)").setData(dataToSet)
                eventIndex += 1
            }
        }
    }
    
    private static let Season_Collection_Name = "Season"
    private static let Season_Team_Collection_Name = "Teams"
    private static let Season_Roster_Collection_Name = "Roster"
    private static let Season_Games_Collection_Name = "Games"
    private static let Season_Games_Innings_Collection_Name = "Inning"
    private static let Season_Games_Innings_AtBats_Name = "AtBats"
    private static let Season_Game_Role_Collection_Name = "Roles"
    private static let Season_Games_Innings_AtBats_Event = "Events"
    private static let Member_Collection_Name = "Member"
    
    private static let Season_ID_Field_Name = "seasonID"
    private static let Season_Year_Field_Name = "year"
    private static let Season_Time_Field_Name = "season"
    
    private static let Team_Collection_Name = "Team"
    
    private static let Member_Bio_Field_Name = "bio"
    private static let Member_First_Name_Field_Name = "firstName"
    private static let Member_Height_Field_Name = "height"
    private static let Member_High_School_Field_Name = "highschool"
    private static let Member_History_Field_Name = "history"
    private static let Member_Hometown_Field_Name = "hometown"
    private static let Member_Last_Name_Field_Name = "lastName"
    private static let Member_ID_Field_Name = "memberID"
    private static let Member_Nickname_Field_Name = "nickname"
    private static let Member_Positions_Field_Name = "positions"
    private static let Member_Role_Field_Name = "role"
    private static let Member_Weight_Field_Name = "weight"
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
