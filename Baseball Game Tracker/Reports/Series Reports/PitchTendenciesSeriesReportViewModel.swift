//
//  PitchTendenciesSeriesReportViewModel.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/12/21.
//

import Foundation
import SwiftUI

class PitchTendenciesSeriesReportViewModel : ObservableObject {
    
    @Published var needUpdate: GameViewModel = GameViewModel()
    @Published var pitchCounts: [PitchLocation : [PitchType : Int]] = [:]
    @Published var pitchCountsLeft: [PitchLocation : [PitchType : Int]] = [:]
    @Published var pitchCountsRight: [PitchLocation : [PitchType : Int]] = [:]

    @Published var loadedSnapshots: [GameSnapshot] = []
    
    @Published var pitchersHome: [Member] = []
    @Published var hittersHome: [Member] = []
    @Published var pitchersAway: [Member] = []
    @Published var hittersAway: [Member] = []
      
    func loadGames(gamesToLoad games: [Game], teamToView: GameTeamType) {
        loadedSnapshots = []
        for game in games {
            // Load each game
            rebuildGame(game: game)
        }
    }
    
    func rebuildGame(game: Game) {
        let model = GameViewModel()
        model.game = game
        GameBuilderManagement.rebuildGame(forGame: game) { (snapshot, builder, pitchInfo) in
            if let snapshot = snapshot, let builder = builder, let currentAtBat = snapshot.currentAtBat, let inning = snapshot.currentInning {
                // Creates the event view model from the given builder
                let eventViewModel = model.buildEventViewModelFromBuilder(withBuilder: builder, withPitchBuilder: pitchInfo, withHittingTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home, snapshotAtBat: currentAtBat, currentInning: inning)
                snapshot.eventViewModel = eventViewModel
                self.loadedSnapshots.append(snapshot)
            }
        }
    }
    
    func loadPlayer(withMembers loadedMembers : [Member]) {
        pitchersHome = []
        hittersHome = []
        pitchersAway = []
        hittersAway = []
        for snapshot in loadedSnapshots {
            var pitcher = Member(withID: snapshot.eventViewModel.pitcherID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: HandUsed.Left, withHittingHands: HandUsed.Left)
            if let index = loadedMembers.firstIndex(of: pitcher) {
                pitcher = loadedMembers[index]
            }
            if loadedMembers.firstIndex(of: pitcher) != nil {
                if snapshot.currentInning?.isTop ?? false, !pitchersHome.contains(pitcher) {
                    pitchersHome.append(pitcher)
                } else if !pitchersAway.contains(pitcher) {
                    pitchersAway.append(pitcher)
                }
            }
            var hitter = Member(withID: snapshot.eventViewModel.hitterID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: HandUsed.Left, withHittingHands: HandUsed.Left)
            if let index = loadedMembers.firstIndex(of: hitter) {
                hitter = loadedMembers[index]
            }
            if loadedMembers.firstIndex(of: hitter) != nil {
                if !hittersHome.contains(hitter) {
                    hittersHome.append(hitter)
                }
            }
        }
    }
        
