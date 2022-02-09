// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineupEditView: View {
    
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    @State var editingAwayTeam : Bool
   
    @State var isViewingMissingPositions : Bool = false
    @State var isViewingPosition : Bool = false
    @State var requiredPosition : [Positions] = [.Pitcher,
                                                 .Catcher,
                                                 .FirstBase,
                                                 .SecondBase,
                                                 .ThirdBase,
                                                 .ShortStop,
                                                 .LeftField,
                                                 .CenterField,
                                                 .RightField]
    @State var lineup : [MemberInGame] = []
    @State var availableRoster : [MemberInGame] = []
    
    var body: some View {
        VStack {
            Text("Edit Lineup")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding().border(Color.black, width: 1)
            HStack {
                VStack {
                    Text("Current Lineup")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding().border(Color.black, width: 1)
                    List {
                        Section(header: Text("Hitting Lineup")) {
                            ForEach(0..<lineup.count, id: \.self) { index in
                                if lineup[index].positionInGame != .DH {
                                    LineupListCellView(player: lineup[index],
                                                       editingAwayTeam:
                                                        editingAwayTeam,
                                                       positionInLineup: lineupViewModel.getPositionInLineup(editingAwayLineup: editingAwayTeam, forPlayer: lineup[index]),
                                                       viewingType: .HittingLineup)
                                        .environmentObject(lineupViewModel)
                                }
                            }
                        }
                        Section(header: Text("Other Players")) {
                            ForEach(0..<lineup.count, id: \.self) { index in
                                if lineup[index].dh != nil {
                                    LineupListCellView(player: lineup[index],
                                                       editingAwayTeam:
                                                        editingAwayTeam,
                                                       viewingType:
                                                        .DHedPlayers)
                                }
                            }
                        }
                        
                    }.border(Color.black, width: 1)
                }
                VStack {
                    if isMissingPositions() {
                        Button {
                            self.isViewingMissingPositions = true
                        } label: {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color.yellow)
                                .padding().actionSheet(isPresented: $isViewingMissingPositions) { () -> ActionSheet in
                                    return ActionSheet(title: Text("Missing Positions"), message: Text(PositionUtil.getPositionsPrintable(forPostions: getMissingPositions())), buttons: [Alert.Button.default(Text("Ok"))])
                                }
                        }
                    }
                    Button {
                        if let member = lineupViewModel.availableMemberSelected {
                            if !lineupViewModel.playerInLineup(editingAwayLineup: editingAwayTeam, playerToCheck: member) {
                                self.isViewingPosition = true
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }.disabled(lineupViewModel.availableMemberSelected == nil || lineupViewModel.playerInLineup(editingAwayLineup: editingAwayTeam, playerToCheck: lineupViewModel.availableMemberSelected!)).padding().actionSheet(isPresented: $isViewingPosition) { () -> ActionSheet in
                        var positions = getMissingPositions()
                        positions.append(.EH)
                        return ActionSheet(title: Text("Add Player"), message: Text("Please select the position for the player"), buttons: generatePositionActionButtons(forPositions: positions, forPlayer: lineupViewModel.availableMemberSelected!))
                    }
                    Button {
                        if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!) {
                            lineupViewModel.removePlayerFromCurrentLineup(editingAwayLineup: editingAwayTeam, atIndex: index)
                            lineupViewModel.lineupMemberSelected = nil
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                    }.disabled(lineupViewModel.lineupMemberSelected == nil).padding()
                    Button {
                        if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!), let secondIndex = getPlayerPositionInRoster(forPlayer: lineupViewModel.availableMemberSelected!) {
                            lineupViewModel.replacePlayerInLineup(editingAwayLineup: editingAwayTeam, playerIndexCurrentlyInLineup: index, playerIndexCurrentlyInRoster: secondIndex)
                        }
                    } label: {
                        Text("Replace")
                    }.disabled(lineupViewModel.lineupMemberSelected == nil || lineupViewModel.availableMemberSelected == nil || lineupViewModel.playerInLineup(editingAwayLineup: editingAwayTeam, playerToCheck: lineupViewModel.availableMemberSelected!)).padding().border(lineupViewModel.lineupMemberSelected == nil || lineupViewModel.availableMemberSelected == nil || lineupViewModel.playerInLineup(editingAwayLineup: editingAwayTeam, playerToCheck: lineupViewModel.availableMemberSelected!) ? Color.gray : Color.blue, width: 1)
                    Button {
                        if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!) {
                            lineupViewModel.swapPlayersInLineup(editingAwayLineup: editingAwayTeam, firstIndexToSwap: index, secondIndexToSwap: index-1)
                        }
                    } label: {
                        Image(systemName: "arrow.up")
                    }.padding().border(Color.black).disabled(lineupViewModel.lineupMemberSelected == nil || (getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!) == nil || getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!)! == 0))
                    Button {
                        if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!) {
                            lineupViewModel.swapPlayersInLineup(editingAwayLineup: editingAwayTeam, firstIndexToSwap: index, secondIndexToSwap: index+1)
                        }
                    } label: {
                        Image(systemName: "arrow.down")
                    }.padding().border(Color.black).disabled(lineupViewModel.lineupMemberSelected == nil || (getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!) == nil || getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!)! == lineupViewModel.getCurrentLineupEditing(editingAwayLineup: editingAwayTeam).count-1))
                    Button {
                        if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!), let member = lineupViewModel.availableMemberSelected, let secondIndex = getPlayerPositionInRoster(forPlayer: member), lineupViewModel.lineupMemberSelected?.dh == nil {
                            lineupViewModel.assignPlayerAsDH(editingAwayLineup: editingAwayTeam, lineupPlayerIndex: index, rosterPlayerIndex: secondIndex)
                        } else if let player = lineupViewModel.lineupMemberSelected, lineupViewModel.lineupMemberSelected?.dh != nil {
                            lineupViewModel.removePlayerAsDH(editingAwayLineup: editingAwayTeam, withPlayer: player)
                        }
                        lineupViewModel.objectWillChange.send()
                    } label: {
                        Text(lineupViewModel.lineupMemberSelected?.dh != nil ? "Remove DH" : "Assign as DH")
                    }.disabled(!(lineupViewModel.lineupMemberSelected != nil && lineupViewModel.availableMemberSelected != nil || lineupViewModel.lineupMemberSelected != nil && lineupViewModel.lineupMemberSelected?.dh != nil)).padding().border(lineupViewModel.lineupMemberSelected == nil || lineupViewModel.availableMemberSelected == nil || lineupViewModel.playerInLineup(editingAwayLineup: editingAwayTeam, playerToCheck: lineupViewModel.availableMemberSelected!) ? Color.gray : Color.blue, width: 1)
                    Button {
                        if let index = getPlayerPositionInLineup(forPlayer: lineupViewModel.lineupMemberSelected!), let member = lineupViewModel.availableMemberSelected, let secondIndex = getPlayerPositionInRoster(forPlayer: member), lineupViewModel.lineupMemberSelected?.dh != nil {
                            lineupViewModel.replaceDH(editingAwayLineup: editingAwayTeam, lineupPlayerIndex: index, rosterPlayerIndex: secondIndex)
                        }
                    } label: {
                        Text("Switch DH")
                    }.disabled(!(lineupViewModel.lineupMemberSelected != nil && lineupViewModel.availableMemberSelected != nil || lineupViewModel.lineupMemberSelected != nil && lineupViewModel.lineupMemberSelected?.dh != nil)).padding().border(lineupViewModel.lineupMemberSelected == nil || lineupViewModel.availableMemberSelected == nil || lineupViewModel.playerInLineup(editingAwayLineup: editingAwayTeam, playerToCheck: lineupViewModel.availableMemberSelected!) ? Color.gray : Color.blue, width: 1)

                }.padding()
                VStack {
                    Text("Team Roster")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding().border(Color.black, width: 1)
                    List {
                        ForEach(availableRoster) { player in
                            LineupListCellView(player: player, editingAwayTeam: editingAwayTeam, viewingType: .AvailablePlayers)
                                .environmentObject(lineupViewModel)
                        }
                    }.border(Color.black, width: 1)
                }
            }
        }.border(Color.black, width: 2).onAppear {
            lineupViewModel.availableMemberSelected = nil
            lineupViewModel.lineupMemberSelected = nil
            // Gather the lineup information
            gatherLineupInformation()
        }.onReceive(lineupViewModel.$awayLineup) { _ in
            gatherLineupInformation()
        }.onReceive(lineupViewModel.$awayRoster) { _ in
            gatherLineupInformation()
        }.onReceive(lineupViewModel.$homeLineup) { _ in
            gatherLineupInformation()
        }.onReceive(lineupViewModel.$homeRoster) { _ in
            gatherLineupInformation()
        }.onAppear {
            gatherLineupInformation()
        }
    }
    
    func gatherLineupInformation() {
        // Get the current lineup editing
        lineup = lineupViewModel.getCurrentLineupEditing(
            editingAwayLineup: editingAwayTeam)
        // Get the available roster
        availableRoster = lineupViewModel.getAvailablePlayers(
            editingAwayLineup: editingAwayTeam,
            forState: .Default,
            forPosition: .Unknown)
    }
    
    func getPlayerPositionInLineup(forPlayer player : MemberInGame) -> Int? {
        return lineupViewModel.getCurrentLineupEditing(editingAwayLineup: editingAwayTeam).firstIndex(of: player)
    }
    
    func getPlayerPositionInRoster(forPlayer player : MemberInGame) -> Int? {
        return lineupViewModel.getCurrentRosterEditing(editingAwayLineup: editingAwayTeam).firstIndex(of: player)
    }
    
    func getMissingPositions() -> [Positions] {
        var positions = requiredPosition
        for players in lineupViewModel.getCurrentLineupEditing(editingAwayLineup: editingAwayTeam) {
            if let index = positions.firstIndex(of: players.positionInGame) {
                positions.remove(at: index)
            }
        }
        return positions
    }
    
    func isMissingPositions() -> Bool {
        return getMissingPositions().count > 0
    }
    
    func generatePositionActionButtons(forPositions pos : [Positions],
                                       forPlayer player : MemberInGame)
    -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        
        for p in pos {
            buttons.append(
                Alert.Button.default(Text("\(p.getPositionString())"), action: {
                var gameMember = player
                gameMember.positionInGame = p
                lineupViewModel.addPlayerToCurrentLineup(
                    editingAwayLineup: editingAwayTeam,
                    playerToAdd: gameMember)
            }))
        }
        
        return buttons
    }
}

