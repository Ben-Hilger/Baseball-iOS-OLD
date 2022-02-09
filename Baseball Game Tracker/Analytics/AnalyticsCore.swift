// Copyright 2021-Present Benjamin Hilger

import Foundation

class AnalyticsCore {
    
    static func getTotalErrors(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType) -> Int {
        var total : Int = 0
        
        var prevInningNum : Int? = nil
        for snapshotIndex in 0..<gameViewModel.snapShotIndex {
            let snapshot = gameViewModel.gameSnapshots[snapshotIndex]
            if team == .Home ? snapshot.currentInning?.isTop ?? false : !(snapshot.currentInning?.isTop ?? true) {
                let eventView = snapshot.eventViewModel
                var errorTotal : Int = eventView?.playerWhoCommittedError.count ?? 0
                for event in eventView?.basePathInfo ?? [] {
                    if event.type == BasePathType.AdvancedHomeError || event.type == BasePathType.AdvancedThirdError || event.type == .AdvancedSecondError {
                        errorTotal += 1
                    }
                }
                total += errorTotal
            }
        }
        
        return total
    }
    
    static func getNumberofQABs(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var qab : [String : Bool] = [:]
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        var pitchesAfter2Strikes = 0
                        var numStrikes = 0
                        var numBalls = 0
                        var walk = false
                        var hbp = false
                        var sac = false
                        var hit = false
                        var advancedRunner = false
                        if numStrikes == 2 {
                            pitchesAfter2Strikes += 1
                        }
                        // Add ability to count pitches
                        if pitch.pitchResult == .BIP {
                            hit = true
                            if snapshot > 0 && gameViewModel.gameSnapshots[snapshot-1].currentInning?.inningNum == currentSnapshot.currentInning?.inningNum {
                                let prevSnapshot = gameViewModel.gameSnapshots[snapshot-1]
                                if prevSnapshot.getLeadRunner()?.playerOnBase == currentSnapshot.getLeadRunner()?.playerOnBase && prevSnapshot.eventViewModel.numberOfOuts == 0{
                                    for event in currentSnapshot.eventViewModel.basePathInfo {
                                        if event.type == .AdvancedHome || event.type == .AdvancedThird || event.type == .AdvancedHome {
                                            advancedRunner = true
                                        }
                                    }
                                }
                            }
                        }
                        if pitch.pitchResult == .HBP {
                            hbp = true
                        }
                        if pitch.bipHit.contains(.SacBunt) || pitch.bipHit.contains(.SacFly) ||
                            pitch.bipHit.contains(.SacFlyError) || pitch.bipHit.contains(.SacBuntError) {
                            sac = true
                        }
                        if pitch.pitchResult == .BIP {
                            
                        }
                        if currentSnapshot.eventViewModel.numBalls == 4 {
                            walk = true
                        }
                        numStrikes = max(numStrikes, currentSnapshot.eventViewModel.numStrikes)
                        numBalls = max(numBalls, currentSnapshot.eventViewModel.numBalls)
                        if (pitchesAfter2Strikes >= 4 || walk || hbp ||
                            (numStrikes >= 1 && hit) || sac ||
                                advancedRunner) && team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true) {
                            qab.updateValue(true, forKey: atBat.atBatID)
                        }
                    }
                }
            }
        }
        return qab.count
    }
    
    static func getTotalLOB(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType) -> Int {
        var lob : [Int : Int] = [:]
        for snapshotIndex in 0..<gameViewModel.snapShotIndex {
            let snapshot = gameViewModel.gameSnapshots[snapshotIndex]
            if let inning = snapshot.currentInning, team == .Away ? snapshot.currentInning?.isTop ?? false : !(snapshot.currentInning?.isTop ?? true) {
                let LOB = (snapshot.eventViewModel.playerAtFirstAfter != nil ? 1 : 0) +
                (snapshot.eventViewModel.playerAtSecondAfter != nil ? 1 : 0) +
                (snapshot.eventViewModel.playerAtThirdAfter != nil ? 1 : 0)
                if let LOBCurrent = lob[inning.inningNum]  {
                    lob.updateValue(max(LOBCurrent, LOB), forKey: inning.inningNum)
                } else {
                    lob.updateValue(LOB, forKey: inning.inningNum)
                }
            }
        }
        
        var total : Int = 0
        
        for lob in lob {
            total += lob.value
        }
        
        return total
    }
    
    // Doesn't count if the atbat ended on the base path and the hitter didn't end it
    static func getTotalPA(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var paCounts : [String : Bool] = [:]
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, let inning = currentSnapshot.currentInning, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), atBat.atBatID != gameViewModel.currentAtBat?.atBatID, satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the last pitch didn't three outs that wasn't caused by a strikeout
                        if !(currentSnapshot.eventViewModel.numStrikes <= 2 && (pitch.pitchResult == .StrikeCalled || pitch.pitchResult == .StrikeSwingMiss || pitch.pitchResult == .PassedBallStrikeSwinging || pitch.pitchResult == .WildPitchStrikeSwinging) && currentSnapshot.eventViewModel.numberOfOuts == 3) {
                            paCounts.updateValue(true, forKey: atBat.atBatID)
                        } else {
                            paCounts.updateValue(false, forKey: atBat.atBatID)
                        }
                    }
                }
