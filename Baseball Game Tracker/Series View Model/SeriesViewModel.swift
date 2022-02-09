//
//  SeriesViewModel.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/8/21.
//

import Foundation
import SwiftUI

class SeriesViewModel : ObservableObject {
    
    @Published var loadedGames: [Game] = []
    
    @Published var loadedMembers: [Member] = []
    
    func loadSeriesInformation(withSeason season: Season, forSeries series: Series) {
        // Reset the game list
        loadedGames = []
        // Iterate through all of the gameIDs in the series
        for gameID in series.gameIDs {
            print("Loading game: \(gameID) for season: \(season.seasonID) with teams: \(season.teams.count)")
            GameSaveManagement.loadGameInformation(withSeason: season, withGameId: gameID) { (game) in
                // Check if a valid game was loaded
                if let game = game {
                    print("Game loaded: \(game.gameID)")
                    // Check if the game is aleady in the list
                    if let index = self.loadedGames.firstIndex(of: game) {
                        // Reset the game
                        self.loadedGames[index] = game
                    } else {
                        // Add the the game to the end of the list
                        self.loadedGames.append(game)
                      //  self.loadMembers(fromGame: game)
                    }
                }
            }
        }
    }
    
    func loadMembers(fromGame game: Game) {
        MemberSaveManagement.loadMemberInformation(withSeasonID: game.seasonID,
                                                    withTeamID: game.awayTeam.teamID) { (member) in
            if let index = self.loadedMembers.firstIndex(of: member) {
                self.loadedMembers[index] = member
            } else {
                self.loadedMembers.append(member)
            }
        }
        MemberSaveManagement.loadMemberInformation(withSeasonID: game.seasonID,
                                                    withTeamID: game.homeTeam.teamID) { (member) in
            print("LOADING MEMBERS")
            if let index = self.loadedMembers.firstIndex(of: member) {
                self.loadedMembers[index] = member
            } else {
                self.loadedMembers.append(member)
            }
        }
    }
}
