// Copyright 2021-Present Benjamin Hilger

import Foundation

class GameRoleViewModel : ObservableObject {
    
    @Published var availableRoles : [GameRole] = []
    
    var seasonID : String
    var gameID : String
    init(forSeason sID : String, forGame gID : String) {
        seasonID = sID
        gameID = gID
        loadAvailableRoles()
    }
    
    func loadAvailableRoles() {
        FirestoreManager.getAvailableRoles(forSeason: seasonID, forGame: gameID) { (roles) in
            self.availableRoles = roles
        }
    }
    
    func setSelectedRoles(forRoles roles: [GameRole]) {
        FirestoreManager.setiPadToRoles(forSeason: seasonID, forGame: gameID, forRoles: roles)
    }
}
