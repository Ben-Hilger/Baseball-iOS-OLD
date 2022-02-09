//
//  ZoneAnalytics.swift
//  MU baseball game tracker
//
//  Created by Benjamin Hilger on 2/5/21.
//

import Foundation

class ZoneAnalytics {
    
    // Stores the snapshots
    var snapshots : [GameSnapshot]
    
    init (withGameSnapshots snaps : [GameSnapshot]) {
        snapshots = snaps
    }
    
    /// Gets the total number of pitches that meet the specified filter options
    /// - Parameter filterOptions: The filter options to specify the kinds of pitches desired-
    /// - Returns: An integer representing the total number of pitches
    func  getTotal (withOptions filterOptions
                    : AnalyticsFilterOptions) -> Int {
        // Store the total number of pitches
        var numberOfPitches: Int = 0
        // Explore the snapshots
        for snapshotIndex in 1..<max(snapshots.count,1) {
            let snapshot = snapshots[snapshotIndex]
            let prevSnapshot = snapshots[snapshotIndex - 1]
            
            let prevStrikes = prevSnapshot.currentHitter != snapshot.currentHitter ?
                0 : prevSnapshot.eventViewModel.numStrikes
            let prevBalls = prevSnapshot.currentHitter != snapshot.currentHitter ?
                0 : prevSnapshot.eventViewModel.numBalls
            // Check the filter to ensure it follows the required guideline
            // Currently, it checks for the pitch thrown, the pitcher,
            // the zone, and players on base
//            print(snapshot.eventViewModel.pitchEventInfo?.completedPitch)
            if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
//                print(filterOptions.passesFilter(withGameInformation:
//                                                    snapshot,
//                                                  withPitch: pitch,
//                                                  withPrevStrikeCount:
//                                                    prevStrikes,
//                                                  withPrevBallCount:
//                                                    prevBalls))
              
            }
            if let pitch =
                snapshot.eventViewModel.pitchEventInfo?.completedPitch,
               filterOptions.passesFilter(withGameInformation:
                                            snapshot,
                                          withPitch: pitch,
                                          withPrevStrikeCount:
                                            prevStrikes,
                                          withPrevBallCount:
                                            prevBalls) {
                // Increment the number of pitches
                numberOfPitches += 1
            }
        }
        // Return the number of pitches
        return numberOfPitches
    }
    
    
    
}