//                if let pitch = atBat.pitches.last {
//                    if satifysFilter(forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
//                        // Checks if the last pitch didn't three outs that wasn't caused by a strikeout
//                        if !(pitch.numStrikes <= 2 && (pitch.pitchResult == .StrikeCalled || pitch.pitchResult == .StrikeSwingMiss || pitch.pitchResult == .PassedBallStrikeSwinging || pitch.pitchResult == .WildPitchStrikeSwinging) && inning.outsInInning == 3) {
//                            paCounts.updateValue(true, forKey: atBat.atBatID)
//                        } else {
//                            paCounts.updateValue(false, forKey: atBat.atBatID)
//                        }
//                    }
//                }
            }
        }
        var paCount = 0
        for count in paCounts {
            if count.value {
                paCount += 1
            }
        }
        return paCount
    }
    
    static func getTotalFPS(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var fpsCount = 0
        var currentAtBatID : String? = nil
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat,team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let currentAtBat = currentAtBatID, currentAtBatID != atBat.atBatID, let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        if (pitch.pitchResult == .StrikeCalled || pitch.pitchResult == .StrikeSwingMiss || pitch.pitchResult == .PassedBallStrikeSwinging || pitch.pitchResult == .WildPitchStrikeSwinging) {
                            fpsCount += 1
                        }
                    }
                    currentAtBatID = atBat.atBatID
                } else if currentAtBatID == nil, let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    currentAtBatID = atBat.atBatID
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        if (pitch.pitchResult == .StrikeCalled || pitch.pitchResult == .StrikeSwingMiss || pitch.pitchResult == .PassedBallStrikeSwinging || pitch.pitchResult == .WildPitchStrikeSwinging) {
                            fpsCount += 1
                        }
                    }
                }
//                if atBat.pitches.count > 0 {
//
//                    previousHitter = firstPitch.hitterID
//                }
            }
        }
        return fpsCount
    }
    
//    static func getTotalSwingsAndMisses(forTeam team : GameTeamType, settingsViewModel : SettingsViewModel) -> Int {
//        var swingAndMissCount : Int = 0
//        for snapshot in 0..<snapShotIndex {
//            let currentSnapshot = gameSnapshots[snapshot]
//            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true) {
//                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
//                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
//                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
//                if let pitch = atBat.pitches.last {
//                    if satifysFilter(forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
//                        if pitch.pitchResult == .StrikeSwingMiss || pitch.pitchResult == .PassedBallStrikeSwinging || pitch.pitchResult == .WildPitchStrikeSwinging {
//                            swingAndMissCount += 1
//                        }
//                    }
//                }
//            }
//        }
//        return swingAndMissCount
//    }
//
    static func getTotal(fromGameViewModel gameViewModel : GameViewModel, withPitchOutcomes outcomes : [PitchOutcome], forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var totalCount : Int = 0
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        if let outcome = pitch.pitchResult, outcomes.contains(outcome) {
                            totalCount += 1
                        }
                    }
                }
            }
        }
        return totalCount
    }
    
    static func getTotal(fromGameViewModel gameViewModel : GameViewModel, withBIPOutcomes outcomes : [BIPHit], forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var totalCount : Int = 0
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        var counts = false
                        for outcome in outcomes {
                            if pitch.bipHit.contains(outcome) {
                                counts = true
                            }
                        }
                        if counts {
                            totalCount += 1
                        }
                    }
                }
            }
        }
        return 0
    }
    
