// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotFielderView: View {

    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel

    @State var isViewingOptions : Bool = false
    @State var isViewingPlayerChange : Bool = false

    @State var actionSheetType : FielderViewActionSheetType = .FielderOptions

    var position : Positions

    var widthAdjustment : CGFloat
    var heightAdjustment : CGFloat

    var body: some View {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, let hitter = gameViewModel.gameSnapshots[index].currentHitter {
            GeometryReader { (geometry) in
                Text(getDisplay(forPlayer: gameViewModel.lineup.getPlayer(forTeam: gameViewModel.gameSnapshots[index].currentInning?.isTop ?? false ? .Home : .Away, atPosition: position)))
                    .position(x: geometry.size.width * widthAdjustment, y: geometry.size.height * heightAdjustment)
                    .font(.system(size: CGFloat(settingsViewModel.fielderFontSize)))
                    .foregroundColor(isPlayerSelected() ? .yellow : .white)
                    .onTapGesture {
                        isViewingOptions = true
                    }
                    .sheet(isPresented: $isViewingPlayerChange, content: {
                        LiveLineupChangeView(editingAwayTeam: !(gameViewModel.gameSnapshots[index].currentInning?.isTop ?? false), state: .Fielder, position: position, historyType: .Snapshot)
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                            .environmentObject(LineupViewModel(withLineup: gameViewModel.gameSnapshots[index].lineup, withCurrentHitter: hitter))
                    }).actionSheet(isPresented: $isViewingOptions) { () -> ActionSheet in
                        return ActionSheet(title: Text("Player Sequence Options for \(position.getPositionString())"), message: nil, buttons: [
                                            Alert.Button.default(Text("Add to Sequence")) {
                                                if let player = getPlayer() {
                                                    self.gameViewModel.gameSnapshots[index].eventViewModel.playersInvolved.append(player)
                                                    self.gameSnapshotViewModel.objectWillChange.send()
                                                }
                                            },
                                            Alert.Button.default(Text("Remove from Sequence")) {
                                                if let player = getPlayer() {
                                                    if let index = self.gameViewModel.gameSnapshots[index].eventViewModel.playersInvolved.lastIndex(of: player) {
                                                        for i in (index..<(self.gameViewModel.gameSnapshots[index].eventViewModel.playersInvolved.count)).reversed() {
                                                            self.gameViewModel.gameSnapshots[index].eventViewModel.playersInvolved.remove(at: i)
                                                            self.gameSnapshotViewModel.objectWillChange.send()
                                                        }
                                                    }
                                                }
                                            },
                                            Alert.Button.default(Text("Change Player"), action: {
                                                self.isViewingPlayerChange = true
                                            })
                            ])

                    }
            }
        }
    }

    func getPlayer() -> MemberInGame? {
        if let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
            return gameViewModel.gameSnapshots[index].lineup.getPlayer(forTeam: gameViewModel.gameSnapshots[index].currentInning?.isTop ?? false ? .Home : .Away, atPosition: position)
          //  return currentInning.isTop ? game.lineup.getHomePlayer(atPosition: position) : game.lineup.getAwayPlayer(atPosition: position)
        }
        return nil
    }

    func isPlayerSelected() -> Bool {
        if let player = getPlayer(), let index = gameSnapshotViewModel.gameSnapshotIndexSelected {
            if gameSnapshotViewModel.snapshotFieldEditMode == .PlayerSequence {
                if gameViewModel.gameSnapshots[index].eventViewModel.playersInvolved.contains(player) {
                    return true
                }
            }
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
