// Copyright 2021-Present Benjamin Hilger

import Foundation
import SwiftUI

class GameSetupViewModel : ObservableObject {
    
    @Published var gameSelected : Game?
    @Published var lineupViewModel : LineupViewModel =
        LineupViewModel(withLineup: Lineup(withAwayMembers: [],
                                           withHomeMembers: []))
    
    @Published var initialHome : [[String : Int]] = []
    @Published var initialAway : [[String : Int]] = []
    @Published var initialHomeDH : [String : String] = [:]
    @Published var initialAwayDH : [String : String] = [:]
    
    @Published var summarizedData : [SummaryStats] = []
    
    @Published var loadingMembers: Bool = false
    
    init() {}
    
    init(withGame game : Game) {
        gameSelected = game
        LineupSaveManagement.loadInitialLineupBuilder(forGame: game) {
            (builder) in
            self.initialHome = builder.homeLineupChange
            self.initialAway = builder.awayLineupChange
            self.initialHomeDH = builder.homeDHMap
            self.initialAwayDH = builder.awayDHMap
            self.generateLineup()
        }
    }
    
    func loadInitialLineupInfo() {
        if let game = gameSelected {
            LineupSaveManagement.loadInitialLineupBuilder(forGame: game) {
                (builder) in
                self.initialHome = builder.homeLineupChange
                self.initialAway = builder.awayLineupChange
                self.initialHomeDH = builder.homeDHMap
                self.initialAwayDH = builder.awayDHMap
                self.generateLineup()
            }
        }
    }
    
    func generateLineup() {
        if let gameSelected = gameSelected {
            var awayLineup : [MemberInGame] = []
            var awayTotal : [MemberInGame] = []
            var homeLineup : [MemberInGame] = []
            var homeTotal : [MemberInGame] = []
            
            var awayRoster = gameSelected.awayTeam.members
            for memberInfo in initialAway {
                if let memberID = memberInfo.keys.sorted().first {
                    let position = memberInfo[memberID] ?? 0
                    let tempMember = Member(withID: memberID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left)
                    if let index = awayRoster.firstIndex(of: tempMember) {
                        var memberInGame = MemberInGame(member: awayRoster[index], positionInGame: Positions(rawValue: position) ?? .Bench)
                        // Check if the member has a DH
                        if let dhID = self.initialAwayDH[memberID] {
                            let tempDH = Member(withID: dhID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left)
                            if let dhIndex = awayRoster.firstIndex(of: tempDH) {
                                memberInGame.dh = awayRoster[dhIndex]
                            }
                        }
                        awayRoster.remove(at: index)
                        awayLineup.append(memberInGame)
                        awayTotal.append(memberInGame)
                    }
                }
            }
            for member in awayRoster {
                awayTotal.append(MemberInGame(member: member, positionInGame: .Bench))
            }
            var homeRoster = gameSelected.homeTeam.members
            for memberInfo in initialHome {
                let memberID = memberInfo.keys.sorted()[0]
                let position = memberInfo[memberID] ?? 0
                let tempMember = Member(withID: memberID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left)
                if let index = homeRoster.firstIndex(of: tempMember) {
                    var memberInGame = MemberInGame(member: homeRoster[index], positionInGame: Positions(rawValue: position) ?? .Bench)
                    // Check if the member has a DH
                    if let dhID = self.initialHomeDH[memberID] {
                        let tempDH = Member(withID: dhID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left)
                        if let dhIndex = homeRoster.firstIndex(of: tempDH) {
                            memberInGame.dh = homeRoster[dhIndex]
                        }
                    }
                    homeLineup.append(memberInGame)
                    homeTotal.append(memberInGame)
                    homeRoster.remove(at: index)
                }
            }
            for member in homeRoster {
                homeTotal.append(MemberInGame(member: member, positionInGame: .Bench))
            }
            lineupViewModel.awayLineup = awayLineup
            lineupViewModel.awayRoster = awayTotal
            lineupViewModel.homeLineup = homeLineup
            lineupViewModel.homeRoster = homeTotal
            lineupViewModel.objectWillChange.send()
        }
    }
}
