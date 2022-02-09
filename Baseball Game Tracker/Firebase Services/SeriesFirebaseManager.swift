//
//  SeriesFirebaseManager.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/11/21.
//

import Foundation
import Firebase

class SeriesFirebaseManager {
    
    static func loadSeries(forSeason season: Season, completion: @escaping ([Series]) -> Void) {
        Firestore.firestore().collection("Season").document(season.seasonID).collection("Series").getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            } else if let query = snapshot {
                var seriesList: [Series] = []
                for document in query.documents {
                    let data = document.data()
                    if let name = data["name"] as? String,
                       let seriesID = data["seriesID"] as? String {
                        var series = Series(name: name, seriesID: seriesID, season: season)
                        if let games = data["games"] as? [String] {
                            series.gameIDs = games
                        }
                        series.season = season
                        seriesList.append(series)
                    }
                }
                completion(seriesList)
            }
        }
    }
    
    static func saveSeries(seriesToSave series: Series) -> String {
        
        var db: DocumentReference!
        var id: String!
        if series.seriesID == "" {
            db = Firestore.firestore().collection("Season").document(series.season.seasonID).collection("Series").document()
            id = db.documentID
        } else {
            db = Firestore.firestore().collection("Season").document(series.season.seasonID).collection("Series").document(series.seriesID)
            id = series.seriesID
        }
        let dataToSave: [String: Any] = [
            "name" : series.name,
            "seriesID" : series.seriesID,
            "games" : series.gameIDs
        ]
        db.setData(dataToSave)
        return id
    }
    
}
