// Copyright 2021-Present Benjamin Hilger

import Foundation

class PitchingChartViewModel : ObservableObject {
    
    
    // Store the loaded pitcher
    @Published var loadedPitcher: [Member] = []
    // Store the loaded information for the current pitcher
    @Published var loadedInformation: [PitchingChartRow] = []
    @Published var loadedTotals: [PitchingTotalRow] = []
    
    func getPitcherIDs(withPitchers pitchers: [Member]) -> [String] {
        var ids: [String] = []
        for pitcher in pitchers {
            ids.append(pitcher.memberID)
        }
        return ids
    }
    
    func loadPitcherInformation(withGameInformation gameInfo: GameViewModel,
                                withPitchers pitcher: [Member]) {
        let ids = getPitcherIDs(withPitchers: pitcher)
        // Set the pitcher and reset the loaded information
        loadedPitcher = pitcher
        loadedInformation = []
        loadedTotals = []
        var loadedPitchers: [String] = []
        // Navigate all of the game history snapshots
        for snapshotIndex in 0..<gameInfo.snapShotIndex {
            // Get the current snapshot
            let snapshot = gameInfo.gameSnapshots[snapshotIndex]
            // Check if the requested pitcher was pitching, and there was a pitch thrown
            if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch,
               ids.contains(snapshot.eventViewModel.pitcherID), snapshotIndex > 0 {
                // Get the hitter from the opposing team
                if let hitter = extractHitterInformation(fromGameLineup: gameInfo.lineup,
                                                      // Away is hitting if top of inning, Home if bottom
                                                      fromTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home,
                                                      withHitterID: snapshot.eventViewModel.hitterID) {
                    // Get the hitting hand
                    let hittingHand = pitch.hitterHittingHand
    
                    // Create the pitch row information
                    var newPitchRow = PitchingChartRow(batter: hitter,
                                                       batterHand: hittingHand,
                                                       pitcherHand: pitch.pitcherThrowingHand,
                                                       str: pitch.pitchingStyle == .Stretch,
                                                       pitch: pitch.pitchType,
                                                       location: pitch.pitchLocation,
                                                       isBIP:
                                                        pitch.pitchResult,
                                                       velocity: pitch.pitchVelo != 0 ? pitch.pitchVelo : nil,
                                                       outcome: AtBatAnalysis.getAtBatResult(forLastSnapshots: snapshot, withHitter: snapshot.currentHitter!, useLongDescriptions: false) + "\n \(snapshot.eventViewModel.pitchEventInfo?.ballLocation?.getShortDescription() ?? "")",
                                                       type: pitch.bipType,
                                                       ballFieldLocation: pitch.ballFieldLocation,
                                                       lastInInning: snapshotIndex + 1 >= gameInfo.snapShotIndex ||
                                                        (snapshotIndex + 1 < gameInfo.snapShotIndex && gameInfo.gameSnapshots[snapshotIndex + 1].currentInning != snapshot.currentInning))
                    // Check if it's the first pitching row for the pitcher
                    if (snapshotIndex - 1 >= 0 &&
                            gameInfo.gameSnapshots[snapshotIndex - 1].eventViewModel.pitcherID
                            != snapshot.eventViewModel.pitcherID) || snapshotIndex == 1 {
                        for p in pitcher {
                            if p.memberID == snapshot.eventViewModel.pitcherID {
                                newPitchRow.pitcherName = p.getFullName()
                                if !loadedPitchers.contains(snapshot.eventViewModel.pitcherID) {
                                    loadedPitchers.append(snapshot.eventViewModel.pitcherID)
                                    var row = PitchingTotalRow(
                                        pitcherName: p.getFullName(),
                                        FBK: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Fastball], withPitcherHand: .Left, withPitcher: p),
                                        FBTotal: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Fastball], withPitcherHand: .Left, withPitcher: p),
                                        FBSM: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Fastball], withPitcherHand: .Left, withPitcher: p),
                                        BBK: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Curveball, .Slider], withPitcherHand: .Left, withPitcher: p),
                                        BBTotal: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Curveball, .Slider], withPitcherHand: .Left, withPitcher: p),
                                        BBSM: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Curveball, .Slider], withPitcherHand: .Left, withPitcher: p),
                                        SLK: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown:
                                                        [.Slider], withPitcherHand: .Left, withPitcher: p),
                                        SLTotal: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Slider],
                                                          withPitcherHand: .Left,withPitcher: p),
                                        SLSM: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Slider], withPitcherHand: .Left, withPitcher: p),
                                        CHUPK: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Changeup],withPitcherHand: .Left, withPitcher: p),
                                        CHUPTotal: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Changeup], withPitcherHand: .Left,withPitcher: p),
                                        CHUPSM: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Changeup], withPitcherHand: .Left,withPitcher: p),
                                        OTHERK: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Cutter, .Splitter], withPitcherHand: .Left,withPitcher: p),
                                        OTHERTotal: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Cutter, .Splitter], withPitcherHand: .Left,withPitcher: p),
                                        OTHERSM: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Cutter, .Splitter],withPitcherHand: .Left, withPitcher: p),
                                        FPK: getTotalFPS(fromGameViewModel: gameInfo, withHand: .Left, withPitcher: p),
                                        totalAtbats: getTotalAtBat(withGameViewModel: gameInfo, withHand: .Left, withPitcher: p),
                                        first2o3: getTotal2o3(fromGameViewModel: gameInfo, withHand: .Left, withPitcher: p),
                                        FBKRHH: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Fastball], withPitcherHand: .Right, withPitcher: p),
                                        FBTotalRHH: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Fastball], withPitcherHand: .Right, withPitcher: p),
                                        FBSMRHH: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Fastball], withPitcherHand: .Right, withPitcher: p),
                                        BBKRHH: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Curveball, .Slider], withPitcherHand: .Right, withPitcher: p),
                                        BBTotalRHH: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Curveball, .Slider], withPitcherHand: .Right, withPitcher: p),
                                        BBSMRHH: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Curveball, .Slider], withPitcherHand: .Right, withPitcher: p),
                                        SLKRHH: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown:
                                                        [.Slider], withPitcherHand: .Right, withPitcher: p),
                                        SLTotalRHH: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Slider], withPitcherHand: .Right,withPitcher: p),
                                        SLSMRHH: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Slider], withPitcherHand: .Right, withPitcher: p),
                                        CHUPKRHH: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Changeup],withPitcherHand: .Right, withPitcher: p),
                                        CHUPTotalRHH: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Changeup], withPitcherHand: .Right,withPitcher: p),
                                        CHUPSMRHH: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Changeup], withPitcherHand: .Right,withPitcher: p),
                                        OTHERKRHH: getTotalK(fromGameViewModel: gameInfo, ofPitchThrown: [.Cutter, .Splitter], withPitcherHand: .Right,withPitcher: p),
                                        OTHERTotalRHH: getTotal(fromGameViewModel: gameInfo, ofPitchThrown: [.Cutter, .Splitter], withPitcherHand: .Right,withPitcher: p),
                                        OTHERSMRHH: getTotalSM(fromGameViewModel: gameInfo, ofPitchThrown: [.Cutter, .Splitter],withPitcherHand: .Right, withPitcher: p),
                                        FPKRHH: getTotalFPS(fromGameViewModel: gameInfo, withHand: .Right, withPitcher: p),
                                        totalAtbatsRHH: getTotalAtBat(withGameViewModel: gameInfo, withHand: .Right, withPitcher: p),
                                        first2o3RHH: getTotal2o3(fromGameViewModel: gameInfo, withHand: .Right, withPitcher: p))
                                    var types = getPitchesThrown(fromGameViewModel: gameInfo, forPitcher: p)
                                    for type in types {
                                        row.pitchTypes.append(type)
                                        row.maxValues.append(getMaxVelocity(fromGameViewModel: gameInfo, forPitch: type, forPitcher: p))
                                        row.avgValues.append(getAvgVelocity(fromGameViewModel: gameInfo, forPitch: type, forPitcher: p))
                                    }
                                    loadedTotals.append(row)
                                }
                            }
                        }
                    }
                    
                    // Add the new pitch row to the list
                    loadedInformation.append(newPitchRow)
                }
                
            }
        }
    }
    
    func getMaxVelocity(fromGameViewModel gameViewModel : GameViewModel,
                        forPitch pitch : PitchType,
                        forPitcher player: Member) -> Int {
        var maxVelo = 0
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               let type = snapshot.eventViewModel.pitchEventInfo?.selectedPitchThrown,
               let velo = snapshot.eventViewModel.pitchEventInfo?.pitchVelo,
               type == pitch {
                maxVelo = max(maxVelo, Int(velo))
            }
                
        }
        return maxVelo
    }
    
    func getAvgVelocity(fromGameViewModel gameViewModel : GameViewModel,
                        forPitch pitch : PitchType,
                        forPitcher player: Member) -> Int {
        var sum = 0
        var count = 0
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               let type = snapshot.eventViewModel.pitchEventInfo?.selectedPitchThrown,
               let velo = snapshot.eventViewModel.pitchEventInfo?.pitchVelo,
               type == pitch {
                count += 1
                sum += Int(velo)
            }
        }
        if (count == 0) {
            return 0
        }
        return sum/count
    }
    
    func getPitchesThrown(fromGameViewModel gameViewModel: GameViewModel,
                          forPitcher player: Member) -> [PitchType] {
        var types: [PitchType] = []
        
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               let type = snapshot.eventViewModel.pitchEventInfo?.selectedPitchThrown,
               !types.contains(type) {
               types.append(type)
            }
        }
        return types
    }
    
    func extractHitterInformation(fromGameLineup lineup: Lineup,
                                  fromTeam team: GameTeamType,
                                  withHitterID hitterID: String) -> MemberInGame? {
        // Get the appropriate roster
        let roster = team == .Away ?
            lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster
        // Navigate and find the hitter from the lineup
        for player in roster {
            // Check if the current player has the same id
            if player.member.memberID == hitterID {
                // Return the player
                return player
            }
        }
        // Return nil
        return nil
    }
    
    func getTotal(fromGameViewModel gameViewModel : GameViewModel,
                  ofPitchThrown pitchThrown: [PitchType],
                  withPitcherHand hand: HandUsed,
                  withPitcher player : Member) -> Int {
        var total: Int = 0
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               let pitchT = snapshot.eventViewModel.pitchEventInfo?.selectedPitchThrown,
               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand == hand,
               pitchThrown.contains(pitchT) {
                total += 1
            }
        }
        return total
    }
    
    func getTotalK(fromGameViewModel gameViewModel : GameViewModel,
                   ofPitchThrown pitchThrown: [PitchType],
                   withPitcherHand hand: HandUsed,
                   withPitcher player : Member) -> Int  {
        var total: Int = 0
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               let pitchT = snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchType,
               pitchThrown.contains(pitchT),
               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand == hand,
               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false {
                total += 1
            }
        }
        return total
    }
    
    func getTotalSM(fromGameViewModel gameViewModel : GameViewModel,
                    ofPitchThrown pitchThrown: [PitchType],
                    withPitcherHand hand: HandUsed,
                    withPitcher player : Member) -> Int {
        var total: Int = 0
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               let pitchT = snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchType,
               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand == hand,
               pitchThrown.contains(pitchT),
               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrikeSwinging() ?? false {
                total += 1
            }
        }
        return total
    }
    
    func getTotalFPS(fromGameViewModel gameViewModel : GameViewModel,
                     withHand hand: HandUsed,
                     withPitcher player : Member) -> Int {
        var total: Int = 0
        var atBats: [Int : [GameSnapshot]] = [:]
        
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
            snapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand == hand,
               snapshot.eventViewModel.pitchEventInfo?.completedPitch != nil  {
                var currentEvents: [GameSnapshot] = atBats[Int(snapshot.currentAtBat!.atBatID)!] ?? []
                currentEvents.append(snapshot)
                atBats.updateValue(currentEvents, forKey: Int(snapshot.currentAtBat!.atBatID)!)
            }
        }

        
        for atBat in atBats {
            var als = atBat.value
            als.sort { (snapshot, snapshot2) -> Bool in
                snapshot.snapshotIndex < snapshot2.snapshotIndex
            }
            if let first = als.first {
                if first.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false {
                    total += 1
                }
            }
        }
        
        return total
    }
    
    func getTotal2o3(fromGameViewModel gameViewModel : GameViewModel,
                     withHand hand: HandUsed,
                     withPitcher player : Member) -> Int {
        var total: Int = 0
        var atBats: [Int : [GameSnapshot]] = [:]
        
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand == hand,
               snapshot.eventViewModel.pitchEventInfo?.completedPitch != nil {
                var currentEvents: [GameSnapshot] = atBats[Int(snapshot.currentAtBat!.atBatID)!] ?? []
                currentEvents.append(snapshot)
                atBats.updateValue(currentEvents, forKey:Int(snapshot.currentAtBat!.atBatID)!)
            }
        }
        
        for atBat in atBats {
            let snapshots = atBat.value
            if snapshots.count >= 3, let last = snapshots.last {
                let shouldAdd = last.eventViewModel.pitchEventInfo?.completedPitch?
                    .pitchResult != .HBP
                let first = snapshots[0].eventViewModel.pitchEventInfo?.completedPitch?
                    .pitchResult?.isStrike() ?? false ? 1 : 0
                let second = snapshots[1].eventViewModel.pitchEventInfo?.completedPitch?
                    .pitchResult?.isStrike() ?? false ? 1 : 0
                let third = snapshots[2].eventViewModel.pitchEventInfo?.completedPitch?
                    .pitchResult?.isStrike() ?? false ? 1 : 0
                if shouldAdd && (first + second + third >= 2){
                    total += 1
                }
            } else {
                var add = true
                for snapshot in snapshots {
                    if snapshot.eventViewModel.pitchEventInfo?
                        .completedPitch?.pitchResult == .HBP {
                        add = false
                    }
                }
                if (add) {
                    total += 1
                }
            }
//            als.sort { (snapshot, snapshot2) -> Bool in
//                snapshot.snapshotIndex < snapshot2.snapshotIndex
//            }
//            if atBat.value.count >= 3 {
////                var add = true
////                if atBat.value.last?.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP {
////                    add = false
////                }
////                let first: Int = atBat.value[0].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false ?
////                atBat.value[0].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP ? -3 : 1 : 0
////                let second: Int = atBat.value[1].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false ?
////                    atBat.value[1].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP ? -3 : 1 : 0
////                let third: Int = atBat.value[2].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false ?
////                    atBat.value[2].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP ? -3 : 1 : 0
////                if first + second + third >= 2 {
////                    total += add ? 1 : 0
////                }
//            } else {
//                var add = true
//                for a in atBat.value {
//                    if a.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP {
//                        add = false
//                    }
//                }
//                total += add ? 1 : 0
//            }
        }
        
        return total
    }
    
    func getTotalAtBat(withGameViewModel gameViewModel: GameViewModel,
                       withHand hand: HandUsed,
                       withPitcher player : Member) -> Int {
        var atBats: Set<Int> = Set()
        
        for snapshot in gameViewModel.gameSnapshots {
            if snapshot.eventViewModel.pitcherID == player.memberID,
            snapshot.eventViewModel.pitchEventInfo?
                .completedPitch?.hitterHittingHand == hand {
                atBats.insert(Int(snapshot.currentAtBat!.atBatID)!)
            }
        }
        return atBats.count
    }
    
}