    func getTotal(ofPitchThrown thrown: PitchType? = nil, forPitcher pitcher: Member? = nil,
                  forHitter hitter: Member? = nil, playerOnFirst first: Bool = false,
                  playerOnSecond second: Bool = false, playerOnThird third: Bool = false,
                  numBalls ballCount: Int? = nil, numStrikes strikeCount: Int? = nil,
                  withPtchingHand hand: HandUsed? = nil, withHittingHand Hhand: HandUsed? = nil) -> Int {
        var prevStrikeCount = 0
        var prevBallCount = 0
        var playerOnFirst: BaseState? = nil
        var playerOnSecond: BaseState? = nil
        var playerOnThird: BaseState? = nil
        var total = 0
        for snapshot in loadedSnapshots {
            if let pitch  =
                snapshot.eventViewModel.pitchEventInfo?.completedPitch {
                if pitcher == nil ||
                    pitcher?.memberID == snapshot.eventViewModel.pitcherID {
                    if hitter == nil ||
                        hitter?.memberID == snapshot.eventViewModel.hitterID {
                        if (playerOnFirst != nil) == first {
                            if (playerOnSecond != nil) == second {
                                if (playerOnThird != nil) == third {
                                    if ballCount == nil ||
                                        ballCount == prevBallCount {
                                        if strikeCount == nil ||
                                            strikeCount == prevStrikeCount {
                                            if hand == nil ||
                                                pitch.pitcherThrowingHand == hand {
                                                if Hhand == nil ||
                                                    pitch.hitterHittingHand == Hhand {
                                                    if thrown == nil ||
                                                    pitch.pitchType != nil &&
                                                       thrown == pitch.pitchType {
                                                        total += 1
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            prevStrikeCount = snapshot.eventViewModel.numStrikes
            prevBallCount = snapshot.eventViewModel.numBalls
            playerOnFirst = snapshot.eventViewModel.playerAtFirstAfter
            playerOnSecond = snapshot.eventViewModel.playerAtSecondAfter
            playerOnThird = snapshot.eventViewModel.playerAtThirdAfter
        }
        return total
    }
    
    func populateReport(forPlayers players: [Member], playerType: PersonEditing) -> [PitchLocation: [PitchType: Int]] {
        pitchCounts = [:]
        pitchCountsRight = [:]
        pitchCountsLeft = [:]
        var totals: [PitchLocation : [PitchType : Int]] = [:]
        var totalPitches : Int = 0
        // Iterate through each snapshot
        for snapshot in loadedSnapshots {
            // Check if the snapshot is adding a pitch
            if let pitch = snapshot.eventViewModel.pitchEventInfo {
                totalPitches += 1
                // Get the current count for the given location
                var currentLocation: [PitchType : Int] = pitch.pitchLocations != nil ? totals[pitch.pitchLocations!] ?? [:] : [:]
                var currentPitchType = pitch.selectedPitchThrown != nil ? currentLocation[pitch.selectedPitchThrown!] ?? 0 : 0
                let player = Member(withID: playerType == .Pitcher ? snapshot.eventViewModel.pitcherID :
                                        snapshot.eventViewModel.hitterID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left)
                // Increment the current pitch type
                if players.contains(player) {
                    currentPitchType += 1
                }
                // Update with the new value
                if let type = pitch.selectedPitchThrown {
                    currentLocation.updateValue(currentPitchType, forKey: type)
                }
                // Update the location with the new value
                if let location = pitch.pitchLocations {
                    totals.updateValue(currentLocation, forKey: location)
                }
            }
        }
        // Set the totals
        pitchCounts = totals
        return totals
    }
    
    func getProperPitchCount(hand: HandUsed?) -> [PitchLocation : [PitchType: Int]] {
        if let hand = hand {
            if hand == .Left {
                return pitchCountsLeft
            } else if hand == .Right {
                return pitchCountsRight
            }
        }
        return pitchCounts
    }
    
    func populateHitterReport(forPlayers players: [Member], playerType: PersonEditing) {
        pitchCounts = [:]
        pitchCountsRight = [:]
        pitchCountsLeft = [:]
        for i in 0...1 {
            let hand = HandUsed(rawValue: i) ?? .Right
            var totals: [PitchLocation : [PitchType : Int]] = [:]
            var totalPitches : Int = 0
            // Iterate through each snapshot
            for snapshot in loadedSnapshots {
                // Check if the snapshot is adding a pitch
                if let pitch = snapshot.eventViewModel.pitchEventInfo {
                    totalPitches += 1
                    // Get the current count for the given location
                    var currentLocation: [PitchType : Int] = pitch.pitchLocations != nil ? totals[pitch.pitchLocations!] ?? [:] : [:]
                    var currentPitchType = pitch.selectedPitchThrown != nil ? currentLocation[pitch.selectedPitchThrown!] ?? 0 : 0
                    let player = Member(withID:
                                            snapshot.eventViewModel.hitterID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left)
                    if players.contains(player), hand == pitch.completedPitch?.pitcherThrowingHand {
                        currentPitchType += 1
                    }
                    // Update with the new value
                    if let type = pitch.selectedPitchThrown {
                        currentLocation.updateValue(currentPitchType, forKey: type)
                    }
                    // Update the location with the new value
                    if let location = pitch.pitchLocations {
                        totals.updateValue(currentLocation, forKey: location)
                    }
                }
            }
            if hand == .Left {
                // Set the totals
                pitchCountsLeft = totals
            } else {
                pitchCountsRight = totals
            }
        }
    }
}
