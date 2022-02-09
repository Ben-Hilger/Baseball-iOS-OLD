// Copyright 2021-Present Benjamin Hilger

import Foundation

class BoxScoreAnalytics {
    
    func getAllHitterIDs(fromGameViewModel gameViewModel : GameViewModel, fromCurrentTeam team : GameTeamType) -> [String] {
        var ids : [String] = []
        
        for member in (team == .Away ? gameViewModel.lineup.totalAwayTeamRoster : gameViewModel.lineup.totalHomeTeamRoster) {
            ids.append(member.member.memberID)
        }
        
//        
//        if gameViewModel.snapShotIndex > 0 {
//            for snapshot in gameViewModel.gameSnapshots[0...gameViewModel.snapShotIndex-1] {
//                if let hitter = snapshot.currentHitter, !ids.contains(hitter.member.memberID), team == .Away ? snapshot.currentInning?.isTop ?? false : !(snapshot.currentInning?.isTop ?? true) {
//                    ids.append(hitter.member.memberID)
//                }
//            }
//        }
//        
        return ids //getHitterNames(fromIds: ids, fromLineup: gameViewModel.lineup, fromCurrentTeam: team)
    }
    
    func getHitterName(fromId id : String, fromLineup lineup : Lineup, fromCurrentTeam team : GameTeamType) -> String {
        
        for member in (team == .Away ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster) {
            if id == member.member.memberID {
                return member.member.getFullName()
            }
        }
        
        return ""
    }
}
