// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class SeasonSaveManagement {
    
    private static var firestore = Firestore.firestore()
    
    static func createNewSeason(withSeasonName seasonName : String, withSeasonYear year : Int) -> Season {
        let seasonDocument = firestore.collection(FirestoreKeys.Season_Collection_Name).document()
        seasonDocument.setData([
            "seasonID" : seasonDocument.documentID,
            "season" : seasonName,
            "year" : year
        ])
        return Season(withSeasonID: seasonDocument.documentID, withSeasonYear: year, withSeasonName: seasonName)
    }
    
    static func loadAvailableSeasons(completion : @escaping ([Season]) -> Void) {
        firestore.collection(FirestoreKeys.Season_Collection_Name).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    var seasons : [Season] = []
                    for document in snapshot.documents {
                        let data = document.data()
                        let seasonID = document.documentID
                        if let seasonName = data["season"] as? String, let year = data["year"] as? Int {
                            let season = Season(withSeasonID: seasonID, withSeasonYear: year, withSeasonName: seasonName)
                            seasons.append(season)
                        }
                    }
                    completion(seasons)
                } else {
                    completion([])
                }
            }
        }
    }
    
}
