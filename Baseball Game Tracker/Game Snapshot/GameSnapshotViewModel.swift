// Copyright 2021-Present Benjamin Hilger

import Foundation
import SwiftUI

class GameSnapshotViewModel : ObservableObject {
    
    @Published var atBatSelected : String?
    
    @Published var gameSnapshotIndex : [Int]?
    @Published var gameSnapshotIndexSelected : Int?
    
    @Published var snapshotFieldEditMode : GameSnapshotFieldEditType = .BallZone
    
    
    func organizeByAtBats(fromGameViewModel gameViewModel : GameViewModel, fromInning inning : Int) -> [Int : [String : [Int]]] {
        var organizedSnapshots : [Int : [String : [Int]]] = [:]

        for index in 1..<gameViewModel.snapShotIndex {
            let snapshot = gameViewModel.gameSnapshots[index]
            
            if let atBat = snapshot.currentAtBat,
               let atBatNum = Int(atBat.atBatID) {
               // Filters by inning number. 1 = 1,2 2 = 3,4 3 = 5,6....
               if snapshot.currentInning?.inningNum == inning+(inning-1) || snapshot.currentInning?.inningNum == inning*2 {
                var currentAtBat = organizedSnapshots[atBatNum] ?? [:]
                var currentPitches = currentAtBat[atBat.atBatID] ?? []
                currentPitches.append(index)
                currentAtBat.updateValue(currentPitches, forKey: atBat.atBatID)
                organizedSnapshots.updateValue(currentAtBat, forKey: atBatNum)
               }
            }
        }
        return organizedSnapshots
    }
    
    func getPitchOutcomesFromAtBat(fromGameViewModel gameViewModel : GameViewModel, fromSnapshots snapshots : [Int]) -> [Pitch] {
        var pitches : [Pitch] = []
        
        for snapshotIndex in snapshots {
            let snapshot = gameViewModel.gameSnapshots[snapshotIndex]
            if let pitchInfo = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
                pitches.append(pitchInfo)
            }
        }
        return pitches
    }
    
    func getAtBatResults(fromGameViewModel gameViewModel : GameViewModel, fromInning inning : Int) -> [GameSnapshotCellInfo] {
        let organizedSnapshots = organizeByAtBats(fromGameViewModel: gameViewModel, fromInning: inning)
        
        var results : [GameSnapshotCellInfo] = []
        
        let sortedKeys = organizedSnapshots.keys.sorted()
        
        for key in sortedKeys {
            for snapshots in organizedSnapshots[key]! {
                if let finalIndex = snapshots.value.last {
                    let final = gameViewModel.gameSnapshots[finalIndex]
                    let cell = GameSnapshotCellInfo(atBatID: snapshots.key, atBatResultInfo: AtBatAnalysis.getAtBatResult(forLastSnapshots: final, withHitter: final.currentHitter!)/*convertAtBatResultToText(forSnapshot: final)*/, snapshotIndex: snapshots.value, numOuts: final.eventViewModel.numberOfOuts)
                    results.append(cell)
                    
                    if let atBat = final.currentAtBat, atBat.atBatID == atBatSelected {
                        let outcomes = getPitchOutcomesFromAtBat(fromGameViewModel: gameViewModel, fromSnapshots: snapshots.value)
                        for index in 0..<outcomes.count {
                            let pitch = outcomes[index]
                            var cell = GameSnapshotCellInfo(pitchNumber: index+1, pitchType: outcomes[index].pitchType?.getPitchTypeString() ?? "", pitchResult: outcomes[index].pitchResult!, pitchVelo: outcomes[index].pitchVelo, snapshotIndex: snapshots.value, numOuts: final.eventViewModel.numberOfOuts)
                            for change in gameViewModel.lineup.lineupChanges {
                                // Checks if the change occured during this pitch
                                if change.pitchNumChanged == pitch.pitchNumber {
                                    cell.homeLineupChanges = change.getChangeInLineup(forTeam: .Home)
                                    cell.awayLineupChanges = change.getChangeInLineup(forTeam: .Away)
                                }
                            }
                            results.append(cell)
                        }
                    }
                }
            }
        }
        return results
    }
    
    func convertAtBatResultToText(forSnapshot snapshot : GameSnapshot) -> String {
        if let atBat = snapshot.currentAtBat, let pitcher = snapshot.getCurrentPitcher(), let hitter = snapshot.currentHitter {
            if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
                // Checks if the hitter has three strikes
                if snapshot.eventViewModel.numStrikes == 3 {
                    if pitch.pitchResult == .StrikeCalled {
                        return "\(hitter.member.lastName) struck out looking."
                    } else if pitch.pitchResult == .StrikeSwingMiss {
                        return "\(hitter.member.lastName) struck out swinging."
                    }
                }
                
            }
            return "Awating At Bat Results for \(hitter.member.getFullName())"
        }
        return "Awating At Bat Results"
    }

}

struct GameSnapshotCellInfo : Identifiable {
    var id = UUID()
    
    var atBatID : String?
    var atBatResultInfo : String?
    var pitchNumber : Int?
    var pitchType : String?
    var pitchResult : PitchOutcome?
    var pitchVelo : Float?
    var homeLineupChanges : [MemberInGame] = []
    var awayLineupChanges : [MemberInGame] = []
    var snapshotIndex : [Int]?
    var numOuts: Int
}
