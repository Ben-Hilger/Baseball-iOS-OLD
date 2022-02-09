// Copyright 2021-Present Benjamin Hilger

import Foundation

class EarnedRunAnalysis {
    
    func determineIfRunnerHasEarnedRun(snapshots: [GameSnapshot],
                                       inningToAnalyze inning: Inning,
                                       atBatToAnalyze atBat: AtBat,
                                       runner: MemberInGame) -> Bool {
        // Get only the snapshots from the inning being analyzed
        let inningSnapshots = extractInningSnapshots(snapshots: snapshots,
                                                     withRunner: runner,
                                                     currentAtBat: atBat,
                                                     inningToAnalyze: inning)
        for snapshot in inningSnapshots {
            // Check if the snapshot where the runner made it on base with a
            // catchers interference or error (scenario #1). This is automatically
            // an unearned run
            if snapshot.currentHitter == runner,
               (snapshot.eventViewModel.pitchEventInfo?
                    .completedPitch?.pitchResult == .CatcherInter ||
                snapshot.eventViewModel.pitchEventInfo?
                    .completedPitch?.bipHit.contains(.Error) ?? false) {
                return false
            // Check if the runner is on base AFTER the pitch of the current snapshot
            // Then, also check if the pitch was a safe on fielder's choice + error, which
            // would result in the runner getting out if the error didn't exist (scennario #3)
            } else if isRunnerOnBase(withRunner: runner, withSnapshot: snapshot) &&
                snapshot.eventViewModel.pitchEventInfo?
                    .completedPitch?.bipHit.contains(.FielderChoice) ?? false &&
                snapshot.eventViewModel.pitchEventInfo?
                    .completedPitch?.bipHit.contains(.Error) ?? false {
                return false
            // Check if the runner reaches base on a dropped third strike passed ball (scenario #4)
            } else if snapshot.currentHitter == runner,
                      (snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .DroppedThirdLookingSafePassedBall ||
                        snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .DroppedThirdSwingingSafePassedBall) {
                return false
            // Check if the runner scored after two outs and an error (scenario #5)
            } else if runnerScoredAfterTwoOutError(hitter: runner, withAtBat: atBat, withSnapshots: snapshots) {
                return false
            // Check if the runner advanced on a passed ball (scenario #6)
            } else if runnerAdvanced(forRunner: runner.member, forSnapshot: snapshot) &&
                        snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isPassedBall() ?? false {
                return false
            // Check if when the runner scored (last snapshot) and the pitch
            // result was a fly ball error and the runner wouldn't have scored otherwise (scenario #2)
            } else if inningSnapshots.last?.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .FoulBallDropped &&
                        !runnerWouldScoreLater(forRunner: runner, withAtBat: atBat, withInning: inning, forSnapshots: snapshots){
                return false
            }
        }
        
        // Return true since it didn't hit any of the scenarios
        return true
    }
    
    func extractInningSnapshots(snapshots: [GameSnapshot],
                                withRunner runner: MemberInGame,
                                currentAtBat atbat: AtBat,
                                inningToAnalyze inning: Inning) ->
                                                        [GameSnapshot] {
        var inningSnapshots: [GameSnapshot] = []
        var foundAtBat: Bool = false
        for snapshot in snapshots {
            // Check if the snapshot contains the wanted at bat
            if snapshot.currentAtBat == atbat {
                foundAtBat = true
            }
            
            // If the inning is correct and it found the at bat, add it to the
            // list
            if snapshot.currentInning == inning, foundAtBat {
                inningSnapshots.append(snapshot)
            }
            // Check if this is where the runner scored after the atbat was found
            if snapshot.eventViewModel.runnersWhoScored.contains(runner.member), foundAtBat {
                // Stop adding snapshots
                break
            }
        }
        return inningSnapshots
    }
    
    func extractRemainingInningSnapshots(snapshots: [GameSnapshot],
                                         currentAtBat atbat: AtBat,
                                         withInning inning: Inning,
                                         withRunner runner: MemberInGame)
                                                -> [GameSnapshot] {
        var inningSnapshots: [GameSnapshot] = []
        var foundAtBat: Bool = false
        var foundScore: Bool = false
        for snapshot in snapshots {
            // Check if the snapshot contains the wanted at bat
            if snapshot.currentAtBat == atbat {
                foundAtBat = true
            }
            // If the inning is correct and it found the at bat and when the
            // runner scored, add it to the list
            if snapshot.currentInning == inning, foundAtBat, foundScore {
                inningSnapshots.append(snapshot)
            }
            // Check if the snapshot contains when the runner scored
            if snapshot.eventViewModel.runnersWhoScored.contains(runner.member) {
                foundScore = true
            }
        }
        return inningSnapshots
    }
    
