// Copyright 2021 Benjamin Hilger

import Foundation
import Combine
import Firebase
import SwiftUI

struct FireKeys {
    static let SeasonKey = "Season"
    static let TeamKey = "Team"
    static let MemberKey = "Member"
    static let SeasonTeamKey = "Teams"
}

struct RosterLoadInfo {
    var team: Team
    var rosterIds: [String]
    var extraRosterInfo: [String: [String: AnyHashable]]
}

class FirebaseLifecycle: ObservableObject {
    
    var loginPublisher = PassthroughSubject<User, Error>()
    
    // Pushlisher to manage loading a season
    var loadSeasonPublisher = PassthroughSubject<[String], Error>()
    
    // Publisher to manage loading games
    var gamePublisher = PassthroughSubject<Season, Error>()
    
    // Publisher to manage loading teams of a given season
    var teamPublisher = PassthroughSubject<Season, Error>()
    
    // Publisher to manage loading rosters
    var rosterPublisher = PassthroughSubject<RosterLoadInfo, Error>()
    
    // Store all of the publishers
    var cancellables = Set<AnyCancellable>()
    
    // Store all of the seasons loaded
    @Published var seasons: [Season] = []
    
    // Store the teams and games from a selected season
    @Published var teams: [Team] = []
    @Published var games: [Game] = []
    
    init() {
        // Configure and load all seasons
        // Also configure team and roster loader
        configureRosterLoader()
        configureTeamLoader()
        configureSeasonLoader()
        loadSeasonPublisher.send([])
    }
    
    func configureRosterLoader() {
        rosterPublisher.sink { (result) in
            switch result {
            case .failure(let error):
                print("Unable to load teams for season")
            case .finished:
                print("Loaded teams")
            }
        } receiveValue: { (rosterInfo) in
            if let teamIndex = self.teams.firstIndex(of: rosterInfo.team) {
                self.teams[teamIndex].members = []
                var playerRosterChunked: [[String]] = rosterInfo.rosterIds.chunked(into: 10)
                for players in playerRosterChunked {
                    Firestore.firestore().collection(FireKeys.MemberKey).whereField("memberID", in: players).getDocuments { (query, error) in
                        if let error = error {
                            print(error)
                        } else if let query = query {
                            for document in query.documents {
                                let data = document.data()
                                if let bio = data["bio"] as? String,
                                   let firstName = data["firstName"] as? String,
                                   let height = data["height"] as? Int,
                                   let highschool = data["highschool"] as? String,
                                   let hittingHand = data["hittingHand"] as? Int,
                                   let hometown = data["hometown"] as? String,
                                   let lastName = data["lastName"] as? String,
                                   let memberID = data["memberID"] as? String,
                                   let nickname = data["nickname"] as? String,
                                   let positions = data["positions"] as? [Int],
                                   let role = data["role"] as? Int,
                                   let throwingHand = data["throwingHand"] as? Int,
                                   let weight = data["weight"] as? Int {
                                    var newMember = Member(withID: memberID, withFirstName: firstName,
                                                           withLastName: lastName, withNickname: nickname,
                                                           withHeight: height, withHighSchool: highschool,
                                                           withHometown: hometown, withPositions: positions,
                                                           withWeight: weight, withBio: bio, withRole: role,
                                                           withThrowingHands: throwingHand, withHittingHands: hittingHand)
                                    if let memberInfo = rosterInfo.extraRosterInfo[memberID],
                                       let unfiormNumber = memberInfo["uniformNumber"] as? Int,
                                       let playerClass = memberInfo["playerClass"] as? Int,
                                       let isRedshirt = memberInfo["isRedshirt"] as? Bool {
                                        newMember.uniformNumber = unfiormNumber
                                        newMember.playerClass = PlayerClass(rawValue: playerClass) ?? .Freshmen
                                        newMember.isRedshirt = isRedshirt
                                    }
                                    self.teams[teamIndex].members.append(newMember)
                                }
                            }
                        }
                    }
                }
            }
        }.store(in: &cancellables)

    }
    
    func configureTeamLoader() {
        teamPublisher.sink { (result) in
            switch result {
            case .failure(let error):
                print("Unable to load teams for season")
            case .finished:
                print("Teams loaded")
            }
        } receiveValue: { (season) in
            self.teams = []
            Firestore.firestore().collection(FireKeys.SeasonKey)
                .document(season.seasonID).collection(FireKeys.SeasonTeamKey).getDocuments { (query, error) in
                    if let error = error {
                        print(error)
                    } else if let query = query {
                        var teamRosters: [String: [String : AnyHashable]] = [:]
                        var teamIds: Set<String> = Set()
                        for document in query.documents {
                            let data = document.data()
                            if let roster = data["roster"] as? [String: AnyHashable],
                               let memberID = roster["memberID"] as? String {
                                teamRosters.updateValue(roster,
                                                        forKey: memberID)
                                teamIds.insert(document.documentID)
                            }
                        }
                        Firestore.firestore().collection(FireKeys.TeamKey)
                            .whereField("teamID", in: Array(teamIds))
                            .getDocuments { (query, error) in
                                if let error = error {
                                    print(error)
                                } else if let query = query {
                                    for document in query.documents {
                                        let teamData = document.data()
                                        if let abbrev = teamData["abbreviation"] as? String,
                                           let city = teamData["cityLocation"] as? String,
                                           let conference = teamData["conference"] as? Int,
                                           let nickname = teamData["nickname"] as? String,
                                           let state = teamData["stateLocation"] as? String,
                                           let teamID = teamData["teamID"] as? String,
                                           let name = teamData["teamName"] as? String,
                                           let primaryColor = teamData["teamPrimaryColor"] as? [Double],
                                           let secondaryColor = teamData["teamSecondaryColor"] as? [Double],
                                           let type = teamData["type"] as? Int {
                                            let team: Team = Team(teamID: teamID, teamName: name,
                                                                  teamAbbr: abbrev, teamNickname: nickname,
                                                                  city: city, state: state, conference: conference,
                                                                  type: type,
                                                                  colorPrimary: Color(.sRGB, red: primaryColor[0], green: primaryColor[1], blue: primaryColor[2], opacity: 1),
                                                                  colorSecondary: Color(.sRGB, red: secondaryColor[0], green: secondaryColor[1], blue: secondaryColor[2], opacity: 1))
                                                                                
                                            self.teams.append(team)
                                            // Send team to roster publisher to load members
                                            self.rosterPublisher.send(RosterLoadInfo(team: team,
                                                                                     rosterIds: teamRosters.keys.sorted(),
                                                                                     extraRosterInfo: teamRosters))
                                        }
                                    }
                                }
                        }
                    }
                }
        }.store(in: &cancellables)

    }
 
    func configureSeasonLoader() {
        loadSeasonPublisher.sink { (result) in
            switch result {
            case .failure(let error):
                print("Unable to load season: \(error)")
            case .finished:
                print("Loaded Season")
            }
        } receiveValue: { (seasonIDs) in
            self.seasons = []
            Firestore.firestore().collection(FireKeys.SeasonKey).getDocuments { (query, error) in
                // Check if there was an error
                if let error = error {
                    print(error)
                } else if let query = query {
                    for document in query.documents {
                        let data = document.data()
                        if let seasonName = data["season"] as? String,
                           let seasonID = data["seasonID"] as? String,
                           let year = data["year"] as? Int {
                            let season = Season(withSeasonID: seasonID,
                                                withSeasonYear: year,
                                                withSeasonName: seasonName)
                            self.seasons.append(season)
                        }
                    }
                }
            }
        }.store(in: &cancellables)
    }
    
}
