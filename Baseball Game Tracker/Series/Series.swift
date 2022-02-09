//
//  Series.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/8/21.
//

import Foundation

struct Series : Identifiable, Equatable {
    
    var id = UUID()
    /// Name of the series
    var name: String
    /// ID of the series
    var seriesID: String
    /// IDs of games in series
    var gameIDs: [String] = []
    /// season of the Series
    var season: Season
    
    static func == (lhs: Series, rhs: Series) -> Bool {
        return lhs.seriesID == rhs.seriesID
    }
}
