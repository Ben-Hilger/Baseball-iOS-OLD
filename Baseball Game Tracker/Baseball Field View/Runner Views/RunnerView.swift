// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct RunnerView: View {

    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var player : MemberInGame
    
    var widthAdjustment : CGFloat
    var heightAdjustment: CGFloat

    var body: some View {
        GeometryReader { (geometry) in
            Text(getDisplay())
                .font(.system(size: CGFloat(settingsViewModel.runnerFontSize)))
                .foregroundColor(Color.black)
                .position(x: geometry.size.width * widthAdjustment, y: geometry.size.height * heightAdjustment)
        }
    }
    
    func getDisplay() -> String {
        switch settingsViewModel.runnerDisplaySettings {
        case .LastName:
            return player.member.lastName
        case .FirstName:
            return player.member.firstName
        case .Number:
            return "\(Int(player.member.uniformNumber))"
        case .FirstInitialLastName:
            if let firstInitial = player.member.firstName.first {
                return "\(firstInitial) \(player.member.lastName)"
            } else {
                return "\(player.member.lastName)"
            }
        case .FirstNameLastInitial:
            if let lastInitial = player.member.lastName.first {
                return "\(player.member.firstName) \(lastInitial)"
            } else {
                return "\(player.member.firstName)"
            }
        case .Initials:
            var initials : String = ""
            if let firstInitial = player.member.firstName.first {
                initials += "\(firstInitial)"
            }
            if let lastInitial = player.member.lastName.first {
                initials += "\(lastInitial)"
            }
            return initials
        }
    }
}
