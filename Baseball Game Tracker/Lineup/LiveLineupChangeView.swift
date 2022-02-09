// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LiveLineupChangeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    @State var editingAwayTeam : Bool
    @State var state : LiveLineupChangeViewType
    @State var position : Positions?
    @State var historyType : LiveLineupChangeHistoryType = .Current
    
    var body: some View {
        if let game = gameViewModel.game {
            VStack {
                Text("Edit Lineup")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding().border(Color.black, width: 1)
                HStack {
                    VStack {
                        Text("Current \(state.getString())")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding().border(Color.black, width: 1)
                        LineupListCellView(
                            player: (state == .Fielder ? lineupViewModel.getCurrentPlayer(atPosition: position!, editingAwayLineup: editingAwayTeam)! : lineupViewModel.currentHitter!), editingAwayTeam: editingAwayTeam, isEditable : false, viewingType: .All)
                            .environmentObject(lineupViewModel)
                            .border(Color.black, width: 1)
                    }
                    VStack {
                        Button {
                            if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!), let secondIndex = getPlayerPositionInRoster(forPlayer: lineupViewModel.availableMemberSelected!) {
                                if state == .Fielder, let position = position {
                                    lineupViewModel.switchPosition(
                                        editingAwayLineup: editingAwayTeam,
                                        pitcherIndex: index,
                                        switchPitcherTo:
                                            lineupViewModel.availableMemberSelected!,
                                        forPosition: position)
                                } else if state == .Hitter {
                                    lineupViewModel.switchCurrentHitter(
                                        editingAwayLineup: editingAwayTeam,
                                        playerToSwitchWithIndex: secondIndex)
                                    
                                }
                            }
                        } label: {
                            Text("Replace")
                        }.disabled(!canReplace()).padding().border(Color.blue, width: 1)
                    }.padding()
                    VStack {
                        Text("Team Roster")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding().border(Color.black, width: 1)
                        List {
                            ForEach(lineupViewModel.getAvailablePlayers(editingAwayLineup: editingAwayTeam, forState: state, forPosition: position)) { player in
                                LineupListCellView(player: player,
                                                   editingAwayTeam:
                                                    editingAwayTeam,
                                                   viewingType:
                                                    .AvailablePlayers)
                                    .environmentObject(lineupViewModel)
                            }
                        }.border(Color.black, width: 1)
                    }
//                    .onDisappear {
//                        if historyType == .Current {
//                            gameViewModel.submitLineupChange(forLineupViewModel: lineupViewModel)
//                        } else if historyType == .Snapshot {
//                            if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, let pitcherID = lineupViewModel.getCurrentPitcher(editingAwayLineup: editingAwayTeam)?.member.memberID, let hitterID = lineupViewModel.currentHitter?.member.memberID {
//                                gameViewModel.gameSnapshots[index].eventViewModel.pitcherID = pitcherID
//                                gameViewModel.gameSnapshots[index].eventViewModel.hitterID = hitterID
//                            }
//                        }
//                    }
                }
            }.border(Color.black, width: 2).onAppear {
                lineupViewModel.availableMemberSelected = nil
                lineupViewModel.lineupMemberSelected = state == .Fielder ? lineupViewModel.getCurrentPlayer(atPosition: position!, editingAwayLineup: editingAwayTeam) : lineupViewModel.currentHitter
            }.onDisappear {
                if historyType == .Current {
                    gameViewModel.submitLineupChange(forLineupViewModel: lineupViewModel)
                } else if historyType == .Snapshot {
                    if let index = gameSnapshotViewModel.gameSnapshotIndexSelected, let pitcherID = lineupViewModel.getCurrentPitcher(editingAwayLineup: editingAwayTeam)?.member.memberID, let hitterID = lineupViewModel.currentHitter?.member.memberID {
                        gameViewModel.gameSnapshots[index].eventViewModel.pitcherID = pitcherID
                        gameViewModel.gameSnapshots[index].eventViewModel.hitterID = hitterID
                    }
                }
            }.onAppear {
                self.lineupViewModel.lineupMemberSelected = state == .Hitter ? gameViewModel.getCurrentHitter() : gameViewModel.lineup.getPlayer(forTeam: editingAwayTeam ? .Away : .Home, atPosition: position!)
            }
        }
    }
    
    func getPlayerPositionInLineup(forPlayer player : MemberInGame) -> Int? {
        return lineupViewModel.getCurrentLineupEditing(editingAwayLineup: editingAwayTeam).firstIndex(of: player)
    }
    
    func getPlayerPositionInRoster(forPlayer player : MemberInGame) -> Int? {
        return lineupViewModel.getCurrentRosterEditing(editingAwayLineup: editingAwayTeam).firstIndex(of: player)
    }
    
    func canReplace() -> Bool {
        return (lineupViewModel.lineupMemberSelected != nil && lineupViewModel.availableMemberSelected != nil && lineupViewModel.lineupMemberSelected?.member != lineupViewModel.availableMemberSelected?.member)
    }
}

enum LiveLineupChangeViewType {
    case Hitter
    case Default
    case Fielder
    case Runner
    
    func getString() -> String {
        switch self {
        case .Hitter:
            return "Hitter"
        case .Default:
            return "Default"
        case .Fielder:
            return "Fielder"
        case .Runner:
            return "Runner"
        }
    }
}

enum LiveLineupChangeHistoryType {
    case Current
    case Snapshot
}
