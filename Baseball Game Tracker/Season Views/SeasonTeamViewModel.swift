// Copyright 2021-Present Benjamin Hilger

import Foundation
import Combine

class SeasonTeamViewModel : ObservableObject {
    
    @Published var season : Season
    
    init(withSeason season : Season) {
        self.season = season
        loadTeams(forSeason: season)
    }
    
    func loadTeams(forSeason season : Season) {
        FirestoreManager.loadTeamList(forSeason: season.seasonID) { (teams) in
            for team in teams {
                if let index = season.teams.firstIndex(of: team) {
                    self.season.teams[index] = team
                } else {
                    self.season.teams.append(team)
                }
            }
        }
    }
}
