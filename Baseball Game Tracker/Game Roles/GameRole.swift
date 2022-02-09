// Copyright 2021-Present Benjamin Hilger

import Foundation

enum GameRole : Int, CaseIterable {
    case Master = 0
    case PitchOutcome = 1
    case PitchLocation = 2
    
    func getGameRoleString() -> String {
        switch self {
        case .Master:
            return "Master"
        case .PitchOutcome:
            return "Pitch Result"
        case .PitchLocation:
            return "Pitch Information"
        }
    }
}
