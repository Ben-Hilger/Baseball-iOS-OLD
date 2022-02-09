// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase
import SwiftUI

class TeamSaveManagement {
    
    private static var firestore = Firestore.firestore()
    
    static func loadTeam(withTeamID teamID : String, completion : @escaping (Team) -> Void) {
        firestore.collection("Team").document(teamID).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot, snapshot.exists {
                if let data = snapshot.data(),
                let teamName = data["teamName"] as? String,
                let teamAbbr = data["abbreviation"] as? String,
                let teamNickname = data["nickname"] as? String,
                let city = data["cityLocation"] as? String,
                let state = data["stateLocation"] as? String,
                let conference = data["conference"] as? Int,
                let teamType = data["type"] as? Int,
                let rgbPrimary = data["teamPrimaryColor"] as? [Double],
                let rgbSecondary = data["teamSecondaryColor"] as? [Double] {
                    let primary = Color(.sRGB, red: rgbPrimary[0], green: rgbPrimary[1], blue: rgbPrimary[2], opacity: 1)
                    let secondary = Color(.sRGB, red: rgbSecondary[0], green: rgbSecondary[1], blue: rgbSecondary[2], opacity: 1)
                    let team = Team(teamID: snapshot.documentID, teamName: teamName, teamAbbr: teamAbbr, teamNickname: teamNickname, city: city, state: state, conference: conference, type: teamType, colorPrimary: primary, colorSecondary: secondary)
                    completion(team)
                }
            }
        }
    }
    
    static func loadAllAvailableTeams(completion : @escaping ([Team]) -> Void) {
        firestore.collection("Team").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                var teams : [Team] = []
                for document in snapshot.documents {
                    let data = document.data()
                    if let teamName = data["teamName"] as? String,
                    let teamAbbr = data["abbreviation"] as? String,
                    let teamNickname = data["nickname"] as? String,
                    let city = data["cityLocation"] as? String,
                    let state = data["stateLocation"] as? String,
                    let conference = data["conference"] as? Int,
                    let teamType = data["type"] as? Int,
                    let rgbPrimary = data["teamPrimaryColor"] as? [Double],
                    let rgbSecondary = data["teamSecondaryColor"] as? [Double] {
                        let primary = Color(.sRGB, red: rgbPrimary[0], green: rgbPrimary[1], blue: rgbPrimary[2], opacity: 1)
                        let secondary = Color(.sRGB, red: rgbSecondary[0], green: rgbSecondary[1], blue: rgbSecondary[2], opacity: 1)
                        let team = Team(teamID: document.documentID, teamName: teamName, teamAbbr: teamAbbr, teamNickname: teamNickname, city: city, state: state, conference: conference, type: teamType, colorPrimary: primary, colorSecondary: secondary)
                        teams.append(team)
                    }
                }
                completion(teams)
            } else {
                completion([])
            }
        }
    }
 
    static func loadTeams(fromSeason season : Season, completion : @escaping (Team) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).document(season.seasonID).collection(FirestoreKeys.Season_Team_Collection_Name).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                var ids : [String] = []
                for document in snapshot.documents {
                    ids.append(document.documentID)
                }
                var arrays = ids.chunked(into: 10)
                for array in arrays {
                    for id in array {
                        firestore.collection("Team").document(id).getDocument { (docSnapshot, error) in
                            if let docSnapshot = docSnapshot {
                                if let team = self.loadTeamFromSnapshot(withSnapshot: docSnapshot) {
                                    completion(team)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func saveTeam(toSeason season : Season, withTeam team : Team) -> String {
        let teamRefCol = firestore.collection(FirestoreKeys.Season_Collection_Name).document(season.seasonID).collection(FirestoreKeys.Season_Team_Collection_Name)
        var teamRef : DocumentReference!
        if team.teamID == "" {
            teamRef = teamRefCol.document()
        } else {
            teamRef = teamRefCol.document(team.teamID)
        }
        teamRef.setData([
            "numLosses" : 0,
            "numWins" : 0
        ])
        let rosterRef = teamRef.collection(FirestoreKeys.Season_Team_Roster_Collection_Name)
        for member in team.members {
            rosterRef.document(member.memberID).setData([
                "class" : member.playerClass.rawValue,
                "redshirt" : member.isRedshirt,
                "uniformNumber" : member.uniformNumber
            ])
        }
        return teamRef.documentID
    }
    
    static func saveTeam(withTeam team : Team) {
        let teamRef = firestore.collection("Team").document(team.teamID)
        teamRef.setData([
            "teamName" : team.teamName,
            "abbreviation" : team.teamAbbr,
            "nickname" : team.teamNickname,
            "cityLocation" : team.cityLocation,
            "stateLocation" : team.stateLocation,
            "conference" : team.conference.rawValue,
            "type" : team.teamType.rawValue,
            "teamPrimaryColor" : [team.teamPrimaryColor.description],
            "teamSecondaryColor" : [team.teamSecondaryColor.description],
            "teamID" : team.teamID
        ])
    }
    
    static func loadTeamFromSnapshot(withSnapshot snapshot : DocumentSnapshot) -> Team? {
        let data = snapshot.data() ?? [:]
        if let teamName = data["teamName"] as? String,
        let teamAbbr = data["abbreviation"] as? String,
        let teamNickname = data["nickname"] as? String,
        let city = data["cityLocation"] as? String,
        let state = data["stateLocation"] as? String,
        let conference = data["conference"] as? Int,
        let teamType = data["type"] as? Int,
        let rgbPrimary = data["teamPrimaryColor"] as? [Double],
        let rgbSecondary = data["teamSecondaryColor"] as? [Double] {
            let primary = Color(.sRGB, red: rgbPrimary[0], green: rgbPrimary[1], blue: rgbPrimary[2], opacity: 1)
            let secondary = Color(.sRGB, red: rgbSecondary[0], green: rgbSecondary[1], blue: rgbSecondary[2], opacity: 1)
            let team = Team(teamID: snapshot.documentID, teamName: teamName, teamAbbr: teamAbbr, teamNickname: teamNickname, city: city, state: state, conference: conference, type: teamType, colorPrimary: primary, colorSecondary: secondary)
            return team
        }
        return nil
    }
}