//    static func getTotalSwings(forTeam team : GameTeamType, settingsViewModel : SettingsViewModel) -> Int {
//        var swingCount : Int = 0
//        for snapshot in 0..<snapShotIndex {
//            let currentSnapshot = gameSnapshots[snapshot]
//            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true) {
//                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
//                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
//                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
//                if let pitch = atBat.pitches.last {
//                    if satifysFilter(forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
//                        if pitch.pitchResult == .StrikeSwingMiss || pitch.pitchResult == .StrikeCalled || pitch.pitchResult == .BIP || pitch.pitchResult == .PassedBallStrikeSwinging || pitch.pitchResult == .WildPitchStrikeSwinging || pitch.pitchResult == .FoulBall {
//                            swingCount += 1
//                        }
//                    }
//                }
//            }
//        }
//        return swingCount
//    }
    
    static func getTotalFirstPitchFastball(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var totalFPFS : Int = 0
        var previousAtBat : String? = nil
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if previousAtBat != atBat.atBatID, let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        if pitch.pitchType == .Fastball {
                            totalFPFS += 1
                        }
                    }
                    previousAtBat = atBat.atBatID
                } else if previousAtBat == nil, let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        if pitch.pitchType == .Fastball {
                            totalFPFS += 1
                        }
                    }
                    previousAtBat = atBat.atBatID
                }