    func isRunnerOnBase(withRunner runner: MemberInGame,
                        withSnapshot snapshot: GameSnapshot) -> Bool{
        return snapshot.eventViewModel.playerAtFirstAfter?.playerOnBase == runner ||
            snapshot.eventViewModel.playerAtSecondAfter?.playerOnBase == runner ||
            snapshot.eventViewModel.playerAtThirdAfter?.playerOnBase == runner
    }
    
    /// Checks to see if the runner scored after two outs. This assumes the given runner has scored and
    /// there doesn't check/validate if they runner is scored.
    /// - Parameters:
    ///   - hitter: The hitter/runner that scored
    ///   - snapshots: The game history snapshots of the inning the given hitter/runner scored
    /// - Returns: true if the runner scored after two outs + an error, false otherwise
    func runnerScoredAfterTwoOutError(hitter: MemberInGame,
                                      withAtBat atbat: AtBat,
                                      withSnapshots snapshots: [GameSnapshot])
                                            -> Bool {

        // Go through all of the snapshots
        for snapshot in snapshots {
            // Only add snapshots where there are two outs and the runner scored
            if snapshot.eventViewModel.numberOfOuts == 2, snapshot.currentAtBat == atbat {
                // Check if there are any errors
                if snapshot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.Error) ?? false ||
                    snapshot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.SacFlyError) ?? false ||
                    snapshot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.SacBuntError) ?? false ||
                    snapshot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedHomeError) ?? false ||
                    snapshot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedToThirdError) ?? false ||
                    snapshot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedToSecondError) ?? false {
                    return true
                }
            }
            // Check if the hitter scored (last snapshot that should be added)
            if snapshot.eventViewModel.runnersWhoScored.contains(hitter.member) {
                // Stop adding more
                break
            }
        }
        // Return false since the scenario wasn't found
        return false
    }
    
    func runnerAdvanced(forRunner runner: Member, forSnapshot snapshot: GameSnapshot) -> Bool {
        // Look through all of the base path events
        for event in snapshot.eventViewModel.basePathInfo {
            // Check if the runner is apart of this event, and the event is
            // where the runner advanced to a base
            if runner == event.runnerInvolved.member && (event.type == .AdvancedHome ||
                                                            event.type == .AdvancedSecond ||
                                                            event.type == .AdvancedThird) {
                return true
            }
        }
        return false
    }
    
    func runnerWouldScoreLater(forRunner runner: MemberInGame,
                               withAtBat atBat: AtBat,
                               withInning inning: Inning,
                               forSnapshots snapshots: [GameSnapshot]) -> Bool {
        // Store all of the snapshots of the remaining inning
        let laterSnapshots = extractRemainingInningSnapshots(snapshots: snapshots,
                                                             currentAtBat: atBat,
                                                             withInning: inning,
                                                             withRunner: runner)
        // Store the last base the hitter was at
        let inningSnapshots = extractInningSnapshots(snapshots: snapshots,
                                                     withRunner: runner,
                                                     currentAtBat: atBat,
                                                     inningToAnalyze: inning)
        // Store the last base the player was on
        var lastBase: Base = .Home
        // Check if there was a base the runner was on
        if inningSnapshots.count >= 2 {
            // Get the snapshot with the runners last base information
            // This should be the second-to-last one, since the last one
            // shows the player scoring
            let lastSnapshot = inningSnapshots[inningSnapshots.count - 2]
            lastBase =
                lastSnapshot.eventViewModel.playerAtFirstAfter?.playerOnBase == runner ? .First :
                lastSnapshot.eventViewModel.playerAtSecondAfter?.playerOnBase == runner ? .Second :
                lastSnapshot.eventViewModel.playerAtThirdAfter?.playerOnBase == runner ? .Third :
                .Home
        }
        
        // Explore the different events after the runner scores
        for snapshot in laterSnapshots {
            // Checks if there was a single, advancing the runner one base
            if snapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipHit.contains(.FirstB) ?? false {
                lastBase = Base(rawValue: lastBase.rawValue + 1) ?? .Home
            // Checks if there was a double, advancing the runner two bases
            } else if snapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipHit.contains(.SecondB) ?? false {
                lastBase = Base(rawValue: lastBase.rawValue + 2) ?? .Home
            // Checks if there was a triple, advancing the runner three bases
            } else if snapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipHit.contains(.ThirdB) ?? false {
                lastBase = Base(rawValue: lastBase.rawValue + 3) ?? .Home
            // Checks if there was a home run, taking the player immediately to home
            } else if snapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipHit.contains(.HR) ?? false ||
                        snapshot.eventViewModel.pitchEventInfo?.completedPitch?.bipHit.contains(.HRInPark) ?? false {
                lastBase = .Home
            }
        }
 
        return lastBase == .Home
    }
}
