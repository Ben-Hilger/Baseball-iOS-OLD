// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FielderView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    @State var isViewingPositionChange : Bool = false
    @State var isViewingOptions : Bool = false
    
    @State var actionSheetType : FielderViewActionSheetType = .FielderOptions
    
    var position : Positions
    
    var widthAdjustment : CGFloat
    var heightAdjustment : CGFloat
        
    
    
    var body: some View {
        if let currentInning = gameViewModel.currentInning {
            GeometryReader { (geometry) in
                Text(getDisplay(forPlayer: gameViewModel.lineup.getPlayer(forTeam: currentInning.isTop ? .Home : .Away, atPosition: position)))
                    .position(x: geometry.size.width * widthAdjustment, y: geometry.size.height * heightAdjustment)
                    .font(.system(size: CGFloat(settingsViewModel.fielderFontSize)))
                    .foregroundColor(isPlayerSelected() ? .yellow : .white).onTapGesture {
                        if gameViewModel.fieldEditingMode == .Normal {
                            self.isViewingOptions = true
                        } else {
                            if let player = getPlayer() {
                                if eventViewModel.playersInvolved.contains(player) {
                                    actionSheetType = .PlayerSequence
                                    isViewingOptions = true
                                } else {
                                    eventViewModel.playersInvolved.append(player)
                                }
                            }
                        }
                    }.actionSheet(isPresented: $isViewingOptions) { () -> ActionSheet in
                        switch actionSheetType {
                        case .FielderOptions:
                            return ActionSheet(title: Text("Fielder Options for \(position.getPositionString())"), message: nil, buttons: [Alert.Button.default(Text("Change Player"), action: {
                                self.isViewingPositionChange = true
                            })])
                        case .PlayerSequence:
                            return ActionSheet(title: Text("Player Sequence Options for \(position.getPositionString())"), message: nil, buttons: [
                                                Alert.Button.default(Text("Add to Sequence Again")) {
                                                    if let player = getPlayer() {
                                                        eventViewModel.playersInvolved.append(player)
                                                    }
                                                },
                                                Alert.Button.default(Text("Remove from Sequence")) {
                                                    if let player = getPlayer() {
                                                        if let index = eventViewModel.playersInvolved.lastIndex(of: player) {
                                                            for i in (index..<(eventViewModel.playersInvolved.count)).reversed() {
                                                                eventViewModel.playersInvolved.remove(at: i)
                                                            }
                                                        }
                                                    }
                                                }
                            ])
                        }
                    }.sheet(isPresented: $isViewingPositionChange) {
                        LiveLineupChangeView(editingAwayTeam: !(gameViewModel.currentInning?.isTop ?? false), state: .Fielder, position: position)
                            .environmentObject(gameViewModel)
                            .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup))
                    }
            }
        }
    }
    
    func getPlayer() -> MemberInGame? {
        if let currentInning = gameViewModel.currentInning, let game = gameViewModel.game {
            return gameViewModel.lineup.getPlayer(forTeam: currentInning.isTop ? .Home : .Away, atPosition: position)
          //  return currentInning.isTop ? game.lineup.getHomePlayer(atPosition: position) : game.lineup.getAwayPlayer(atPosition: position)
        }
        return nil
    }
    
    func isPlayerSelected() -> Bool {
        if let player = getPlayer() {
            return gameViewModel.fieldEditingMode == .PlayerSequence ? eventViewModel.playersInvolved.contains(player) : false
        }
        return false
    }
    
    func getDisplay(forPlayer player : MemberInGame?) -> String {
        if let player = player {
            switch settingsViewModel.fielderDisplaySettings {
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
        } else {
            return position.getPositionString()
        }
        
    }
}

enum FielderViewActionSheetType {
    case FielderOptions
    case PlayerSequence
}
