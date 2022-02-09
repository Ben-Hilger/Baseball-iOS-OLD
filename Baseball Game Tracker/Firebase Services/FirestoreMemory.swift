// Copyright 2021-Present Benjamin Hilger

import Foundation

class FirebaseMemory {
    
    static var seasons : [Season] = []
    
    private static var currentSeason : Season?
    
    static func loadSeasonList(completion : @escaping ([Season]) -> Void) {
        if seasons.count == 0 {
            FirestoreManager.loadSeasonList { (seasonList) in
                for season in seasonList {
                    if let index = self.seasons.firstIndex(of: season) {
                        self.seasons[index] = season
                    } else {
                        self.seasons.append(season)
                    }
                }
                completion(self.seasons)
            }
        } else {
            completion(self.seasons)
        }
        
    }
    
    static func getSeasonList() -> [Season] {
        return seasons
    }
    
    static func getCurrentSeason() -> Season? {
        return currentSeason
    }
    
    static func loadSeasonInitial(forSeason season : Season, completion : @escaping () -> Void) {
        // Resets all listeners looking for changes
        FirestoreManager.resetAllListeners()
        currentSeason = season
        // Checks for the possibility for already having loaded data
        if seasons.contains(season) && season.teams.count > 0 {
            // Calls the completion since it's been loaded and a listener has been aded
            completion()
        } else {
            // Loads the team list
            FirestoreManager.loadTeamList(forSeason: season.seasonID) { (teams) in
                // Checks if the current season is valid
                if self.currentSeason != nil {
                    // Explores the team list
                    for team in teams {
                        // Checks if the team already exists in the current season
                        if let index = self.currentSeason!.teams.firstIndex(of: team) {
                            // Updates the team
                            self.currentSeason!.teams[index] = team
                        } else {
                            // Adds the new team
                            self.currentSeason!.teams.append(team)
                        }
                    }
                    // Calls the completion
                    completion()
                }
                
            }
        }
        
    }

    static func loadSeasonTeamMembers(forTeam team : Team) {
        if let currentSeason = currentSeason {
            for index in 0..<currentSeason.teams.count {
                var currentTeam = currentSeason.teams[index]
                if currentTeam.teamID == team.teamID {
                    // Checks if the players are already loaded
                    if currentTeam.members.count == 0 {
                        FirestoreManager.loadMembers(forSeason: currentSeason.seasonID, forTeam: currentTeam.teamID) { (members) in
                            // Explores the list of members
                            for member in members {
                                // Checks if there is already a member with the same ID
                                if let index = currentTeam.members.firstIndex(of: member) {
                                    // Updates the existing member
                                    currentTeam.members[index] = member
                                } else {
                                    // Adds the new member
                                    currentTeam.members.append(member)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
