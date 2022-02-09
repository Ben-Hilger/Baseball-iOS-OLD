// Copyright 2021-Present Benjamin Hilger

import Foundation
import Combine

class SeasonViewModel : ObservableObject {
    
    @Published var seasons : [Season] = []
    @Published var currentSeasonIndex : Int?
    @Published var currentTeamIndex : Int?
    
    @Published var gameAdding : Game?
    
    @Published var lineupEditing : LineupViewModel = LineupViewModel(withLineup: Lineup(withAwayMembers: [], withHomeMembers: []))
    
    @Published var series: [Series] = []
    
    init() {
        SeasonSaveManagement.loadAvailableSeasons { (seasons) in
            self.seasons = seasons
        }
    }
    
    func updateSeasons() {
        SeasonSaveManagement.loadAvailableSeasons { (seasons) in
            // Explores the different seasons
            for season in seasons {
                // Checks if the season current exists
                if let index = seasons.firstIndex(of: season) {
                    // Updates the season
                    self.seasons[index] = season
                } else {
                    // Adds the new season to the list
                    self.seasons.append(season)
                }
            }
        }
    }
    
    func setCurrentSeason(seasonToSet season : Season) {
        // Checks to make sure the season exists
        if let seasonIndex = seasons.firstIndex(of: season) {
            currentSeasonIndex = seasonIndex
            // Checks if the team information needs to be loaded
            if seasons[seasonIndex].teams.count == 0 {
                // Loads the season information
                //loadSeasonInformation(forSeason: season)
                loadTeamListForCurrentSeason() {
                    // Loads the current game information
                    self.loadGameListFromCurrentSeason()
                }
            }
            SeriesFirebaseManager.loadSeries(forSeason: season) { (ser) in
                self.series = ser
            }
            
        }
    }
    
    func setCurrentTeam(teamToSet team : Team) {
        // Checks if the current season and team are valid
        if let seasonIndex = currentSeasonIndex, let teamIndex = seasons[seasonIndex].teams.firstIndex(of: team) {
            // Sets the team index
            currentTeamIndex = teamIndex
            // Loads the team member if necessary
            if seasons[seasonIndex].teams[teamIndex].members.count == 0 {
                loadCurrentTeam()
            }
        }
    }
    
    func loadCurrentTeam() {
        if let teamIndex = currentTeamIndex, let seasonIndex = currentSeasonIndex {
            if seasons[seasonIndex].teams[teamIndex].members == [] {
                MemberSaveManagement.loadMemberTeamInformation(withSeason: seasons[seasonIndex], withTeam: seasons[seasonIndex].teams[teamIndex]) { member in
                    if let index = self.seasons[seasonIndex].teams[teamIndex].members.firstIndex(of: member) {
                        self.seasons[seasonIndex].teams[teamIndex].members[index] = member
                    } else {
                        self.seasons[seasonIndex].teams[teamIndex].members.append(member)
                    }
                    self.seasons[seasonIndex].teams[teamIndex].members.sort { (member, member2) -> Bool in
                        member.lastName > member2.lastName
                    }
                }
            }
        }
    }
    
    func loadTeamListForCurrentSeason(completion : @escaping () -> Void) {
        if let seasonIndex = currentSeasonIndex {
            TeamSaveManagement.loadTeams(fromSeason: seasons[seasonIndex]) { (team) in
                if let index = self.seasons[seasonIndex].teams.firstIndex(of: team) {
                    self.seasons[seasonIndex].teams[index] = team
                } else {
                    self.seasons[seasonIndex].teams.append(team)
                    // Forces a UI update
                    self.objectWillChange.send()
                    completion()
                }
            }
        }
    }
    
    func loadGameListFromCurrentSeason() {
        if let seasonIndex = currentSeasonIndex {
            GameSaveManagement.loadGameList(withSeason: seasons[seasonIndex]) { (games) in
                self.seasons[seasonIndex].games = games
                self.objectWillChange.send()
            }
        }
    }
    
//    func loadTeamInformationForCurrentSeason() {
//        if let season = addingToSeason, let team = teamSelected {
//            MemberSaveManagement.loadMemberTeamInformation(withSeason: season, withTeam: team) { (member) in
//                if let index = self.teamSelected?.members.firstIndex(of: member) {
//                    self.teamSelected?.members[index] = member
//                } else {
//                    self.teamSelected?.members.append(member)
//                }
//            }
//        }
//    }
    
//
//    func loadSeasonInformation(forSeason season : Season) {
//        // Checks if the given season exists
//        if let seasonIndex = seasons.firstIndex(of: season) {
//            // Sets the current season to the season selected
//            currentSeason = season
//            // Checks if an update is required
////            if season.teams.count == 0 {
////                // Loads the team list for the specified team
////                TeamSaveManagement.loadTeams(fromSeason: season) { (team) in
////                    if let index = self.seasons[seasonIndex].teams.firstIndex(of: team) {
////                        self.seasons[seasonIndex].teams[index] = team
////                    } else {
////                        self.seasons[seasonIndex].teams.append(team)
////                    }
////                    self.loadTeamMemberInformation(forTeam: team)
////                }
////            } else {
////                for team in season.teams {
////                    loadTeamMemberInformation(forTeam: team)
////                }
////            }
//        }
//    }
  
}