struct PitchingTotalRow : Identifiable {
    var id = UUID()
    
    var pitcherName: String
    
    var FBK = 0
    var FBTotal = 0
    var FBSM = 0
    
    var BBK = 0
    var BBTotal = 0
    var BBSM = 0
    var SLK = 0
    var SLTotal = 0
    var SLSM = 0
    var CHUPK = 0
    var CHUPTotal = 0
    var CHUPSM = 0
    var OTHERK = 0
    var OTHERTotal = 0
    var OTHERSM = 0
    
    var FPK = 0
    var totalAtbats = 0
    var first2o3 = 0
    
    var FBKRHH = 0
    var FBTotalRHH = 0
    var FBSMRHH = 0
    
    var BBKRHH = 0
    var BBTotalRHH = 0
    var BBSMRHH = 0
    var SLKRHH = 0
    var SLTotalRHH = 0
    var SLSMRHH = 0
    var CHUPKRHH = 0
    var CHUPTotalRHH = 0
    var CHUPSMRHH = 0
    var OTHERKRHH = 0
    var OTHERTotalRHH = 0
    var OTHERSMRHH = 0
    
    var FPKRHH = 0
    var totalAtbatsRHH = 0
    var first2o3RHH = 0
    
    var pitchTypes: [PitchType] = []
    var maxValues: [Int] = []
    var avgValues: [Int] = []
    
}

struct PitchingChartRow : Identifiable {
    var id = UUID()
    // Store the batter
    var batter: MemberInGame
    // Store the batter hand
    var batterHand: HandUsed
    // Store the pitcher hand
    var pitcherHand: HandUsed
    var str: Bool
    // Store the pitch type
    var pitch: PitchType? = nil
    // Store the pitch location
    var location: PitchLocation? = nil
    // Store if the pitch was a strike
    var isBIP: PitchOutcome? = nil
    // Store the pitch velocity
    var velocity: Float? = nil
    // Store the outcome
    var outcome: String? = nil
    // Store the BIP Type
    var type: BIPType? = nil
    // Store the ball field location
    var ballFieldLocation: BallFieldLocation? = nil
    // Store if it's the last one of the inning
    var lastInInning: Bool = false
    // Store the pitcher name
    var pitcherName: String?
}
