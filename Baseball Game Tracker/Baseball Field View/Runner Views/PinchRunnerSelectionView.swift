// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PinchRunnerSelectionView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    var base : Base
    var editingAwayTeam : Bool
    var runnerSelectionType : RunnerSelectionType
    
    var body: some View {
        if let game = gameViewModel.game {
            VStack {
                Text("Edit Lineup")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding().border(Color.black, width: 1)
                HStack {
                    VStack {
                        if let playerOnBase = getPlayerOnBase() {
                            Text("Current Runner")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding().border(Color.black, width: 1)
                            LineupListCellView(player: playerOnBase,
                                               editingAwayTeam:
                                                editingAwayTeam,
                                               isEditable : false,
                                               viewingType: .All)
                                .environmentObject(lineupViewModel)
                                .border(Color.black, width: 1)
                        }
                    }
                    VStack {
                        Button {
                            if let secondIndex = getPlayerPositionInRoster(forPlayer: lineupViewModel.availableMemberSelected!), let runner = getPlayerOnBase(), let index = lineupViewModel.getCurrentLineupEditing(editingAwayLineup: editingAwayTeam).firstIndex(of: runner) {
                                gameViewModel.placePinchRunner(onBase: base, withPinchRunner: lineupViewModel.getCurrentRosterEditing(editingAwayLineup: editingAwayTeam)[secondIndex])
                                if runnerSelectionType == .Occupied {
                                    lineupViewModel.replacePlayerInLineup(editingAwayLineup: editingAwayTeam, playerIndexCurrentlyInLineup: index, playerIndexCurrentlyInRoster: secondIndex)
                                    gameViewModel.submitLineupChange(forLineupViewModel: lineupViewModel)
                                }
                            } else if runnerSelectionType == .Empty, let secondIndex = getPlayerPositionInRoster(forPlayer: lineupViewModel.availableMemberSelected!) {
                                gameViewModel.placePinchRunner(onBase: base, withPinchRunner: lineupViewModel.getCurrentRosterEditing(editingAwayLineup: editingAwayTeam)[secondIndex])
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text(runnerSelectionType == .Occupied ? "Replace" : "Place Runner")
                        }.disabled(runnerSelectionType == .Occupied ? !canReplace() : lineupViewModel.availableMemberSelected == nil).padding().border(runnerSelectionType == .Occupied ? !canReplace() ? Color.gray : Color.blue : lineupViewModel.availableMemberSelected == nil ? Color.gray : Color.blue, width: 1)
                    }.padding()
                    VStack {
                        Text("Team Roster")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding().border(Color.black, width: 1)
                        List {
                            ForEach(lineupViewModel.getAvailablePlayers(editingAwayLineup: editingAwayTeam, forState: .Runner, forPosition: runnerSelectionType == .Occupied && getPlayerOnBase() != nil ? getPlayerOnBase()!.positionInGame : .Unknown)) { player in
                                LineupListCellView(player: player,
                                                   editingAwayTeam:
                                                    editingAwayTeam,
                                                   viewingType:
                                                    .AvailablePlayers)
                                    .environmentObject(lineupViewModel)
                            }
                        }.border(Color.black, width: 1)
                    }
                }
            }.border(Color.black, width: 2).onAppear {
                lineupViewModel.availableMemberSelected = nil
                lineupViewModel.lineupMemberSelected = getPlayerOnBase()
            }
        }
    }
    
    func getPlayerOnBase() -> MemberInGame? {
        switch base {
        case .First:
            return gameViewModel.getPlayerOnBase(base: .First)?.pinchRunner ?? gameViewModel.getPlayerOnBase(base: .First)?.playerOnBase
        case .Second:
            return gameViewModel.getPlayerOnBase(base: .Second)?.pinchRunner ?? gameViewModel.getPlayerOnBase(base: .Second)?.playerOnBase
        case .Third:
            return gameViewModel.getPlayerOnBase(base: .Third)?.pinchRunner ?? gameViewModel.getPlayerOnBase(base: .Third)?.playerOnBase
        default:
            return nil
        }
    }
    
    func canReplace() -> Bool {
        return (lineupViewModel.lineupMemberSelected != nil && lineupViewModel.availableMemberSelected != nil && lineupViewModel.lineupMemberSelected?.member != lineupViewModel.availableMemberSelected?.member)
    }
    
    func getPlayerPositionInRoster(forPlayer player : MemberInGame) -> Int? {
        return lineupViewModel.getCurrentRosterEditing(editingAwayLineup: editingAwayTeam).firstIndex(of: player)
    }
}

enum RunnerSelectionType {
    case Occupied
    case Empty
}