//                if atBat.pitches.count > 0 {
//                    let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
//                    let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
//                    let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
//                    let firstPitch = atBat.pitches[0]
//                    if satifysFilter(forPitch: firstPitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
//                        if previousHitter != firstPitch.hitterID || previousHitter == nil, firstPitch.pitchType == .Fastball {
//                            totalFPFS += 1
//                        }
//                    }
//                    previousHitter = firstPitch.hitterID
//                }
            }
        }
        
        return totalFPFS
    }
    
    static func getTotalAB(fromGameViewModel gameViewModel : GameViewModel, forTeam team: GameTeamType, settingsViewModel : SettingsViewModel, withBIPResultFilter bipResultFilter : PitchOutcome?=nil, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var abCounts : [String : Bool] = [:]
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the last pitch didn't result in a HBP, Catcher Interference, or a sac bunt/fly
                        if !(pitch.pitchResult == .HBP || pitch.pitchResult == .BIP && (pitch.bipHit.contains(.SacFly) || pitch.bipHit.contains(.SacBunt) || pitch.bipHit.contains(.SacFlyError) || pitch.bipHit.contains(.SacBuntError)) || currentSnapshot.eventViewModel.numBalls == 4 || pitch.pitchResult == .CatcherInter) && (bipResultFilter == nil ? true : pitch.pitchResult == bipResultFilter!){
                            abCounts.updateValue(true, forKey: atBat.atBatID)
                        } else {
                            abCounts.updateValue(false, forKey: atBat.atBatID)
                        }
                    }
                }
            }
        }
        var abCount = 0
        for count in abCounts {
            if count.value {
                abCount += 1
            }
        }
        return abCount
    }
    
    static func getTotalBases(fromGameViewModel gameViewModel : GameViewModel, forTeam team: GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var totalBases = 0
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the pitch result is a BIP
                        if pitch.pitchResult == .BIP {
                            // Adds
                            totalBases += (pitch.bipHit.contains(.FirstB) ? 1 : pitch.bipHit.contains(.SecondB) ? 2 : pitch.bipHit.contains(.ThirdB) ? 3 : pitch.bipHit.contains(.HR) || pitch.bipHit.contains(.HRInPark) ? 4 : 0)
                        }
                    }
                }
            }
        }
        return totalBases
    }
    
    static func getTotalHits(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var totalHits = 0
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the pitch result is a BIP
                        if pitch.pitchResult == .BIP && (pitch.bipHit.contains(.FirstB) || pitch.bipHit.contains(.SecondB) || pitch.bipHit.contains(.ThirdB) || pitch.bipHit.contains(.HR) || pitch.bipHit.contains(.HRInPark)){
                            totalHits += 1
                        }
                    }
                }
            }
        }
        return totalHits
    }
    
    private static func satifysFilter(fromGameViewModel gameViewModel : GameViewModel, forSnapshot snapshot: GameSnapshot, forPitch pitch : Pitch, withAtBatID atBat : String, settingsViewModel : SettingsViewModel, prevFirstBaseState : BaseState?, prevSecondBaseState : BaseState?, prevThirdBaseState : BaseState?) -> Bool {
        return
            // Filters by pitcher and/or hitter handedness if necessary
            (settingsViewModel.pitcherFilterTypes == .All || (settingsViewModel.pitcherFilterTypes == .LHP && pitch.pitcherThrowingHand == .Left) || (settingsViewModel.pitcherFilterTypes == .RHP && pitch.pitcherThrowingHand == .Right)) &&
            (settingsViewModel.hitterFilterTypes == .All || (settingsViewModel.hitterFilterTypes == .LHH && pitch.hitterHittingHand == .Left) || (settingsViewModel.hitterFilterTypes == .RHH && pitch.hitterHittingHand == .Right)) &&
            // Filters by pitch type if necessary
            (settingsViewModel.pitchFilterType == .None || pitch.pitchType == settingsViewModel.pitchFilterType) &&
            // Filters by base state if necessary
            (settingsViewModel.playerOnBaseFilter == .Overall || (settingsViewModel.playerOnBaseFilter == .BasesEmpty && prevFirstBaseState == nil &&  prevSecondBaseState == nil && prevThirdBaseState == nil) || (settingsViewModel.playerOnBaseFilter == .RunnersInScoring && (prevSecondBaseState != nil || prevThirdBaseState != nil))) &&
            // Filters by velocity if necessary
            (settingsViewModel.pitchVelocityFilterType == .Enabled ? pitch.pitchVelo >= Float(settingsViewModel.pitchVelocityFilter) : true) &&
            gameViewModel.currentAtBat?.atBatID != atBat &&
            // Filters by pitcher if necessary
            settingsViewModel.pitcherSelectedFilterType == .All ? true : settingsViewModel.pitcherSelected == snapshot.eventViewModel.pitcherID &&
            // Filters by hitter if necessary
            settingsViewModel.hitterSelectedFilterType == .All ? true : settingsViewModel.hitterSelected == snapshot.eventViewModel.hitterID
        
    }
    
    private static func satisfiesPlayerConstraints(forSnapshot snapshot : GameSnapshot, withPitcher pitcher : String?, withHitter hitter : String?) -> Bool {
        return (pitcher != nil ? snapshot.getCurrentPitcher()?.member.memberID == pitcher : true) &&
            (hitter != nil ? snapshot.currentHitter?.member.memberID == hitter : true)
    }
    
    static func getTotalBIPType(fromGameViewModel gameViewModel : GameViewModel, forTeam team: GameTeamType, settingsViewModel : SettingsViewModel, forBIPType bipType : BIPType, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var bipTypeCounts : [String : Bool] = [:]
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the last pitch didn't resulted in a BIP and had the specified type
                        if pitch.bipType == bipType && pitch.pitchResult == .BIP {
                            bipTypeCounts.updateValue(true, forKey: atBat.atBatID)
                        } else {
                            bipTypeCounts.updateValue(false, forKey: atBat.atBatID)
                        }
                    }
                }
            }
        }
        var bipTypeCount = 0
        for count in bipTypeCounts {
            if count.value {
                bipTypeCount += 1
            }
        }
        return bipTypeCount
    }
    
    static func getTotalWalks(fromGameViewModel gameViewModel : GameViewModel, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var totalWalks = 0
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the pitch result is a walk
                        if currentSnapshot.eventViewModel.numBalls == 4 {
                            totalWalks += 1
                        }
                    }
                }
            }
        }
        return totalWalks
    }
    
    static func getTotalWithResult(ffromGameViewModel gameViewModel : GameViewModel, withResult result : PitchOutcome, forTeam team : GameTeamType, settingsViewModel : SettingsViewModel, withSpecificHitter hitter : String?=nil, withSpecificPitcher pitcher : String?=nil) -> Int {
        var resultDictionary : [String : Bool] = [:]
        for snapshot in 0..<gameViewModel.snapShotIndex {
            let currentSnapshot = gameViewModel.gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true), satisfiesPlayerConstraints(forSnapshot: currentSnapshot, withPitcher: pitcher, withHitter: hitter) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameViewModel.gameSnapshots[gameViewModel.snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(fromGameViewModel: gameViewModel, forSnapshot: currentSnapshot, forPitch: pitch, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
                        // Checks if the last pitch didn't resulted in a BIP and had the specified type
                        if pitch.pitchResult == result {
                            resultDictionary.updateValue(true, forKey: atBat.atBatID)
                        } else {
                            resultDictionary.updateValue(false, forKey: atBat.atBatID)
                        }
                    }
                }
            }
        }
        var resultCount = 0
        for count in resultDictionary {
            if count.value {
                resultCount += 1
            }
        }
        return resultCount
    }
}
