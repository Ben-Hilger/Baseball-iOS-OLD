// Copyright 2021-Present Benjamin Hilger

import Foundation

class EventViewModel : ObservableObject, Equatable {
    
    // Pitch Information
    @Published var pitchEventInfo : PitchEventInfo?
    @Published var playersInvolved : [MemberInGame] = []
    @Published var basePathInfo : [BasePathEventInfo] = []
    @Published var playerWhoCommittedError : [PlayerErrorInfo] = []
    
    @Published var isAddingPitch: Bool = false
    
    // Base Path Information
    @Published var playerAtFirstAfter: BaseState?
    @Published var playerAtSecondAfter: BaseState?
    @Published var playerAtThirdAfter: BaseState?
    
    // Game Score Information
    /// Stores the number of unearned runs the home team has scored
    @Published var homeScore = 0
    /// Stores the number of earned runs the home team has scored
    @Published var earnedHomeScore = 0
    /// Stores the number of unearned runs the away team  has scored
    @Published var awayScore = 0
    /// Stores the number of earned runs the away team has scored
    @Published var earnedAwayScore = 0
    
    /// Store the runners who scored after the given pitch
    @Published var runnersWhoScored: [Member] = []
    
    // Out Information
    @Published var numberOfOuts = 0
    
    @Published var numStrikes: Int = 0
    @Published var numBalls: Int = 0 
    
    @Published var placeInHomeLineup: Int = -1
    @Published var placeInAwayLineup: Int = -1
    
    @Published var hitterID: String = ""
    @Published var pitcherID: String = ""
    
    @Published var isEndOfAtBat: Bool = false
    
    var eventNum : Int = 1
    
    init () {}
    
    init (withEventNumber num : Int) {
        eventNum = num
    }
    
    init(withEventNumber num: Int, withPlaceInHomeLineup: Int,
         withPlaceInAwayLineup: Int) {
        eventNum = num
        placeInAwayLineup = withPlaceInAwayLineup
        placeInHomeLineup = withPlaceInHomeLineup
    }
    
    func reset() {
        //playersInvolved = []
        basePathInfo = []
        //playerWhoCommittedError = []
        pitchEventInfo = PitchEventInfo()
        eventNum += 1
        playerAtFirstAfter = nil
        playerAtSecondAfter = nil
        playerAtThirdAfter = nil
        homeScore = 0
        earnedHomeScore = 0
        awayScore = 0
        earnedAwayScore = 0
        numberOfOuts = 0
        isAddingPitch = false
        runnersWhoScored = []
        numBalls = 0
        numStrikes = 0
        pitcherID = ""
        hitterID = ""
        isEndOfAtBat = false
    }
    
    func copy() -> EventViewModel {
        let eventViewModelCopy = EventViewModel()
        eventViewModelCopy.pitchEventInfo = self.pitchEventInfo
        //eventViewModelCopy.playersInvolved = self.playersInvolved
        eventViewModelCopy.basePathInfo = self.basePathInfo
        eventViewModelCopy.eventNum = self.eventNum
        eventViewModelCopy.playerAtFirstAfter = self.playerAtFirstAfter
        eventViewModelCopy.playerAtSecondAfter = self.playerAtSecondAfter
        eventViewModelCopy.playerAtThirdAfter = self.playerAtThirdAfter
        eventViewModelCopy.homeScore = homeScore
        eventViewModelCopy.earnedHomeScore = earnedHomeScore
        eventViewModelCopy.earnedAwayScore = earnedAwayScore
        eventViewModelCopy.awayScore = awayScore
        eventViewModelCopy.numberOfOuts = numberOfOuts
        eventViewModelCopy.runnersWhoScored = runnersWhoScored
        eventViewModelCopy.isAddingPitch = isAddingPitch
        eventViewModelCopy.numBalls = numBalls
        eventViewModelCopy.numStrikes = numStrikes
        eventViewModelCopy.placeInHomeLineup = placeInHomeLineup
        eventViewModelCopy.placeInAwayLineup = placeInAwayLineup
        eventViewModelCopy.hitterID = hitterID
        eventViewModelCopy.pitcherID = pitcherID
        eventViewModelCopy.isEndOfAtBat = isEndOfAtBat
        return eventViewModelCopy
    }
    
    static func == (lhs: EventViewModel, rhs: EventViewModel) -> Bool {
        return lhs.eventNum == rhs.eventNum
    }
}

//struct RunnerOnBase : Equatable {
//    var runner : Member
//    var base : Base
//
//    static func == (lhs : RunnerOnBase, rhs : RunnerOnBase) -> Bool {
//        return lhs.runner.memberID == rhs.runner.memberID && lhs.base == rhs.base
//    }
//}

struct PitchEventInfo {
    var selectedPitchThrown : PitchType? = nil
    var selectedPitchOutcome : PitchOutcome? = nil
    var selectedBIPHit : [BIPHit] = []
    var selectedBIPType : BIPType? = nil
    var pitchLocations : PitchLocation?
    var ballLocation : BallFieldLocation? = nil
    var completedPitch : Pitch?
    var pitchVelo : Float?
    var numRBI : Int = 0
    var exitVelo : Float?
}

struct BasePathEventInfo {
    var runnerInvolved : MemberInGame
    var type : BasePathType
}

struct BasePathEventInfoBuilder {
    var runnerInvolved : String
    var type : BasePathType
}

struct PlayerErrorInfo {
    var fielderInvolved : MemberInGame
    var type : ErrorType
}

enum ErrorType : Int, CaseIterable {
    case ThrowingError = 0
    case FieldingError = 1
    
    func getString() -> String {
        switch self {
        case .ThrowingError:
            return "Throwing Error"
        case .FieldingError:
            return "Fielding Error"
        }
    }
}

enum BasePathType : Int {
    case AttemptedPickoffFirst = 0
    case PickoffOutAtFirst = 1
    case AttemptedPickoffSecond = 2
    case PickoffOutAtSecond = 3
    case AttemptedThirdPickoff = 4
    case PickoffOutAtThird = 5
    case CaughtStealingSecond = 6
    case CaughtStealingThird = 7
    case CaughtStealingHome = 8
    case StoleSecond = 9
    case StoleThird = 10
    case StoleHome = 11
    case OutonBasePath = 12
    case AdvancedSecondError = 14
    case AdvancedThirdError = 15
    case AdvancedHomeError = 16
    case AdvancedSecond = 17
    case AdvancedThird = 18
    case AdvancedHome = 19
    case Pitch = 20
    case CaughtInDouble = 21
    case CaughtInTriple = 22
    case OutInterference = 23
    case RemoveFromBase = 24
    case None = 25
    case StillOnBase = 26
}

struct EventViewModelBuilder {
    
    var eventNum : Int
//    var playersInvolved : [String : Int]
//    var errorsInvolved : [String : Int]
    var numberOfOuts: Int
    var homeScore: Int
    var homeScoreEarned: Int
    var awayScore: Int
    var awayScoreEarned: Int
    var eventTypes : [Int]
    var pitchInfo : [String : Any]
    var basePathEvent : [BasePathEventInfoBuilder]
    var playerAtFirstAfter: [String : Any]
    var playerAtSecondAfter: [String : Any]
    var playerAtThirdAfter: [String : Any]
    var runnersWhoScored : [String]
    var placeInHomeLineup: Int
    var placeInAwayLineuo: Int
    var numBalls: Int
    var numStrikes: Int
    var pitcherID: String
    var hitterID: String
    var isEndOfAtBat: Bool
    var snapshotIndex: Int
}