struct LineupListCellView : View {
    
    // Store the lineup view model
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    // Store the player being viewed
    var player : MemberInGame
    
    // Store if the player is a member of the away team
    var editingAwayTeam : Bool
    
    // Store the position in the hitter lineup, if applicable
    var positionInLineup : Int?
    
    // Store if the user can select/edit the player being represented
    var isEditable : Bool = true

    // Store the viewing mode of the lineup cell
    var viewingType: LineupViewingType
    
    var body: some View {
        HStack {
            // Check if the viewing type is the hitting lineup
            // This will add their position in lineup if given
            if viewingType == .HittingLineup || viewingType == .All,
               let positionInLineup = positionInLineup {
                Text("#\(positionInLineup)")
                    .font(.system(size: 15))
                Spacer()
            }
            // Check which player to view
            // If hitting lineup, show players without a dh
            // And if the player has a dh, show the dh instead
            if viewingType == .HittingLineup && player.positionInGame != .DH {
                // Show the dh name if exists, normal player name
                // otherwise
                VStack {
                    Text(player.dh?.lastName ?? player.member.lastName)
                        .font(.system(size: 15))
                    Text("#\(Int(player.dh?.uniformNumber ?? player.member.uniformNumber))")
                        .font(.system(size: 10))
                }
                Spacer()
                // Add the position, either being the DH or the position
                // of the player
                Text(player.dh != nil ? Positions.DH.getPositionString() :
                        player.positionInGame.getPositionString())
            // Check if the viewing type is DHed players
            // Also check if the player has a dh
            } else if (viewingType == .DHedPlayers && player.dh != nil) ||
                viewingType == .All{
                // Show the player name
                Text(player.member.lastName)
                        .font(.system(size: 15))
                Text("#\(Int(player.dh?.uniformNumber ?? player.member.uniformNumber))")
                    .font(.system(size: 15))
                Spacer()
                // Show the position of the player
                Text(player.positionInGame.getPositionString())
            // Check if the viewing type is available players
            } else if viewingType == .AvailablePlayers {
                // Don't need to look for dh, so just put player name
                Text(player.member.lastName)
                        .font(.system(size: 15))
                Text("#\(Int(player.dh?.uniformNumber ?? player.member.uniformNumber))")
                    .font(.system(size: 15))
            }
            
        }.onTapGesture {
            // Check if it's editable
            if isEditable {
                // Check if the player is already selected
                if lineupViewModel.lineupMemberSelected == player {
                    // Remove the player
                    lineupViewModel.lineupMemberSelected = nil
                } else {
                    // Check if it it's viewing a part of the lineup
                    // or the available roster
                    if viewingType == .DHedPlayers || viewingType
                        == .HittingLineup {
                        // Set the lineup selected member
                        lineupViewModel.lineupMemberSelected = player
                    } else {
                        // Set the roster selected member
                        lineupViewModel.availableMemberSelected = player
                    }
                }
            }
        // Check if the player is selected
        }.if(((viewingType == .DHedPlayers || viewingType == .HittingLineup)
                ? lineupViewModel.lineupMemberSelected :
                lineupViewModel.availableMemberSelected) == player) {
            $0.padding().border(Color.black, width: 1)
        }
    }
}


enum LineupViewingType {
    case DHedPlayers
    case HittingLineup
    case AvailablePlayers
    case All
}

extension View {
  @ViewBuilder
  func `if`<Transform: View>(
    _ condition: Bool,
    transform: (Self) -> Transform
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}


