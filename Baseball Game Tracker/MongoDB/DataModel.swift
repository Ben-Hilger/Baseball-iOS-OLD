////
////  DataModel.swift
////  MU baseball game tracker
////
////  Created by Benjamin Hilger on 2/27/21.
////
//
// Copyright 2021-Present Benjamin Hilger

//import Foundation
//import SwiftUI
//
//class MongoDBKeys {
//    static let corePartitionKey: String = "BaseballCoreData"
//}
//
//class RealmBase: Object, ObjectKeyIdentifiable {
//    @objc dynamic var  _id: String = ObjectId.generate().stringValue
//    @objc dynamic var _partitionKey: String = MongoDBKeys.corePartitionKey
//    
//    override class func primaryKey() -> String? {
//        return "_id"
//    }
//    
//}
//
//class RealmMember: RealmBase {
//    @objc dynamic var firstName: String = ""
//    @objc dynamic var lastName: String = ""
//    @objc dynamic var nickName: String = ""
//    @objc dynamic var height: Int = 0
//    @objc dynamic var highSchool: String = ""
//    @objc dynamic var homeTown: String = ""
//    dynamic var positions: RealmSwift.List<Int> = List()
//    @objc dynamic var weight: Int = 0
//    @objc dynamic var bio: String = ""
//    @objc dynamic var role: Int = 0
//    @objc dynamic var throwingHand: Int = 0
//    @objc dynamic var hittingHand: Int = 0
//
//    override static func primaryKey() -> String? {
//        return "_id"
//    }
//    
//    func getMemberRole() -> MemberRole {
//        return MemberRole(rawValue: role) ?? .Player
//    }
//    
//    func getHittingHand() -> HandUsed {
//        return HandUsed(rawValue: hittingHand) ?? .Right
//    }
//    
//    func getThrowingHand() -> HandUsed {
//        return HandUsed(rawValue: throwingHand) ?? .Right
//    }
//        
//    func getFullName() -> String {
//        return "\(firstName) \(lastName)"
//    }
//    
//}
//
//class RealmTeam: RealmBase {
//    @objc dynamic var teamName: String = ""
//    @objc dynamic var teamAbbr: String = ""
//    @objc dynamic var teamNickname: String = ""
//    @objc dynamic var cityLocation: String = ""
//    @objc dynamic var stateLocation: String = ""
//    @objc dynamic var conference: Int = 0
//    @objc dynamic var teamLevel: Int = 0
//    dynamic var teamPrimaryColor: RealmSwift.List<Int> = List()
//    dynamic var teamSecondaryColor: RealmSwift.List<Int> = List()
//    
//    override class func primaryKey() -> String? {
//        return  "_id"
//    }
//    
//    func getPrimaryColor() -> Color {
//        return Color(.sRGB, red: Double(teamPrimaryColor[0]),
//                     green: Double(teamPrimaryColor[1]),
//                     blue: Double(teamPrimaryColor[2]), opacity: 1)
//    }
//    
//    func getSecondaryColor() -> Color {
//        return Color(.sRGB, red: Double(teamSecondaryColor[0]),
//                     green: Double(teamSecondaryColor[1]),
//                     blue: Double(teamSecondaryColor[2]), opacity: 1)
//    }
//    
//    func getConference() -> ConferenceType {
//        return ConferenceType(rawValue: conference) ?? .MAC
//    }
//    
//    func getTeamLevel() -> TeamType {
//        return TeamType(rawValue: teamLevel) ?? TeamType.D1
//    }
//}
//
//class RealmSeason: RealmBase {
//    @objc dynamic var year: Int = 0
//    @objc dynamic var name: String = ""
//    dynamic var teams: RealmSwift.List<RealmSeasonTeam> = List()
//    dynamic var games: RealmSwift.List<RealmGame> = List()
//
//    override class func primaryKey() -> String? {
//        return  "_id"
//    }
//    
//    func getFullSeasonName() -> String {
//        return "\(name) \(year)"
//    }
//}
//
//class RealmGame: RealmBase {
//    @objc dynamic var homeTeam: RealmSeasonTeam?
//    @objc dynamic var awayTeam: RealmSeasonTeam?
//    // @objc dynamic var gameLineupInfo: RealmGameTeamLineupInfo?
//    @objc dynamic var date: Date = Date()
//    @objc dynamic var city: String = ""
//    @objc dynamic var state: String = ""
//    @objc dynamic var gameScheduleState: Int = 0
//    dynamic var historySnapshots: RealmSwift.List<RealmGameSnapshot> = List()
//    dynamic var homelineup: RealmSwift.List<RealmGameLineupMemberInfo>
//        = List()
//    dynamic var awayLineup: RealmSwift.List<RealmGameLineupMemberInfo>
//        = List()
//    
//    convenience init(inSeason season: RealmSeason) {
//        self.init()
//        // seasonID=
//        _partitionKey = "seasonID=\(season._id)"
//    }
//    
//    func getGameScheduleState() -> GameScheduleState {
//        return GameScheduleState(rawValue: gameScheduleState) ?? .Scheduled
//    }
//    
//    override class func primaryKey() -> String? {
//        return "_id"
//    }
//}
//
////class RealmGameTeamLineupInfo: RealmBase {
////    dynamic var homelineup: RealmSwift.List<RealmGameLineupMemberInfo>
////        = List()
////    dynamic var awayLineup: RealmSwift.List<RealmGameLineupMemberInfo>
////        = List()
////}
//
//class RealmGameLineup: RealmBase {
//    dynamic var homelineup: RealmSwift.List<RealmGameLineupMemberInfo>
//        = List()
//    dynamic var awayLineup: RealmSwift.List<RealmGameLineupMemberInfo>
//        = List()
//}
//
//class RealmGameLineupMemberInfo: RealmBase {
//    
//    @objc dynamic var member: RealmSeasonTeamRosterMember?
//    @objc dynamic var dh: RealmSeasonTeamRosterMember?
//    @objc dynamic var position: Int = 0
//    
//    func getPosition() -> Positions {
//        return Positions(rawValue: position) ?? .Bench
//    }
//}
//
//class RealmSeasonTeam: RealmBase {
//    @objc dynamic var numWins: Int = 0
//    @objc dynamic var numLosses: Int = 0
//    @objc dynamic var team: RealmTeam?
//    dynamic var roster: RealmSwift.List<RealmSeasonTeamRosterMember> = List()
//
//    convenience init(withSeason season: RealmSeason,
//                     withTeam team: RealmTeam) {
//        self.init()
//        // seasonID-teamID = _id
//        _id = "\(season._id)-\(team._id)"
//        // seasonID=
//        _partitionKey = "seasonID=\(season._id)"
//    }
//    
//    override class func primaryKey() -> String? {
//        return "_id"
//    }
//}
//
//class RealmSeasonTeamRosterMember: RealmBase {
//    @objc dynamic var playerClass: Int = 0
//    @objc dynamic var isRedshirt: Bool = false
//    @objc dynamic var uniformNumber: Int = 0
//    @objc dynamic var member: RealmMember?
//    
//    convenience init(withSeason season: RealmSeason,
//                     withTeam team: RealmTeam,
//                     withMember mem: RealmMember) {
//        self.init()
//        // seasonID-teamID-memberID = _id
//        _id = "\(season._id)-\(team._id)-\(mem._id)"
//        // seasonID=&teamID=
//        _partitionKey = "seasonID=\(season._id)&teamID=\(team._id)"
//        member = mem
//    }
//    
//    func getPlayerClass() -> PlayerClass {
//        return PlayerClass(rawValue: playerClass) ?? .Freshmen
//    }
//    
//    override class func primaryKey() -> String? {
//        return "_id"
//    }
//}
//
//class RealmGameSnapshot: RealmBase {
//    // Game State Information
//    @objc dynamic var currentInning: Int = 0
//    @objc dynamic var currentAtBat: Int = 0
//    @objc dynamic var currentStrikes: Int = 0
//    @objc dynamic var currentBalls: Int = 0
//    @objc dynamic var homeScore: Int = 0
//    @objc dynamic var awayScore: Int = 0
//    @objc dynamic var numberOuts: Int = 0
//    
//    // Place in home/away lineup information
//    @objc dynamic var placeInHomeLineup: Int = 0
//    @objc dynamic var placeInAwayLineup: Int = 0
//    
//    // Current pitcher/hitter information
//    @objc dynamic var currentPitcher: RealmSeasonTeamRosterMember?
//    @objc dynamic var currentHitter: RealmSeasonTeamRosterMember?
//    
//    // Event View Model Info
//    @objc dynamic var playerAtFirstAfter: RealmSeasonTeamRosterMember?
//    @objc dynamic var playerAtSecondAfter: RealmSeasonTeamRosterMember?
//    @objc dynamic var playerAtThirdAfter: RealmSeasonTeamRosterMember?
//    
//    // Base Path Events
//    dynamic var basePathEvents: RealmSwift.List<RealmBasePathEventInfo> = List()
//    
//    // List of runners who scored
//    dynamic var runnersWhoScored: RealmSwift.List<RealmSeasonTeamRosterMember> = List()
//    
//    // Pitch Info
//    @objc dynamic var pitchNumber: Int = 0
//    dynamic var pitchThrown: Int?
//    dynamic var pitchVelo: Float?
//    dynamic var pitchLocation: Int?
//    dynamic var pitchResult: Int?
//    dynamic var bipType: Int?
//    dynamic var bipOutcome: RealmSwift.List<Int>?
//    dynamic var pitcherThrowingHand: Int?
//    dynamic var hitterHittingHand: Int?
//    dynamic var hitterExitVelo: Float?
//    dynamic var ballFieldLocation: Int?
//    dynamic var pitchingStyle: Int?
//    
//    // Lineup Info
//    dynamic var homelineup: RealmSwift.List<RealmGameLineupMemberInfo>
//        = List()
//    dynamic var awayLineup: RealmSwift.List<RealmGameLineupMemberInfo>
//        = List()
//    
//    convenience init(withSeason season: RealmSeason,
//                     withGame game: RealmGame, withSnapshotNumber
//                        snapNum: Int) {
//        self.init()
//        // seasonID-gameID-snapshotNumber
//        _id = "\(season._id)-\(game._id)-\(snapNum)"
//        // seasonID=&gameID=
//        _partitionKey = "seasonID=\(season._id)&gameID=\(game._id)"
//
//    }
//    
//    func getPitchThrown() -> PitchType? {
//        guard let pitch = pitchThrown else {
//            return nil
//        }
//        return PitchType(rawValue: pitch) ?? .Fastball
//    }
//    
//    func getPitchResult() -> PitchOutcome? {
//        guard let outcome = pitchResult else {
//            return nil
//        }
//        return PitchOutcome(rawValue: outcome) ?? .IllegalPitch
//    }
//    
//    func getPitchLocation() -> PitchLocation? {
//        guard let pitchLoc = pitchLocation else {
//            return nil
//        }
//        return PitchLocation(rawValue: pitchLoc) ?? .Middle
//    }
//    
//    func getBIPType() -> BIPType? {
//        guard let bipT = bipType else {
//            return nil
//        }
//        return BIPType(rawValue: bipT) ?? .GB
//    }
//    
//    func getBIPOutcome() -> [BIPHit] {
//        var outcomes: [BIPHit] = []
//        for outcome in bipOutcome ?? List() {
//            outcomes.append(BIPHit(rawValue: outcome) ?? .Error)
//        }
//        return outcomes
//    }
//    
//    func getBallFieldLocation() -> BallFieldLocation? {
//        guard let ballFieldLoc = ballFieldLocation else {
//            return nil
//        }
//        return BallFieldLocation(rawValue: ballFieldLoc) ?? .Catcher
//    }
//    
//    func getHitterHittingHand() -> HandUsed? {
//        guard let hittingHand = hitterHittingHand else {
//            return nil
//        }
//        return HandUsed(rawValue: hittingHand) ?? .Right
//    }
//    
//    func getPitcherThrowingHand() -> HandUsed? {
//        guard let pitcherHand = pitcherThrowingHand else {
//            return nil
//        }
//        return HandUsed(rawValue: pitcherHand) ?? .Right
//    }
//    
//    func getPitchingStyle() -> PitchingStyle? {
//        guard let pitchingStyle = pitchingStyle else {
//            return nil
//        }
//        return PitchingStyle(rawValue: pitchingStyle) ?? .Stretch
//    }
//    
//    func getPlayer(whoPlaysPosition position: Positions, forTeam team: GameTeamType) -> RealmSeasonTeamRosterMember? {
//        if team == .Away {
//            for player in awayLineup {
//                if player.getPosition() == position {
//                    return player.member
//                }
//            }
//        } else {
//            for player in homelineup {
//                if player.getPosition() == position {
//                    return player.member
//                }
//            }
//        }
//        return nil
//    }
//    
//    override class func primaryKey() -> String? {
//        return "_id"
//    }
//}
//
//class RealmBasePathEventInfo: EmbeddedObject {
//    dynamic var runnerInvolved: RealmSeasonTeamRosterMember?
//    @objc dynamic var basePathEventType: Int = BasePathType.None.rawValue
//    
//    func getBasePathType() -> BasePathType {
//        return BasePathType(rawValue: basePathEventType) ?? .None
//    }
//}
