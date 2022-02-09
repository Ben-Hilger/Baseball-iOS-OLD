// Copyright 2021-Present Benjamin Hilger

import Foundation
import SwiftUI

class Season : Identifiable, Equatable, ObservableObject {
    
    // Stores the unique id of the object
    @Published var id = UUID()
    
    // Stores the id of the season
    @Published var seasonID : String
    
    // Stores the year the season is occuring
    @Published var seasonYear : Int
    // Stores the name of the season (Winter, Fall, Spring, Summer)
    @Published var seasonName : String

    // Stores all of the teams within this season
    @Published var teams : [Team] = []
    
    // Stores all of the games within this season
    @Published var games : [Game] = []
    
    init(withSeasonID sID : String, withSeasonYear year : Int, withSeasonName sName : String) {
        seasonID = sID
        seasonYear = year
        seasonName = sName
    }
    
    init(withSeasonID sID : String, withSeasonYear year : Int, withSeasonName sName : String, withTeams t : [Team]) {
        seasonID = sID
        seasonYear = year
        seasonName = sName
        teams = t
    }
    
    func getFullSeasonName() -> String {
        return "\(seasonName) \(seasonYear)"
    }
    
    /// Retrieves the year the season is occuring
    /// - Returns: An Int of year the season is occurring
    func getSeasonYear() -> Int {
        return seasonYear
    }
    
    /// Retrieves the name of the season (Winter, Fall, Spring, Summer)
    /// - Returns: A string containing the name of the season
    func getSeason() -> String {
        return seasonName
    }
    
    static func == (lhs: Season, rhs: Season) -> Bool {
        return lhs.seasonID == rhs.seasonID
    }
}


let seasonTestData : [Season] = [
    Season(withSeasonID: "S100", withSeasonYear: 2017, withSeasonName: "Fall", withTeams: [Team(teamID: "T100", teamName: "Miami Redhawks", teamAbbr: "MU", teamNickname: "Redhawks", city: "Oxford", state: "Ohio", conference: 6, type: 1, colorPrimary: Color.red, colorSecondary: Color.black, withMembers: [
                                                                                                    Member(withID: "M100", withFirstName: "Ben", withLastName: "Hilger1", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Switch),
                                                                                                    Member(withID: "M101", withFirstName: "Ben", withLastName: "Hilger2", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Switch),
                                                                                                    Member(withID: "M102", withFirstName: "Ben", withLastName: "Hilger3", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Switch)
    ,Member(withID: "M103", withFirstName: "Ben", withLastName: "Hilger4", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
    ,Member(withID: "M104", withFirstName: "Ben", withLastName: "Hilger5", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
    ,Member(withID: "M105", withFirstName: "Ben", withLastName: "Hilger6", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
    ,Member(withID: "M106", withFirstName: "Ben", withLastName: "Hilger7", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
    ,Member(withID: "M107", withFirstName: "Ben", withLastName: "Hilger8", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
    ,Member(withID: "M108", withFirstName: "Ben", withLastName: "Hilger9", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)]),
        Team(teamID: "T109", teamName: "Ohio Bobcats", teamAbbr: "OU", teamNickname: "Redhawks", city: "Oxford", state: "Ohio", conference: 6, type: 1, colorPrimary: Color.green, colorSecondary: Color.black, withMembers: [
                Member(withID: "M109", withFirstName: "B", withLastName: "H1", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Switch, withHittingHands: .Right),
            Member(withID: "M110", withFirstName: "B", withLastName: "H2", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M111", withFirstName: "B", withLastName: "H3", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M112", withFirstName: "B", withLastName: "H4", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M113", withFirstName: "B", withLastName: "H5", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M114", withFirstName: "B", withLastName: "H6", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M115", withFirstName: "B", withLastName: "H7", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M116", withFirstName: "B", withLastName: "H8", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right),
            Member(withID: "M117", withFirstName: "B", withLastName: "H9", withNickname: "Ben", withHeight: 65, withHighSchool: "Olentangy", withHometown: "Lewis Center", withPositions: [], withWeight: 150, withBio: "",  withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
        ])]),
    Season(withSeasonID: "S101", withSeasonYear: 2018, withSeasonName: "Spring", withTeams: [])
    ]
