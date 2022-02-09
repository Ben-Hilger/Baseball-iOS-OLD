// Copyright 2021-Present Benjamin Hilger

import Foundation

enum RunnerDislaySetting : CaseIterable {
    case Initials
    case Number
    case LastName
    case FirstName
    case FirstInitialLastName
    case FirstNameLastInitial
    
    func getString() -> String {
        switch self {
        case .Initials:
            return "Initials"
        case .Number:
            return "Uniform Number"
        case .LastName:
            return "Last Name"
        case .FirstName:
            return "First Name"
        case .FirstInitialLastName:
            return "First Initial + Last Name"
        case .FirstNameLastInitial:
            return "First Name + Last Initial"
        }
    }
}
