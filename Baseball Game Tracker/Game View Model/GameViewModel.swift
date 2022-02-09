// Copyright 2021-Present Benjamin Hilger

import Foundation
import Firebase

class GameViewModel : ObservableObject {
    
    /// Stores information about the current game
    @Published var game : Game? = nil
    
    /// Stores information about the current inning
    @Published var currentInning : Inning? = nil
    /// Stores information about the current at bat
    @Published var currentAtBat : AtBat? = nil
    /// Stores information about the current inning number used for saving
    @Published var currentInningNum : Int = 0
    /// Stores member information about the current hitter
    @Published var currentHitter : MemberInGame? = nil
    /// Stores the current hitter index in the home lineup
    private var placeInHomeLineup : Int = -1
    /// Stores the current hitter index in the home lineup
    private var placeInAwayLineup : Int = -1
    /// Stores the information about the current at bat number used for saving
    @Published var numberAtBat : Int = -1
    /// Stores all of the game snapshots used for analytics and game state tracking
    @Published var gameSnapshots : [GameSnapshot] = []
    /// Stores the index of the most recent snapshot using
    @Published var snapShotIndex = 0
    
    /// Stores the current number of strikes for the current at bat
    // @Published var currentStrikes = 0
    /// Stores the current number of balls for the current at bat
    // @Published var currentBalls = 0
    /// Tracks the overall number of pitches thrown in a game
     // @Published var pitchNumber = 0
    /// Tracks the number of pitches each pitcher has thrown
    // @Published var pitchTracker : [String : Int] = [:]
    
    /// Stores base state information for first base
    @Published var playerAtFirst : BaseState?
    /// Stores base state information for second base
    @Published var playerAtSecond : BaseState?
    /// Stores base state information for third base
    @Published var playerAtThird : BaseState?
    
    /// Stores the number of unearned runs the home team has scored
    @Published var homeScore = 0
    /// Stores the number of earned runs the home team has scored
    @Published var earnedHomeScore = 0
    /// Stores the number of unearned runs the away team  has scored
    @Published var awayScore = 0
    /// Stores the number of earned runs the away team has scored
    @Published var earnedAwayScore = 0
    
    /// Stores the roles being performed by the iPad
    @Published var roles : [GameRole] = [.PitchLocation, .PitchOutcome]
    
    /// Stores the current editing mode of the field
    @Published var fieldEditingMode: FieldEditMode = .Normal
    /// Stores the current editing mode of runners on the bases
    @Published var runnerEditingMode : RunnerUpdate = .Normal
    
    /// Stores the lineup of the game
    @Published var lineup : Lineup
    
    @Published var summaryData : [SummaryStats] = []
    
    /// Stores if the new game snapshot will need to update the previous inning
    var updateInning : Bool = false
    /// Stores if the new game snapshot will need to update the previous at bat
    var updateAtBat : Bool = false
    /// Stores if a new at bat will be needed to be created after a game snapshot is created
    var createNewAtBat : Bool = false
    /// Stores if a new inning will need to be created after a game snapshot is created
    var createNewInning : Bool = false
    
    // Stores the current numbers of outs
    private var numberOfOuts: Int = 0
    
    // Store the number of strikes
    private var numberBalls: Int = 0
    
    // Store the number of balls
    private var numberStrikes: Int = 0
    
    // Used for PitchLocation role

    /// Stores the queue of pitch events that need to be updated
    var pitchInfoQueue : [PitchEventInfo] = []
    /// Stores the index of the next pitch info to update
    var nextPitchInfoToUpdate : Int = 0
    /// Stores the next pitch event queue
    var pitchInfoQueueIndex : Int = 0
    
    var updateOffset : Int = 1
    
    var forceSwitch : Bool = false
    
    /// Stores the current throwing arm of the current pitcher
    @Published var currentPitchingHand : HandUsed?
    /// Stores the current hitting hand of the current hitter
    @Published var currentHittingHand : HandUsed?
    /// Store the pitching style
    @Published var currentPitchingStyle: PitchingStyle = .Unknown
    
    @Published var playersWhoScored: [Member] = []
    
    @Published var isCheckingForInitialData: Bool = false
    
    var preLoaderListener: ListenerRegistration?
    
    var hasPreloadedData: Bool = false
    var numberOfPreloadedSnapshots: Int = 0
    init() {
        lineup = Lineup(withAwayMembers: [], withHomeMembers: [])
    }
    
    func setupAndBeginGame(withRoles roles : [GameRole]) {
        self.roles = roles
        setupGameForStart()
        startGame()
    }
    
    func checkAndLoadPreviousGameInformation(withLineup lineupViewModel: LineupViewModel, completion: (() -> Void)? = nil) {
        // Sets the lineup
        lineup.curentAwayTeamLineup =
            lineupViewModel.awayLineup
        lineup.currentHomeTeamLineup =
            lineupViewModel.homeLineup
        lineup.totalHomeTeamRoster =
            lineupViewModel.homeRoster
        lineup.totalAwayTeamRoster =
            lineupViewModel.awayRoster
        if let game = game {
            if game.gameScheduleState == .Finished || game.gameScheduleState == .InProgress {
                self.isCheckingForInitialData = true
                LineupSaveManagement.configureLineupUpdateReverseBuilder(forGame: game) { (builder) in
                    var awayLineup : [MemberInGame] = []
                    var homeLineup : [MemberInGame] = []
                    
                    for memberInfo in builder.awayLineupChange {
                        if let memberID = memberInfo.keys.sorted().first {
                            let position = memberInfo[memberID] ?? 0
                            let tempMember = MemberInGame(member: Member(withID: memberID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .Bench)
                            if let index = self.lineup.totalAwayTeamRoster.firstIndex(of: tempMember) {
                                var memberInGame = MemberInGame(member: self.lineup.totalAwayTeamRoster[index].member, positionInGame: Positions(rawValue: position) ?? .Bench)
                                if let dhID = builder.awayDHMap[memberID] {
                                    let tempDH = MemberInGame(member: Member(withID: dhID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .DH)
                                    if let dhIndex = self.lineup.totalAwayTeamRoster.firstIndex(of: tempDH) {
                                        memberInGame.dh = self.lineup.totalAwayTeamRoster[dhIndex].member
                                    }
                                }
                                awayLineup.append(memberInGame)
                            }
                        }
                    }
                    for memberInfo in builder.homeLineupChange {
                        if let memberID = memberInfo.keys.sorted().first {
                            let position = memberInfo[memberID] ?? 0
                            let tempMember = MemberInGame(member: Member(withID: memberID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .Bench)
                            if let index = self.lineup.totalHomeTeamRoster.firstIndex(of: tempMember) {
                                var memberInGame = MemberInGame(member: self.lineup.totalHomeTeamRoster[index].member, positionInGame: Positions(rawValue: position) ?? .Bench)
                                if let dhID = builder.homeDHMap[memberID] {
                                    let tempDH = MemberInGame(member: Member(withID: dhID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .DH)
                                    if let dhIndex = self.lineup.totalHomeTeamRoster.firstIndex(of: tempDH) {
                                        memberInGame.dh = self.lineup.totalHomeTeamRoster[dhIndex].member
                                    }
                                }
                                homeLineup.append(memberInGame)
                            }
                        }
                        
                    }
                    
                    _ = self.lineup.updateLineup(withHomeTeamLineup: homeLineup, withAwayTeamLineup: awayLineup, atCurrentPitch: builder.pitchNumberChanged)
//                    self.objectWillChange.send()
                }
                
//                // Sets up the monitor to create a new snapshot
//                preLoaderListener = GameSnapshotSaveManagement.setupGameSnapshotReverseBuilder(forGame: game) { (snapshot, eventViewModelBuilder, pitchBuilder) in
//                    if let currentAtBat = snapshot.currentAtBat, let inning = snapshot.currentInning {
//                        self.isCheckingForInitialData = true
//                        print("LOADADADAD")
//                        // Creates the event view model from the given builder
//                        let eventViewModel = self.buildEventViewModelFromBuilder(withBuilder: eventViewModelBuilder, withPitchBuilder: pitchBuilder, withHittingTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home, snapshotAtBat: currentAtBat, currentInning: inning)
//                        snapshot.eventViewModel = eventViewModel
//                        // Builds the state of the bases from the given builder
//        //                    for baseState in baseStateBuilder {
//        //                        // Gets the lineup of the current hitting team
//        //                        let lineupViewing = self.getLineup(atPitchNumber: snapshot.pitchNumber, forTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home)
//        //                        // Explores the members in the lineup
//        //                        for member in lineupViewing {
//        //                            // Checks if the member in the lineup is on the bases
//        //                            if member.member.memberID == baseState.player {
//        //                                switch baseState.base {
//        //                                // Checks if the player is on first
//        //                                case .First:
//        //                                    // Sets the player on first base
//        //                                    snapshot.playerAtFirst = BaseState(playerOnBase: member, originalAtBat: snapshot.currentAtBat!, inInning: snapshot.currentInning!)
//        //                                    break
//        //                                // Checks if the player is on second
//        //                                case .Second:
//        //                                    // Sets the player on second base
//        //                                    snapshot.playerAtSecond = BaseState(playerOnBase: member, originalAtBat: snapshot.currentAtBat!, inInning: snapshot.currentInning!)
//        //                                    break
//        //                                // Checks if the player is on third
//        //                                case .Third:
//        //                                    // Sets the player on third base
//        //                                    snapshot.playerAtThird = BaseState(playerOnBase: member, originalAtBat: snapshot.currentAtBat!, inInning: snapshot.currentInning!)
//        //                                    break
//        //                                case .Home:
//        //                                    break
//        //                                }
//        //                            }
//        //                        }
//        //                    }
//                        let lineupViewing = self.getLineup(atPitchNumber: snapshot.pitchNumber, forTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home)
//                        var hitterId : String = self.currentHitter?.member.memberID ?? ""
//                        snapshot.currentHitter = self.currentHitter
//                        if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
//                            hitterId = pitch.hitterID
//                        }
//                        for member in lineupViewing {
//                            if member.member.memberID == hitterId {
//                                snapshot.currentHitter = member
//                                break
//                            }
//                        }
//                        snapshot.lineup = self.lineup
//        //                        if snapshot.currentStrikes == 3 || snapshot.currentBalls == 4 {
//        //                            snapshot.currentStrikes = 0
//        //                            snapshot.currentBalls = 0
//        //                        }
//                        if let index = self.gameSnapshots.firstIndex(of: snapshot) {
//                            self.gameSnapshots[index] = snapshot
//                        } else {
//                            self.gameSnapshots.append(snapshot)
//                            self.snapShotIndex += 1
//                        }
//                        self.updateGameState(fromSnapshot: self.snapShotIndex-1)
//                        GameSnapshotSaveManagement.updateSnapshotWhenUpdated(snapshotToMonitor: snapshot) { (snapshot, builder, first, second, third) in
//                            self.updateSnapshot(withSnapshot: snapshot, withBuilder: builder, withPlayerAtFirst: first, withPlayerAtSecond: second, withPlayerAtThird: third)
//                        }
//                        self.isCheckingForInitialData = false
//                        // self.attemptToSaveAccessoryInformation()
//                    }
                
                GameBuilderManagement.rebuildGame(forGame: game) { (snapshot, builder, pitchInfo) in
                    if let snapshot = snapshot, let builder = builder, let currentAtBat = snapshot.currentAtBat, let inning = snapshot.currentInning {
                        self.numberOfPreloadedSnapshots += 1
                        self.hasPreloadedData = true
                        self.isCheckingForInitialData = true
                        // Creates the event view model from the given builder
                        let eventViewModel = self.buildEventViewModelFromBuilder(withBuilder: builder, withPitchBuilder: pitchInfo, withHittingTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home, snapshotAtBat: currentAtBat, currentInning: inning)
                        snapshot.eventViewModel = eventViewModel
                        let roster = inning.isTop ? self.lineup.totalAwayTeamRoster : self.lineup.totalHomeTeamRoster
                        let hitterID = snapshot.eventViewModel.hitterID
                        for member in roster {
                            if member.member.memberID == hitterID {
                                snapshot.currentHitter = member
                                break
                            }
                        }
                        snapshot.lineup = self.lineup
                        if let index = self.gameSnapshots.firstIndex(of: snapshot) {
                            self.gameSnapshots[index] = snapshot
                        } else {
                            self.gameSnapshots.append(snapshot)
                            self.snapShotIndex += 1
                        }
                        self.gameSnapshots.sort { (snapshot1, snapshot2) -> Bool in
                            return snapshot1.eventViewModel.eventNum < snapshot2.eventViewModel.eventNum
                        }
                        self.updateGameState(fromSnapshot: self.snapShotIndex-1)
                        GameSnapshotSaveManagement.updateSnapshotWhenUpdated(snapshotToMonitor: snapshot) { (snapshot, builder, first, second, third) in
                            self.updateSnapshot(withSnapshot: snapshot, withBuilder: builder, withPlayerAtFirst: first, withPlayerAtSecond: second, withPlayerAtThird: third)
                        }
                        self.isCheckingForInitialData = false
                        print("DFAFEFWEGWQF")
                        completion?()
                    }
                }
            } else {
                self.isCheckingForInitialData = false
            }
        }
    }
    
    func setupGameForStart() {
        // Sets the game
        if let g = game {
            // Sets the lineup
//            LineupSaveManagement.configureLineupUpdateReverseBuilder(forGame: g) { (builder) in
//                var awayLineup : [MemberInGame] = []
//                var homeLineup : [MemberInGame] = []
//
//                for memberInfo in builder.awayLineupChange {
//                    if let memberID = memberInfo.keys.sorted().first {
//                        let position = memberInfo[memberID] ?? 0
//                        let tempMember = MemberInGame(member: Member(withID: memberID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .Bench)
//                        if let index = self.lineup.totalAwayTeamRoster.firstIndex(of: tempMember) {
//                            var memberInGame = MemberInGame(member: self.lineup.totalAwayTeamRoster[index].member, positionInGame: Positions(rawValue: position) ?? .Bench)
//                            if let dhID = builder.awayDHMap[memberID] {
//                                let tempDH = MemberInGame(member: Member(withID: dhID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .DH)
//                                if let dhIndex = self.lineup.totalAwayTeamRoster.firstIndex(of: tempDH) {
//                                    memberInGame.dh = self.lineup.totalAwayTeamRoster[dhIndex].member
//                                }
//                            }
//                            awayLineup.append(memberInGame)
//                        }
//                    }
//                }
//                for memberInfo in builder.homeLineupChange {
//                    if let memberID = memberInfo.keys.sorted().first {
//                        let position = memberInfo[memberID] ?? 0
//                        let tempMember = MemberInGame(member: Member(withID: memberID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .Bench)
//                        if let index = self.lineup.totalHomeTeamRoster.firstIndex(of: tempMember) {
//                            var memberInGame = MemberInGame(member: self.lineup.totalHomeTeamRoster[index].member, positionInGame: Positions(rawValue: position) ?? .Bench)
//                            if let dhID = builder.homeDHMap[memberID] {
//                                let tempDH = MemberInGame(member: Member(withID: dhID, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .DH)
//                                if let dhIndex = self.lineup.totalHomeTeamRoster.firstIndex(of: tempDH) {
//                                    memberInGame.dh = self.lineup.totalHomeTeamRoster[dhIndex].member
//                                }
//                            }
//                            homeLineup.append(memberInGame)
//                        }
//                    }
//
//                }
//
//                _ = self.lineup.updateLineup(withHomeTeamLineup: homeLineup, withAwayTeamLineup: awayLineup, atCurrentPitch: builder.pitchNumberChanged)
//            }
            // Checks if the device will need to monitor for a new snapshot
//            if !roles.contains(.PitchOutcome) {
//                // Sets up the monitor to create a new snapshot
//                GameSnapshotSaveManagement.setupGameSnapshotReverseBuilder(forGame: g) { (snapshot, eventViewModelBuilder, pitchBuilder) in
//                    if let currentAtBat = snapshot.currentAtBat, let inning = snapshot.currentInning {
//                        // Creates the event view model from the given builder
//                        let eventViewModel = self.buildEventViewModelFromBuilder(withBuilder: eventViewModelBuilder, withPitchBuilder: pitchBuilder, withHittingTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home, snapshotAtBat: currentAtBat, currentInning: inning)
//                        snapshot.eventViewModel = eventViewModel
//                        // Builds the state of the bases from the given builder
//    //                    for baseState in baseStateBuilder {
//    //                        // Gets the lineup of the current hitting team
//    //                        let lineupViewing = self.getLineup(atPitchNumber: snapshot.pitchNumber, forTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home)
//    //                        // Explores the members in the lineup
//    //                        for member in lineupViewing {
//    //                            // Checks if the member in the lineup is on the bases
//    //                            if member.member.memberID == baseState.player {
//    //                                switch baseState.base {
//    //                                // Checks if the player is on first
//    //                                case .First:
//    //                                    // Sets the player on first base
//    //                                    snapshot.playerAtFirst = BaseState(playerOnBase: member, originalAtBat: snapshot.currentAtBat!, inInning: snapshot.currentInning!)
//    //                                    break
//    //                                // Checks if the player is on second
//    //                                case .Second:
//    //                                    // Sets the player on second base
//    //                                    snapshot.playerAtSecond = BaseState(playerOnBase: member, originalAtBat: snapshot.currentAtBat!, inInning: snapshot.currentInning!)
//    //                                    break
//    //                                // Checks if the player is on third
//    //                                case .Third:
//    //                                    // Sets the player on third base
//    //                                    snapshot.playerAtThird = BaseState(playerOnBase: member, originalAtBat: snapshot.currentAtBat!, inInning: snapshot.currentInning!)
//    //                                    break
//    //                                case .Home:
//    //                                    break
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//                        let lineupViewing = self.getLineup(atPitchNumber: snapshot.pitchNumber, forTeam: snapshot.currentInning?.isTop ?? false ? .Away : .Home)
//                        var hitterId : String = self.currentHitter?.member.memberID ?? ""
//                        snapshot.currentHitter = self.currentHitter
//                        if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
//                            hitterId = snapshot.eventViewModel.hitterID
//                        }
//                        for member in lineupViewing {
//                            if member.member.memberID == hitterId {
//                                snapshot.currentHitter = member
//                                break
//                            }
//                        }
//                        snapshot.lineup = self.lineup
////                        if snapshot.currentStrikes == 3 || snapshot.currentBalls == 4 {
////                            snapshot.currentStrikes = 0
////                            snapshot.currentBalls = 0
////                        }
//                        if let index = self.gameSnapshots.firstIndex(of: snapshot) {
//                            self.gameSnapshots[index] = snapshot
//                        } else {
//                            self.gameSnapshots.append(snapshot)
//                            self.snapShotIndex += 1
//                        }
//                        self.updateGameState(fromSnapshot: self.snapShotIndex-1)
//                        GameSnapshotSaveManagement.updateSnapshotWhenUpdated(snapshotToMonitor: snapshot) { (snapshot, builder, first, second, third) in
//                            self.updateSnapshot(withSnapshot: snapshot, withBuilder: builder, withPlayerAtFirst: first, withPlayerAtSecond: second, withPlayerAtThird: third)
//                        }
//                        // self.attemptToSaveAccessoryInformation()
//                    }
//
//                }
//            }
            
            // Starts the game
            //startGame()
        }
    }

    func onGameSnapshotIndexUpdate() {
        if let game = game {
            GameSnapshotSaveManagement.setupSnapshotIndexListener(forGame: game) { (index) in
                self.nextPitchInfoToUpdate = min(self.nextPitchInfoToUpdate, index)
                self.snapShotIndex = index
            }

        }
    }
    
    func addGameToSeason(forSeason season : inout Season) {
        // Checks if there is a valid game
        if let game = game {
            // Adds the game to the season
            season.games.append(game)
        }
    }

    func undo() {
        // Checks if there's anything to undo
        if snapShotIndex == 1 {
            return
        }
        // Goes back one snapshot
        snapShotIndex -= 1
        updateGameState(fromSnapshot: snapShotIndex-1)
        // Checks if you're undoing into a snapshot that has been saved
        //if gameSnapshots[snapShotIndex-1].saved {
        GameSnapshotSaveManagement.updateCurrentGameInformation(snapshotToUpdate: gameSnapshots[snapShotIndex-1], forSnapshotIndex: snapShotIndex)
        //}
        // Reloads current information to the information in the snapshot
        
    }
    
    func redo() {
        // Checks if there's anything to redo
        if canRedo() {
            snapShotIndex += 1
            updateGameState(fromSnapshot: snapShotIndex-1)
            if let currentHitter = currentHitter {
                if gameSnapshots[snapShotIndex-1].eventViewModel.isEndOfAtBat {
                    nextAtBat()
                }
            }
        }
    }
    
    func updateGameState(fromSnapshot gameSnapshotIndex : Int) {
        let gameSnapshot = gameSnapshots[gameSnapshotIndex]
        // Loads all of the necessary information from the snapshot
        self.game = gameSnapshot.game
        
        
        if self.currentHitter == gameSnapshot.currentHitter || forceSwitch
            || gameSnapshotIndex + 1 == gameSnapshots.count {
            self.currentHitter = gameSnapshot.currentHitter
            // self.currentStrikes = gameSnapshot.currentStrikes
            //self.currentBalls = gameSnapshot.currentBalls
            self.currentInning = gameSnapshot.currentInning
            self.currentAtBat = gameSnapshot.currentAtBat
            self.currentInningNum = gameSnapshot.currentInningNum
            self.numberAtBat = gameSnapshot.numberAtBat
            self.currentInning = gameSnapshot.currentInning
            forceSwitch = false
        } else {
            //self.currentBalls = 0
            // self.currentStrikes = 0
            forceSwitch = true
        }
        self.placeInHomeLineup = gameSnapshot.eventViewModel.placeInHomeLineup
        self.placeInAwayLineup = gameSnapshot.eventViewModel.placeInAwayLineup
        
        // self.pitchNumber = gameSnapshot.pitchNumber
        // self.pitchTracker = gameSnapshot.pitchTracker
        
//        self.playerAtFirst = gameSnapshot.playerAtFirst
//        self.playerAtSecond = gameSnapshot.playerAtSecond
//        self.playerAtThird = gameSnapshot.playerAtThird
        
//        self.homeScore = gameSnapshot.homeScore
//        self.earnedHomeScore = gameSnapshot.homeEarnedScore
//        self.awayScore = gameSnapshot.awayScore
//        self.earnedAwayScore = gameSnapshot.awayEarnedScore
        
        self.updateInning = gameSnapshot.newInning
        self.updateAtBat = gameSnapshot.newAtBat
        
        self.currentPitchingHand = gameSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitcherThrowingHand ?? .Switch
        self.currentHittingHand = gameSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.hitterHittingHand ?? .Switch
        
        // Set the gameSnapshot lineup to the current lineup
        gameSnapshots[gameSnapshotIndex].lineup = lineup
        
//        if let pitcherID = gameSnapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitcherID {
//            pitchTracker.updateValue(pitchTracker[pitcherID] ?? 1 - 1, forKey: pitcherID)
//        }
        
    }
    
    func canRedo() -> Bool {
        // Checks if adding by 1 will exceeded the array bounds
        return  snapShotIndex+1 <= gameSnapshots.count
    }
    
    func startGame() {
        // Checks if there's a valid game to start
        if let game = game {
            // Updates the game schedule state
            self.game?.gameScheduleState = .InProgress
            _ = GameSaveManagement.saveGameInformation(gameToSave: self.game!)
            // Checks if it's a new game
            if !hasPreloadedData {
                // Creates the first inning
                nextInning()
                nextAtBat()
                if let pitcher = getCurrentPitcher() {
                    currentPitchingHand = pitcher.member.throwingHand
                }
                let eventViewModel = EventViewModel(withEventNumber: 0, withPlaceInHomeLineup: placeInHomeLineup, withPlaceInAwayLineup: placeInAwayLineup)
                eventViewModel.hitterID = self.currentHitter?.member.memberID ?? ""
                eventViewModel.pitcherID = self.getCurrentPitcher()?.member.memberID ?? ""
                createGameSnapshot(withEventView: eventViewModel)
            } else {
                resumeAtBat()
            }
        }
    }
 
    func markGameForCompletion() {
        self.game?.gameScheduleState = .Finished
        _ = GameSaveManagement.saveGameInformation(gameToSave: self.game!)
    }
    
    func nextInning() {
        // Checks if there's a valid game
        currentInningNum += 1
        // Creates a new inning
        let newInning  = Inning(inningNum: currentInningNum, isTop: currentInningNum%2==1, atBats: [])
        currentInning = newInning
        // game.innings.append(newInning)
        self.updateInning = true
        // Resets the base
        playerAtFirst = nil
        playerAtSecond = nil
        playerAtThird = nil
    }
    
    func resumeAtBat() {
        if let snapshot = gameSnapshots.last {
            placeInHomeLineup = snapshot.eventViewModel.placeInHomeLineup
            placeInAwayLineup = snapshot.eventViewModel.placeInAwayLineup
            // Check if the player's at bat is over
            if snapshot.eventViewModel.isEndOfAtBat && snapshot.eventViewModel.numberOfOuts < 3 {
                self.currentInning = snapshot.currentInning
                nextAtBat()
            } else if snapshot.eventViewModel.isEndOfAtBat && snapshot.eventViewModel.numberOfOuts >= 3 {
                nextInning()
                nextAtBat()
            } else {
                self.currentInning = snapshot.currentInning
                currentHitter = snapshot.currentHitter
            }
        } else {
            nextInning()
            nextAtBat()
        }
    }
    
    func setCurrentHitter(team: GameTeamType) {
        if team == .Away {
            if lineup.curentAwayTeamLineup.count > 0 {
                currentHitter = lineup.curentAwayTeamLineup[placeInAwayLineup].dh == nil ?
                    lineup.curentAwayTeamLineup[placeInAwayLineup] :
                    MemberInGame(member: lineup.curentAwayTeamLineup[placeInAwayLineup].dh!, positionInGame: .DH)
            }
        } else {
            if lineup.currentHomeTeamLineup.count > 0 {
                currentHitter = lineup.currentHomeTeamLineup[placeInHomeLineup].dh == nil ?
                    lineup.currentHomeTeamLineup[placeInHomeLineup] :
                    MemberInGame(member: lineup.currentHomeTeamLineup[placeInHomeLineup].dh!, positionInGame: .DH)
            }
        }
    }
    
    func advanceToRelativeBatter(team: GameTeamType, isAdvancingInLineup ad: Bool) {
        if team == .Away {
            // Increments the away lineup
            placeInAwayLineup += ad ? 1 : -1
            
            // Hitting = Away, Field = Home
            // Sets the hitter
            if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
                placeInAwayLineup = 0
            }
            if placeInAwayLineup < 0 {
                placeInAwayLineup = lineup.curentAwayTeamLineup.count - 1
            }
            
            while (lineup.curentAwayTeamLineup.count > 0 &&
                    lineup.curentAwayTeamLineup[placeInAwayLineup].positionInGame == .DH) {
                placeInAwayLineup += ad ? 1 : -1

                if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
                    placeInAwayLineup = 0
                }
                if placeInAwayLineup < 0 {
                    placeInAwayLineup = lineup.curentAwayTeamLineup.count - 1
                }
            }

            if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
                placeInAwayLineup = 0
            }
        } else {
            // Increments the away lineup
            placeInHomeLineup += ad ? 1 : -1
            // Hitting = Home, Field = Away
            // Sets the hitter
            if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
                placeInHomeLineup = 0
            }
            if placeInHomeLineup < 0 {
                placeInHomeLineup = lineup.currentHomeTeamLineup.count - 1
            }
            
            while (lineup.currentHomeTeamLineup.count > 0 &&
                    lineup.currentHomeTeamLineup[placeInHomeLineup].positionInGame == .DH) {
                placeInHomeLineup += ad ? 1 : -1
                
                if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
                    placeInHomeLineup = 0
                }
                if placeInHomeLineup < 0 {
                    placeInHomeLineup = lineup.currentHomeTeamLineup.count - 1
                }
            }
        
            if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
                placeInHomeLineup = 0
            }
        }
    }
    
    func nextAtBat() {
        // Checks if there's a valid game and inning
        if let game = game, var inning = currentInning {
            // Increments the away lineup
            // Resets the ball and strike counter
            // currentStrikes = 0
            // currentBalls = 0
            // Gets the pitcher and hitter
            if inning.isTop {
//                // Increments the away lineup
//                placeInAwayLineup += 1
//
//                // Hitting = Away, Field = Home
//                // Sets the hitter
//                if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
//                    placeInAwayLineup = 0
//                }
//
//                while (lineup.curentAwayTeamLineup.count > 0 &&
//                        lineup.curentAwayTeamLineup[placeInAwayLineup].positionInGame == .DH) {
//                    placeInAwayLineup += 1
//
//                    if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
//                        placeInAwayLineup = 0
//                    }
//                }
//
//                if lineup.curentAwayTeamLineup.count > 0 {
//                    currentHitter = lineup.curentAwayTeamLineup[placeInAwayLineup].dh == nil ?
//                        lineup.curentAwayTeamLineup[placeInAwayLineup] :
//                        MemberInGame(member: lineup.curentAwayTeamLineup[placeInAwayLineup].dh!, positionInGame: .DH)
//                }
//
//                if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
//                    placeInAwayLineup = 0
//                }
                advanceToRelativeBatter(team: .Away, isAdvancingInLineup: true)
                setCurrentHitter(team: .Away)
            } else {
                advanceToRelativeBatter(team: .Home, isAdvancingInLineup: true)
                setCurrentHitter(team: .Home)
//                // Increments the away lineup
//                placeInHomeLineup += 1
//                // Hitting = Home, Field = Away
//                // Sets the hitter
//                if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
//                    placeInHomeLineup = 0
//                }
//
//                while (lineup.currentHomeTeamLineup.count > 0 &&
//                        lineup.currentHomeTeamLineup[placeInHomeLineup].positionInGame == .DH) {
//                    placeInHomeLineup += 1
//
//                    if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
//                        placeInHomeLineup = 0
//                    }
//                }
//
//                currentHitter = lineup.currentHomeTeamLineup[placeInHomeLineup].dh == nil ?
//                    lineup.currentHomeTeamLineup[placeInHomeLineup] :
//                    MemberInGame(member: lineup.currentHomeTeamLineup[placeInHomeLineup].dh!, positionInGame: .DH)
//
//                if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
//                    placeInHomeLineup = 0
//                }
            }
            if let pitcher = getCurrentPitcher(), let hitter = currentHitter {
                currentHittingHand = hitter.member.hittingHand
                numberAtBat += 1
                let newAtBat = AtBat(atBatID: "\(numberAtBat)", pitcherID: [pitcher.member.memberID], hitterID: [hitter.member.memberID], numberInInning: numberAtBat)
                inning.atBats.append(newAtBat)
                currentAtBat = newAtBat
                self.updateAtBat = true
                
            }
        }
    }
    
    func createGameSnapshot(withEventView view : EventViewModel) {
        if let game = game {
            // Creates a snapshot
            if roles.contains(.PitchOutcome) {
                let gameSnapshot = GameSnapshot(withGame: game,
                                                withCurrentInning: currentInning,
                                                withCurrentAtBat: currentAtBat,
                                                withCurrentInningNum: currentInningNum,
                                                withCurrentHitter: currentHitter,
                                                withAtBatNumber: numberAtBat,
                                                withPitchNumber: getNumberOfPitches(),
                                                withEventViewModel: view.copy(),
                                                createNewInningAtSave: updateInning,
                                                createNewAtBatAtSave: updateAtBat,
                                                withLineup: lineup,
                                                withSnapshotIndex: snapShotIndex)
                updateInning = false
                updateAtBat = false
                // Adds the snapshot to the list
                if gameSnapshots.count == 0 || snapShotIndex == gameSnapshots.count {
                    gameSnapshots.append(gameSnapshot)
                } else {
                    gameSnapshots[snapShotIndex] = gameSnapshot
                    gameSnapshots = gameSnapshots[0...snapShotIndex].reversed().reversed()
                }
                // Increments the snapshot index to reflect the changes
                snapShotIndex += 1
                saveNextGameSnapshot()
            }
        }
    }
    
    func addEvent(eventViewModel : EventViewModel) {
        // Store the previous score
        var prevScore = getCurrentGameScore(forTeam: currentInning?.isTop ?? false ? .Away : .Home)
        playerAtFirst = getPlayerOnBase(base: .First)
        playerAtSecond = getPlayerOnBase(base: .Second)
        playerAtThird = getPlayerOnBase(base: .Third)
        numberStrikes = getCurrentStrikes()
        numberBalls = getCurrentBalls()
        numberOfOuts = getCurrentNumberOfOuts()
        awayScore = getCurrentTeamScoreUnearned(forTeam: .Away)
        homeScore = getCurrentTeamScoreUnearned(forTeam: .Home)
        earnedAwayScore = getCurrentTeamScoreEarned(forTeam: .Away)
        earnedHomeScore = getCurrentTeamScoreEarned(forTeam: .Home)
        playersWhoScored = []
        if roles.contains(.PitchOutcome) {
            var stolenBase : Bool = false
            if let inning = currentInning {
                for event in eventViewModel.basePathInfo {
                    switch event.type {
                    case .PickoffOutAtFirst:
                        addOutToInning(NumberOfOuts: 1)
                        playerAtFirst = nil
                        break
                    case .PickoffOutAtSecond:
                        addOutToInning(NumberOfOuts: 1)
                        playerAtSecond = nil
                        break
                    case .PickoffOutAtThird:
                        addOutToInning(NumberOfOuts: 1)
                        playerAtThird = nil
                        break
                    case .AttemptedPickoffFirst:
                        break
                    case .AttemptedPickoffSecond:
                        break
                    case .AttemptedThirdPickoff:
                        break
                    case .CaughtStealingHome:
                        stolenBase = true
                        addOutToInning(NumberOfOuts: 1)
                        playerAtThird = nil
                        break
                    case .CaughtStealingThird:
                        stolenBase = true
                        addOutToInning(NumberOfOuts: 1)
                        playerAtSecond = nil
                        break
                    case .CaughtStealingSecond:
                        stolenBase = true
                        addOutToInning(NumberOfOuts: 1)
                        playerAtFirst = nil
                        break
                    case .StoleHome:
                        stolenBase = true
                        if let runner = getPlayerOnBase(base: .Third) {
                            movePlayer(toBase: .Home, forPlayer: runner.playerOnBase)
                        }
                        break
                    case .StoleSecond:
                        stolenBase = true
                        if let runner = getPlayerOnBase(base: .First) {
                            movePlayer(toBase: .Second, forPlayer: runner.playerOnBase)
                            }
                        break
                    case .StoleThird:
                        stolenBase = true
                        if let runner = getPlayerOnBase(base: .Second) {
                            movePlayer(toBase: .Third, forPlayer: runner.playerOnBase)
                        }
                        break
                    case .OutonBasePath:
                        _ = removePlayerFromBase(playerToRemove: event.runnerInvolved)
                        addOutToInning(NumberOfOuts: 1)
                        break
                    case .AdvancedSecondError, .AdvancedSecond:
                        movePlayer(toBase: .Second, forPlayer: event.runnerInvolved)
                        break
                    case .AdvancedThirdError, .AdvancedThird:
                        movePlayer(toBase: .Third, forPlayer: event.runnerInvolved)
                        break
                    case .AdvancedHomeError, .AdvancedHome:
                        movePlayer(toBase: .Home,  forPlayer: event.runnerInvolved)
                        break
                    case .CaughtInDouble, .CaughtInTriple:
                        _ = removePlayerFromBase(playerToRemove: event.runnerInvolved)
                        break
                    case .OutInterference:
                        _ = removePlayerFromBase(playerToRemove: event.runnerInvolved)
                        addOutToInning(NumberOfOuts: 1)
                        break
                    case .None, .Pitch, .StillOnBase:
                        break
                    case .RemoveFromBase:
                        // Remove the player from base
                        _ = removePlayerFromBase(playerToRemove: event.runnerInvolved)
                        break
                    }
                }
                let numRBIs = (inning.isTop ? awayScore + earnedAwayScore :
                                homeScore + earnedHomeScore) - prevScore
                //currentAtBat?.numRBIs += numRBIs
                eventViewModel.pitchEventInfo?.numRBI = numRBIs
                
                // Check if the third out is determined by basepath events
                if (numberOfOuts == 3) {
                    if (currentInning?.isTop ?? false) {
                        // Revert one batter to preserve the order
                        placeInAwayLineup -= 1
                    } else {
                        // Revert one batter to preserve the order
                        placeInHomeLineup -= 1
                    }
                }
                
                // Adds a pitch event if necessary
                if let pitchInfo = eventViewModel.pitchEventInfo, eventViewModel.isAddingPitch {
                    if pitchInfo.selectedPitchOutcome != .IntentionalBall &&
                        pitchInfo.selectedPitchOutcome != .Balk {
                        let pitch = addPitch(type: pitchInfo.selectedPitchThrown, result: pitchInfo.selectedPitchOutcome, bipType: pitchInfo.selectedBIPType, bipHits: pitchInfo.selectedBIPHit, pitchlocations: pitchInfo.pitchLocations, pitchVelo: pitchInfo.pitchVelo, ballFieldLocation: pitchInfo.ballLocation)
                        eventViewModel.pitchEventInfo?.completedPitch = pitch
                        // Checks if the player hit a HR
                        if pitch?.bipHit.contains(.HR) ?? false || pitch?.bipHit.contains(.HRInPark) ?? false {
                            // Adds one to the score so they aren't counted as an RBI
                            prevScore += 1
                        }
                    } else if let currentHitter = currentHitter,
                              pitchInfo.selectedPitchOutcome == .IntentionalBall {
                        movePlayer(toBase: .First, forPlayer: currentHitter)
                        createNewAtBat = true
                    } else if pitchInfo.selectedPitchOutcome == .Balk {
                        // Balk, no pitch and runners advance
                        advanceRunners()
                    }
                }
            }
            
            eventViewModel.playerAtFirstAfter = playerAtFirst
            eventViewModel.playerAtSecondAfter = playerAtSecond
            eventViewModel.playerAtThirdAfter = playerAtThird
            eventViewModel.awayScore = awayScore
            eventViewModel.earnedAwayScore = earnedAwayScore
            eventViewModel.homeScore = homeScore
            eventViewModel.earnedHomeScore = earnedHomeScore
            eventViewModel.runnersWhoScored = playersWhoScored
            eventViewModel.numberOfOuts = numberOfOuts
            eventViewModel.numStrikes = numberStrikes
            eventViewModel.numBalls = numberBalls
            eventViewModel.placeInAwayLineup = placeInAwayLineup
            eventViewModel.placeInHomeLineup = placeInHomeLineup
            eventViewModel.pitcherID = getCurrentPitcher()?.member.memberID ?? ""
            eventViewModel.hitterID = currentHitter?.member.memberID ?? ""
            eventViewModel.isEndOfAtBat = createNewAtBat || createNewInning
            // Explores the different base path events
            
            if !(eventViewModel.basePathInfo.count == 1 && (eventViewModel.basePathInfo[0].type == .None)) {
//                if stolenBase {
//                    if addNewBasePathInfoToPreviousEvent(newInfo: eventViewModel,
//                                                         updatedFirst: playerAtFirst,
//                                                         updatedSecond: playerAtSecond,
//                                                         updatedThird: playerAtThird,
//                                                         updatedAwayScore: awayScore,
//                                                         updatedAwayEarnedScore: earnedAwayScore,
//                                                         updatedHomeScore: homeScore,
//                                                         updatedHomeEarnedScore: earnedHomeScore) {
//                        return
//                    }
//                }
                // Checks if a new inning needs to be created
                if createNewInning {
                    // Gets the number of players left on base
                    let LOB = (playerAtFirst == nil ? 0 : 1) + (playerAtSecond == nil ? 0 : 1) + (playerAtThird == nil ? 0 : 1)
                    // Checks to make sure there is a valid inning
                    if currentInning != nil {
                        // Sets the innings LOB count
                        // currentInning!.LOB = LOB
                        // Updates the database
                        //FirestoreManager.updateInning(currentGame: game, inningToUpdate: currentInning!)
                    }
                }
                // Creates a game snapshot
                createGameSnapshot(withEventView: eventViewModel)
                if createNewInning && createNewAtBat {
                    createNewAtBat = false
                }
                if createNewInning {
                    // Go to the next inning
                    nextInning()
                    // Go to the next at bat
                    nextAtBat()
                    // Reset the pitching style
                    self.currentPitchingStyle = .Unknown
                    createNewInning = false
                } else if createNewAtBat {
                    nextAtBat()
                    createNewAtBat = false
                    // Reset the pitching style
                    self.currentPitchingStyle = .Unknown
                }
            }
        } else if roles.contains(.PitchLocation) {
            if let pitchEventInfo = eventViewModel.pitchEventInfo {
                pitchInfoQueue.append(pitchEventInfo)
            }
        }
   
    }
    
    func getBasesWithRunners() -> [MemberInGame] {
        var runners : [MemberInGame] = []
        if let first = getPlayerOnBase(base: .First) {
            runners.append(first.playerOnBase)
        }
        if let second = getPlayerOnBase(base: .Second) {
            runners.append(second.playerOnBase)
        }
        if let third = getPlayerOnBase(base: .Third) {
            runners.append(third.playerOnBase)
        }
        return runners
    }
    
    func addPitch(type : PitchType?,
                  result : PitchOutcome?,
                  bipType : BIPType?,
                  bipHits : [BIPHit]=[],
                  pitchlocations : PitchLocation?,
                  pitchVelo : Float?,
                  ballFieldLocation: BallFieldLocation?) -> Pitch? {
        // Store the player base information
        if let _ = game, let _ = currentInning, var _ = currentAtBat {
            if let result = result, roles.contains(.PitchOutcome) {
                if result == .StrikeCalled || result == .StrikeSwingMiss || result == .StrikeForce || result == .WildPitchStrikeSwinging || result == .PassedBallStrikeSwinging || result == .PitchOutSwinging || result == .PitchOutLooking || result == .WildPitchStrikeLooking {
                    numberStrikes += 1
                    if numberStrikes == 3 {
                        addOutToInning(NumberOfOuts: 1)
                        createNewAtBat = true
                    }
                } else if result == .Ball || result == .BallWildPitch || result == .BallPassedBall || result == .IntentionalBall || result == .BallForce || result == .PitchOutBall || result == .IllegalPitch {
                    numberBalls += 1
                    if numberBalls == 4 {
                        if let hitter = currentHitter {
                            movePlayer(toBase: .First, forPlayer: hitter)
                            createNewAtBat = true
                        }
                    }
                } else if result == .CatcherInter || result == .HBP {
                    if let hitter = currentHitter {
                        movePlayer(toBase: .First, forPlayer: hitter)
                        createNewAtBat = true
                    }
                    
                } else if result == .FoulBall || result == .FoulBallDropped {
                    if numberStrikes < 2 {
                        numberStrikes += 1
                    }
                } else if result == .BatterInter {
                    addOutToInning(NumberOfOuts: 1)
                    createNewAtBat = true
                // Check if the player was out on a dropped third strike
                } else if result == .DroppedThirdLookingOut || result == .DroppedThirdSwingingOut {
                    addOutToInning(NumberOfOuts: 1)
                    numberStrikes += 1
                    createNewAtBat = true
                // Check if the player was safe on a dropped third strike
                } else if result == .DroppedThirdLookingSafe || result == .DroppedThirdSwingingSafe ||
                            result == .DroppedThirdLookingSafePassedBall || result == .DroppedThirdSwingingSafePassedBall {
                    numberStrikes += 1
                    if let hitter = currentHitter {
                        movePlayer(toBase: .First, forPlayer: hitter)
                    }
                // Check if the player had a BIP event
                } else if result == .BIP {
                    if let hitter = currentHitter {
                        if bipHits.contains(.OutAtFirst) || bipHits.contains(.FoulBallCaught) ||
                                    bipHits.contains(.CaughtAdvancingHome) || bipHits.contains(.CaughtAdvancingToThird) || bipHits.contains(.CaughtAdvancingToSecond) || bipHits.contains(.SacFly) || bipHits.contains(.SacBunt) || bipHits.contains(.ForceOut) {
                            addOutToInning(NumberOfOuts: 1)
                            createNewAtBat = true
                        } else if bipHits.contains(.HR) || bipHits.contains(.HRInPark) {
                            clearTheBases()
                            movePlayer(toBase: .Home, forPlayer: hitter)
                            createNewAtBat = true
                        } else if bipHits.contains(.AdvancedHomeError) {
                            movePlayer(toBase: .Home, forPlayer: hitter)
                        }else if bipHits.contains(.ThirdB) || bipHits.contains(.AdvancedToThirdError) {
                            movePlayer(toBase: .Third, forPlayer: hitter)
                            createNewAtBat = true
                        } else if bipHits.contains(.SecondB) || bipHits.contains(.AdvancedToSecondError) {
                            movePlayer(toBase: .Second, forPlayer: hitter)
                            createNewAtBat = true
                        } else if bipHits.contains(.FirstB) || bipHits.contains(.Error) || bipHits.contains(.SacFlyError) || bipHits.contains(.SacBuntError) || bipHits.contains(.FielderChoice) || bipHits.contains(.FielderChoiceOut) {
                            movePlayer(toBase: .First, forPlayer: hitter)
                            createNewAtBat = true
                        } else if bipHits.contains(.SecondB) || bipHits.contains(.SecondBGroundRule) {
                            movePlayer(toBase: .Second, forPlayer: hitter)
                            createNewAtBat = true
                        } else if bipHits.contains(.ThirdB) {
                            movePlayer(toBase: .Third, forPlayer: hitter)
                            createNewAtBat = true
                        } else if bipHits.contains(.DoublePlay) {
                            addOutToInning(NumberOfOuts: 2)
                            createNewAtBat = true
                        } else if bipHits.contains(.TriplePlay) {
                            addOutToInning(NumberOfOuts: 3)
                            createNewAtBat = true
                        }
                        // Checks if the hit is valid
                        if (bipHits.contains(.FirstB) || bipHits.contains(.SecondB) || bipHits.contains(.ThirdB) || bipHits.contains(.HR) || bipHits.contains(.HRInPark)) && !bipHits.contains(.AdvancedHomeError) && !bipHits.contains(.AdvancedToThirdError) && !bipHits.contains(.AdvancedToSecondError) {
                            // Adds a hit to the total
                            //currentInning?.numberOfHits += 1
                        }
                    }
                }
            }
            if let pitcher = getCurrentPitcher(), let hitter = currentHitter {
                let pitch = Pitch(pitchNumber: getNumberOfPitches(), pitchType: type, pitchVelo: pitchVelo ?? 0, pitchLocation: pitchlocations, pitchResult: result, bipType: bipType, bipHit: bipHits, pitcherThrowingHand: currentPitchingHand ?? .Right, hitterHittingHand: currentHittingHand ?? .Right, ballFieldLocation: ballFieldLocation, pitchingStyle: currentPitchingStyle)
                if !(currentAtBat?.hitterID.contains(hitter.member.memberID) ?? false) {
                    currentAtBat?.hitterID.append(hitter.member.memberID)
                }
                if !(currentAtBat?.pitcherID.contains(pitcher.member.memberID) ?? false) {
                    currentAtBat?.pitcherID.append(pitcher.member.memberID)
                }
                return pitch
            }
        }
        return nil
    }
    
    func clearTheBases() {
        // Moves the player at third to home if necessary
        if let first = playerAtThird {
            movePlayer(toBase: .Home, forPlayer: first.playerOnBase)
        }
        // Moves the player at second to home if necessary
        if let second = playerAtSecond {
            movePlayer(toBase: .Home, forPlayer: second.playerOnBase)
        }
        // Moves the player at first to home if necessary
        if let third = playerAtFirst {
            movePlayer(toBase: .Home, forPlayer: third.playerOnBase)
        }
    }
    
    func resetTheBases() {
        // Clears the bases without moving players
        playerAtFirst = nil
        playerAtSecond = nil
        playerAtThird = nil
    }
    
    func advanceRunners() {
        
        // Move the player at third to home if necessary
        if let third = playerAtThird {
            movePlayer(toBase: .Home, forPlayer: third.playerOnBase)
        }
        // Move the player at second to third if necessary
        if let second = playerAtSecond {
            movePlayer(toBase: .Third, forPlayer: second.playerOnBase)
        }
        // Move the player at first to second if necessary
        if let first = playerAtFirst {
            movePlayer(toBase: .Second, forPlayer: first.playerOnBase)
        }
    }
    
    func addScoreToHittingTeam(NumberOfPoints points : Int,
                               forPlayer player: MemberInGame,
                               playerOriginalAtBat atBat: AtBat) {
        // Checks if there's a valid inning
        if let currentInning = currentInning {
            // Adds the points to the current inning
            //self.currentInning?.numberOfRuns += points
            // Checks if the away or home team is hitting
            if currentInning.isTop {
                // Checks if the runs are earned
                if EarnedRunAnalysis().determineIfRunnerHasEarnedRun(
                    snapshots: gameSnapshots,
                    inningToAnalyze: currentInning,
                    atBatToAnalyze: atBat,
                    runner: player) {
                    self.earnedAwayScore += points
                } else {
                    self.awayScore += points
                }
            } else {
                // Checks if the runs are earned
                if EarnedRunAnalysis().determineIfRunnerHasEarnedRun(
                    snapshots: gameSnapshots,
                    inningToAnalyze: currentInning,
                    atBatToAnalyze: atBat,
                    runner: player) {
                    self.earnedHomeScore += points
                } else {
                    self.homeScore += points
                }
            }
            playersWhoScored.append(player.member)
        }
    }
    
    func addOutToInning(NumberOfOuts numOuts : Int) {
        if currentInning != nil {
            // Adds an out to the inning
            numberOfOuts += numOuts
            // Checks if there's three outs
            if numberOfOuts >= 3 {
                // Creates a new Inning
                createNewInning = true
            }
        }
    }
        
    func submitLineupChange(forLineupViewModel lineupViewModel : LineupViewModel) {
        if let inning = currentInning, let game = game {
            let change = lineup.updateLineup(withHomeTeamLineup: lineupViewModel.homeLineup, withAwayTeamLineup: lineupViewModel.awayLineup, atCurrentPitch: getNumberOfPitches() - 1)
            LineupSaveManagement.saveLineupChange(gameToSave: game, changeToSubmit: change)
            lineup.totalHomeTeamRoster = lineupViewModel.homeRoster
            lineup.totalAwayTeamRoster = lineupViewModel.awayRoster
            // Checks if the hitter has changed
            if let hitter = lineupViewModel.currentHitter, hitter != currentHitter {
                currentHitter = hitter
                currentHittingHand = hitter.member.hittingHand
            } else {
                // Automatically changes the hitter in case the order changed
                if inning.isTop {
                    if placeInAwayLineup >= lineup.curentAwayTeamLineup.count {
                        placeInAwayLineup = 0
                    }
                    //currentHitter = game.lineup.curentAwayTeamLineup[min(placeInAwayLineup, game.lineup.curentAwayTeamLineup.count-1)]
                    let newPlaceInAwayLineup = min(placeInAwayLineup, lineup.curentAwayTeamLineup.count-1)
                    currentHitter = lineup.curentAwayTeamLineup[newPlaceInAwayLineup].dh == nil ?
                        lineup.curentAwayTeamLineup[newPlaceInAwayLineup] :
                        MemberInGame(member: lineup.curentAwayTeamLineup[newPlaceInAwayLineup].dh!, positionInGame: .DH)
                    placeInAwayLineup = newPlaceInAwayLineup
                } else {
                    if placeInHomeLineup >= lineup.currentHomeTeamLineup.count {
                        placeInHomeLineup = 0
                    }
                    //currentHitter = game.lineup.currentHomeTeamLineup[min(placeInHomeLineup, game.lineup.currentHomeTeamLineup.count-1)]
                    let newPlaceInHomeLineup = min(placeInHomeLineup, lineup.currentHomeTeamLineup.count-1)
                    currentHitter = lineup.currentHomeTeamLineup[newPlaceInHomeLineup].dh == nil ?
                        lineup.currentHomeTeamLineup[newPlaceInHomeLineup] :
                        MemberInGame(member: lineup.currentHomeTeamLineup[newPlaceInHomeLineup].dh!, positionInGame: .DH)
                    placeInHomeLineup = min(placeInHomeLineup, lineup.currentHomeTeamLineup.count-1)
                }
            }
            // Checks if the current pitcher has changed
            if getCurrentPitcher() != lineupViewModel.getCurrentPitcher(editingAwayLineup: !inning.isTop) {
                let newPitcher = lineupViewModel.getCurrentPitcher(editingAwayLineup: !inning.isTop)?.member
                currentPitchingHand = newPitcher?.throwingHand
            }
        }
    }
    
    func getHomeTeamName() -> String {
        if let game = game {
            return game.homeTeam.teamName
        }
        return ""
    }
    
    func getAwayTeamName() -> String {
        if let game = game {
            return game.awayTeam.teamName
        }
        return ""
    }
    
    func getCurrentPitcher() -> MemberInGame? {
        if let inning = currentInning, let game = game {
            return lineup.getPlayer(forTeam: inning.isTop ? .Home : .Away, atPosition: .Pitcher)
          //  return inning.isTop ? game.lineup.getHomePlayer(atPosition: .Pitcher) : game.lineup.getAwayPlayer(atPosition: .Pitcher)
        }
        return nil
    }
    
    func getCurrentHitter() -> MemberInGame? {
        return currentHitter
    }
    
    func movePlayer(toBase base : Base, forPlayer player : MemberInGame) {
        let info = removePlayerFromBase(playerToRemove: player)
        switch base {
        case .First:
            if let playerAtFirst = playerAtFirst {
                movePlayer(toBase: .Second, forPlayer: playerAtFirst.playerOnBase)
            }
            if info.count == 3 {
                playerAtFirst = BaseState(playerOnBase: player, originalAtBat: info[1] as! AtBat, inInning: info[0] as! Inning, pinchRunner: info[2] as? MemberInGame)
            } else {
                playerAtFirst = BaseState(playerOnBase: player, originalAtBat: info[1] as! AtBat, inInning: info[0] as! Inning)
            }
            return
        case .Second:
            if let playerAtFirst = playerAtSecond {
                movePlayer(toBase: .Third, forPlayer: playerAtFirst.playerOnBase)
            }
            if info.count == 3 {
                playerAtSecond = BaseState(playerOnBase: player, originalAtBat: info[1] as! AtBat, inInning: info[0] as! Inning, pinchRunner: info[2] as? MemberInGame)
            } else {
                playerAtSecond = BaseState(playerOnBase: player, originalAtBat: info[1] as! AtBat, inInning: info[0] as! Inning)
            }
            return
        case .Third:
            if let playerAtFirst = playerAtThird {
                movePlayer(toBase: .Home, forPlayer: playerAtFirst.playerOnBase)
            }
            if info.count == 3 {
                playerAtThird = BaseState(playerOnBase: player, originalAtBat: info[1] as! AtBat, inInning: info[0] as! Inning, pinchRunner: info[2] as? MemberInGame)
            } else {
                playerAtThird = BaseState(playerOnBase: player, originalAtBat: info[1] as! AtBat, inInning: info[0] as! Inning)
            }
            return
        case .Home:
            addScoreToHittingTeam(NumberOfPoints: 1, forPlayer: player, playerOriginalAtBat: info[1] as! AtBat)
            return
        }
    }
    
    func removePlayerFromBase(playerToRemove player : MemberInGame) -> [Any] {
        var info: [Any] = []
        if playerAtFirst?.playerOnBase == player {
            info.append(playerAtFirst!.inInning)
            info.append(playerAtFirst!.originalAtBat)
            info.append(playerAtFirst!.pinchRunner as Any)
            playerAtFirst = nil
        } else if playerAtSecond?.playerOnBase == player {
            info.append(playerAtSecond!.inInning)
            info.append(playerAtSecond!.originalAtBat)
            info.append(playerAtSecond!.pinchRunner as Any)
            playerAtSecond = nil
        } else if playerAtThird?.playerOnBase == player {
            info.append(playerAtThird!.inInning)
            info.append(playerAtThird!.originalAtBat)
            info.append(playerAtThird!.pinchRunner as Any)
            playerAtThird = nil
        } else {
            info.append(currentInning!)
            info.append(currentAtBat!)
        }
        return info
    }
    
    func findPlayerOnBase(forPlayer player : MemberInGame) -> MemberInGame? {
        if let first = playerAtFirst, player.member == first.playerOnBase.member {
            return first.playerOnBase
        } else if let second = playerAtSecond, player.member == second.playerOnBase.member {
            return second.playerOnBase
        } else if let third = playerAtThird, player.member == third.playerOnBase.member  {
            return third.playerOnBase
        }
        return nil
    }
    
    func playerHasToMove(baseToCheck base : Base) -> Bool {
        switch base {
        case .First:
            return true
        case .Second:
            return playerAtFirst != nil
        case .Third:
            return playerAtFirst != nil && playerAtSecond != nil
        case .Home:
            return false
        }
    }
    
    func addNewBasePathInfoToPreviousEvent(newInfo : EventViewModel,
                                           updatedFirst first: BaseState?,
                                           updatedSecond second: BaseState?,
                                           updatedThird third: BaseState?,
                                           updatedAwayScore awayScore: Int,
                                           updatedAwayEarnedScore awayEarnedScore: Int,
                                           updatedHomeScore homeScore: Int,
                                           updatedHomeEarnedScore homeEarnedScore: Int) -> Bool {
        if snapShotIndex-1 >= 0 {
            for event in newInfo.basePathInfo {
                gameSnapshots[snapShotIndex-1].eventViewModel.basePathInfo.append(event)
            }
            gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter = first
            gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter = second
            gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter = third
            gameSnapshots[snapShotIndex-1].eventViewModel.awayScore = awayScore
            gameSnapshots[snapShotIndex-1].eventViewModel.earnedAwayScore = awayEarnedScore
            gameSnapshots[snapShotIndex-1].eventViewModel.homeScore = homeScore
            gameSnapshots[snapShotIndex-1].eventViewModel.earnedHomeScore = homeEarnedScore
            return true
        }
        return false
    }
    
    func placePinchRunner(onBase base : Base, withPinchRunner pinchRunner : MemberInGame) {
        // Check which base the pinch runner should be placed o
        switch base {
        case .First:
            // Check if there was a previous base state
            if snapShotIndex >= 1 {
                if gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter?.playerOnBase != nil {
                    gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter?.pinchRunner = pinchRunner
                } else {
                    gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter = BaseState(playerOnBase: pinchRunner, originalAtBat: gameSnapshots[snapShotIndex-1].currentAtBat!, inInning: gameSnapshots[snapShotIndex-1].currentInning!)
                }
            }
            break
        case .Second:
            // Check if there was a previous base state
            if snapShotIndex >= 1 {
                if gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter?.playerOnBase != nil {
                    gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter?.pinchRunner = pinchRunner
                } else {
                    gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter = BaseState(playerOnBase: pinchRunner, originalAtBat: gameSnapshots[snapShotIndex-1].currentAtBat!, inInning: gameSnapshots[snapShotIndex-1].currentInning!)
                }
            }
            break
        case .Third:
            // Check if there was a previous base state
            if snapShotIndex >= 1 {
                if gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter?.playerOnBase != nil {
                    gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter?.pinchRunner = pinchRunner
                } else {
                    gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter = BaseState(playerOnBase: pinchRunner, originalAtBat: gameSnapshots[snapShotIndex-1].currentAtBat!, inInning: gameSnapshots[snapShotIndex-1].currentInning!)
                }
            }
            break
        case .Home:
            break
        }
    }
    
    func attemptToSaveAccessoryInformation() {
        // Attempts to find the next accessory to save
        while(nextPitchInfoToUpdate < snapShotIndex) {
            // Checks if the current snapshot has a pitch
            if gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo != nil {
                // Checks if theres a new pitch info to update
                if pitchInfoQueueIndex < pitchInfoQueue.count {
                    // Gets the pitch information
                    let pitchEvent = pitchInfoQueue[pitchInfoQueueIndex]
                    // Sets the necessary information
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.pitchVelo = pitchEvent.pitchVelo
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.completedPitch?.pitchVelo = pitchEvent.pitchVelo ?? 0
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.exitVelo = pitchEvent.exitVelo
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.completedPitch?.hitterExitVelo = pitchEvent.exitVelo
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.pitchLocations = pitchEvent.pitchLocations
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.completedPitch?.pitchLocation = pitchEvent.pitchLocations
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.selectedPitchThrown = pitchEvent.selectedPitchThrown
                    gameSnapshots[nextPitchInfoToUpdate].eventViewModel.pitchEventInfo?.completedPitch?.pitchType = pitchEvent.selectedPitchThrown
                    // Updates the snapshot
                    GameSnapshotSaveManagement.updateGameSnapshot(snapshotToUpdate: gameSnapshots[nextPitchInfoToUpdate])
                    // Increments to the next snapshot and next pitch info
                    pitchInfoQueueIndex += 1
                    nextPitchInfoToUpdate += 1
                } else {
                    // Stops to wait until a new pitch info is added
                    break
                }
            } else {
                // Goes to the next snapshot
                nextPitchInfoToUpdate += 1
            }
        }
    }
    
    func updateSnapshot(withSnapshot snapshot : GameSnapshot, withBuilder builder : [BasePathEventInfoBuilder], withPlayerAtFirst first: [String : Any],
                        withPlayerAtSecond second: [String : Any], withPlayerAtThird third: [String : Any]) {
        if let index = self.gameSnapshots.firstIndex(of: snapshot) {
            let newSnapshot = snapshot
            // Resets the base path information
            newSnapshot.eventViewModel.basePathInfo = []
            newSnapshot.eventViewModel.basePathInfo = self.buildBasePathInfoFromBuilders(withBuilders: builder, withTeam: newSnapshot.currentInning?.isTop ?? false ? .Away : .Home)
            
            if let inning = newSnapshot.currentInning, let atBat = newSnapshot.currentAtBat {
                // Check if the player at first isn't empty
                newSnapshot.eventViewModel.playerAtFirstAfter = buildBaseInfoFromBuilder(withBuilder: first, inAtBat: atBat, inInning: inning, roster: inning.isTop  ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster)
                
                // Check if the player at second isn't empty
                newSnapshot.eventViewModel.playerAtSecondAfter = buildBaseInfoFromBuilder(withBuilder: second, inAtBat: atBat, inInning: inning, roster: inning.isTop ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster)
                
                // Check if the player at third isn't empty
                newSnapshot.eventViewModel.playerAtThirdAfter = buildBaseInfoFromBuilder(withBuilder: third, inAtBat: atBat, inInning: inning, roster: inning.isTop ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster)
                
            }
           
            // Updates the game snapshot
            self.gameSnapshots[index] = newSnapshot
        }
    }
    
    func saveNextGameSnapshot() {
       // if snapShotIndex >= updateOffset {
            let snapshotToUpdate = gameSnapshots[snapShotIndex-updateOffset]
            if roles.contains(.PitchOutcome), !snapshotToUpdate.saved {
                GameSnapshotSaveManagement.saveMostRecentGameSnapshot(snapshotToSave: snapshotToUpdate, forSnapshotIndex: snapShotIndex-updateOffset)
                gameSnapshots[snapShotIndex-updateOffset].saved = true
                GameSnapshotSaveManagement.updateSnapshotWhenUpdated(snapshotToMonitor: snapshotToUpdate) { (updatedSnapshot, builder, first, second, third) in
                    self.updateSnapshot(withSnapshot: updatedSnapshot, withBuilder: builder, withPlayerAtFirst: first, withPlayerAtSecond: second, withPlayerAtThird: third)
                }
            }
        //}
    }
    
    func buildEventViewModelFromBuilder(withBuilder builder : EventViewModelBuilder, withPitchBuilder pitchBuilder : PitchBuilder?,  withHittingTeam team : GameTeamType,
                                        snapshotAtBat atBat: AtBat,
                                        currentInning inning: Inning) -> EventViewModel {
        let eventViewModel = EventViewModel()
        eventViewModel.eventNum = builder.eventNum
        eventViewModel.placeInHomeLineup = builder.placeInHomeLineup
        eventViewModel.placeInAwayLineup = builder.placeInAwayLineuo
        eventViewModel.numberOfOuts = builder.numberOfOuts
        eventViewModel.awayScore = builder.awayScore
        eventViewModel.homeScore = builder.homeScore
        eventViewModel.earnedAwayScore = builder.awayScoreEarned
        eventViewModel.earnedHomeScore = builder.homeScoreEarned
        eventViewModel.numStrikes = builder.numStrikes
        eventViewModel.numBalls = builder.numBalls
        eventViewModel.pitcherID = builder.pitcherID
        eventViewModel.hitterID = builder.hitterID
        eventViewModel.isEndOfAtBat = builder.isEndOfAtBat
        
        var playersWhoSc : [Member] = []
        let roster = team == .Away ? game?.awayTeam.members ?? [] : game?.homeTeam.members ?? []
        for player in roster {
            if builder.runnersWhoScored.contains(player.memberID), !playersWhoSc.contains(player) {
                playersWhoSc.append(player)
            }
        }
        eventViewModel.runnersWhoScored = playersWhoSc
        
//        var convertedPlayersInvolved : [MemberInGame] = []
//        var convertedErrorsInvolved : [PlayerErrorInfo] = []
     //   if !builder.pitchInfo.isEmpty, let pitchNumber = builder.pitchInfo["pitchNumber"] as? Int {
     //   let lineupViewing = getLineup(atPitchNumber: pitchNumber, forTeam: team == .Home ? .Away : .Home)
//            // Builds the players involved
//            for playerInvolved in builder.playersInvolved {
//                let memberInGameID = playerInvolved.key
//                let position = Positions(rawValue: playerInvolved.value) ?? .Bench
//                for member in lineupViewing {
//                    if member.member.memberID == memberInGameID, position == member.positionInGame {
//                        convertedPlayersInvolved.append(member)
//                        break
//                    }
//                }
//            }
//            // Builds the errors involved
//            for errorInvolved in builder.errorsInvolved {
//                let memberInGameID = errorInvolved.key
//                let error = ErrorType(rawValue: errorInvolved.value) ?? .FieldingError
//                for member in lineupViewing {
//                    if member.member.memberID == memberInGameID {
//                        convertedErrorsInvolved.append(PlayerErrorInfo(fielderInvolved: member, type: error))
//                        break
//                    }
//                }
//            }
        if let pitchBuilder = pitchBuilder {
            eventViewModel.pitchEventInfo = buildPitchFromBuilder(withBuilder: pitchBuilder)
        }
        
        eventViewModel.basePathInfo = self.buildBasePathInfoFromBuilders(withBuilders: builder.basePathEvent, withTeam: team)
        // Check if the player at first isn't empty
        eventViewModel.playerAtFirstAfter = buildBaseInfoFromBuilder(withBuilder: builder.playerAtFirstAfter, inAtBat: atBat, inInning: inning, roster: team == .Home ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster)
        
        
        // Check if the player at second isn't empty
        eventViewModel.playerAtSecondAfter = buildBaseInfoFromBuilder(withBuilder: builder.playerAtSecondAfter, inAtBat: atBat, inInning: inning, roster: team == .Home ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster)
        
        // Check if the player at third isn't empty
        eventViewModel.playerAtThirdAfter = buildBaseInfoFromBuilder(withBuilder: builder.playerAtThirdAfter, inAtBat: atBat, inInning: inning, roster: team == .Home ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster)
//        eventViewModel.playersInvolved = convertedPlayersInvolved
//        eventViewModel.playerWhoCommittedError = convertedErrorsInvolved
        return eventViewModel
    }
    
    func buildBaseInfoFromBuilder(withBuilder builder: [String : Any],
                                  inAtBat atBat: AtBat,
                                  inInning inning: Inning,
                                  roster: [MemberInGame]) -> BaseState? {
        
        if let playerOnBase = builder["playerOnBase"] as? String {
            let pinchRunnerID: String? = builder["pinchRunner"] as? String
            var member: MemberInGame = MemberInGame(member: Member(withID: playerOnBase, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Switch, withHittingHands: .Switch), positionInGame: .Bench)
            var pinchRunner: MemberInGame? = nil
            if let id = pinchRunnerID {
                pinchRunner = MemberInGame(member: Member(withID: id, withFirstName: "", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Switch, withHittingHands: .Switch), positionInGame: .Bench)
            }
            let baseState = BaseState(playerOnBase: member,
                                      originalAtBat: atBat,
                                      inInning: inning,
                                      pinchRunner: pinchRunner)
            print("NOT RETURNING NULL")
            return baseState
            
        }
        print("RETURNING NULL")
        return nil
    }
    
    func buildPitchFromBuilder(withBuilder builder : PitchBuilder) -> PitchEventInfo? {
        var pitchEventBuilder = PitchEventInfo()
        
        let pitchNumber = builder.pitchNumber
        
        if let pitcherHand = builder.pitcherHand, let hitterHand = builder.hitterHand, let pitchingStyle = builder.pitchingStyle {
            var pitch = Pitch(pitchNumber: pitchNumber,
                              pitcherThrowingHand: pitcherHand,
                              hitterHittingHand: hitterHand,
                              pitchingStyle: pitchingStyle)
            if let type = builder.pitchType {
                pitch.pitchType = type
                pitchEventBuilder.selectedPitchThrown = type
            }
            if let velo = builder.pitchVelo {
                pitch.pitchVelo = velo
                pitchEventBuilder.pitchVelo = velo
            }
            pitch.pitchLocation = builder.pitchLocations
            if let pitchLocations = builder.pitchLocations {
                pitchEventBuilder.pitchLocations = pitchLocations
            }
            if let exitVelo = builder.hitterExitVelo {
                pitch.hitterExitVelo = exitVelo
                pitchEventBuilder.exitVelo = exitVelo
            }
            if let outcome = builder.pitchOutcome {
                pitch.pitchResult = outcome
                pitchEventBuilder.selectedPitchOutcome = outcome
            }
            if let fieldLocation = builder.ballFieldLocation {
                pitch.ballFieldLocation = fieldLocation
                pitchEventBuilder.ballLocation = fieldLocation
            }
            if let type = builder.bipType {
                pitch.bipType = type
                pitchEventBuilder.selectedBIPType = type
            }
            pitch.bipHit = builder.bipHits
            pitchEventBuilder.selectedBIPHit = builder.bipHits
            pitchEventBuilder.completedPitch = pitch
            return pitchEventBuilder
        }
        return nil
    }
    
    func getLineup(atPitchNumber pitchNum : Int, forTeam team : GameTeamType) -> [MemberInGame] {
//        var selectedChange : LineupChange = lineup.lineupChanges[0]
//        for change in lineup.lineupChanges {
//            if change.pitchNumChanged <= pitchNum {
//                selectedChange = change
//            }
//        }
        return team == .Away ? lineup.totalAwayTeamRoster : lineup.totalHomeTeamRoster
    }
    func buildBasePathInfoFromBuilders(withBuilders builder :
                                        [BasePathEventInfoBuilder], withTeam team : GameTeamType) -> [BasePathEventInfo] {
        var completed : [BasePathEventInfo] = []
        for build in builder {
            // Stores the member if found
            var selectedMember : MemberInGame?
            // Checks which lineup to use
            if team == .Away {
                // Explores the members in the away lineup
                for member in
                    // Checks if the member ID is equal to the current member
                    self.lineup.curentAwayTeamLineup {
                    if build.runnerInvolved == member.member.memberID {
                        // Sets the member to the selected member
                        selectedMember = member
                        break
                    }
                }
            } else {
                // Explores the members in the home lineup
                for member in
                    self.lineup.currentHomeTeamLineup {
                    // Checks if the member ID is equal to the current member
                    if build.runnerInvolved == member.member.memberID {
                        // Sets the member to the selected member
                        selectedMember = member
                        break
                    }
                }
            }
            // Checks if a member was found
            if let member = selectedMember {
                // Adds the new base path update
                completed.append(BasePathEventInfo(runnerInvolved: member, type: build.type))
            }
        }
        return completed
    }
    
    /// Gets the total hits for the specified team by inning
    /// - Parameter team: The team to get the total hits
    /// - Returns: A dictionary of all of the innings containing the number of hits grouped by inning
    func getTotalHits(forTeam team : GameTeamType) -> Int {
        return getTotalHits(forTeam: team, settingsViewModel: SettingsViewModel())
    }
    
    /// Gets the total runs grouped by each inning
    /// - Returns: A dictionary containing all of the runs organized by inning numbers
    func getTotalRunsByInning() -> [Int : Any] {
        var totals : [Int : Int] = [:]
        for snapshotIndex in 0..<snapShotIndex {
            let snapshot = gameSnapshots[snapshotIndex]
            if let inning = snapshot.currentInning {
                let prevScore = totals[inning.inningNum] ?? 0
                //if inning.isTop {
                    totals.updateValue(prevScore + snapshot.eventViewModel.runnersWhoScored.count, forKey: inning.inningNum)
                //} else {
                //    totals.updateValue(prevScore + snapshot.eventViewModel.runnersWhoScored.count, forKey: inning.inningNum)
                //}
            }
        }
        return totals
    }
    
    func getTotalErrors(forTeam team : GameTeamType) -> Int {
        var total : Int = 0
        
        for snapshotIndex in 0..<self.snapShotIndex {
            let snapshot = gameSnapshots[snapshotIndex]
            if snapshot.currentInning?.isTop ?? false && team == .Home ||
                snapshot.currentInning?.isTop ?? false && team == .Away {
                let eventView = snapshot.eventViewModel
                var errorTotal = 0
                for event in eventView?.basePathInfo ?? [] {
                    if event.type == BasePathType.AdvancedHomeError ||
                        event.type == BasePathType.AdvancedThirdError ||
                        event.type == .AdvancedSecondError {
                        errorTotal += 1
                    }
                }
                if let pitch = eventView?.pitchEventInfo?.completedPitch {
                    if pitch.pitchResult == .FoulBallDropped {
                        errorTotal += 1
                    }
                    if pitch.bipHit.contains(.Error) {
                        errorTotal += 1
                    }
                    if pitch.bipHit.contains(.AdvancedHomeError) {
                        errorTotal += 1
                    }
                    if pitch.bipHit.contains(.AdvancedToThirdError) {
                        errorTotal += 1
                    }
                    if pitch.bipHit.contains(.AdvancedToSecondError) {
                        errorTotal += 1
                    }
                    if pitch.bipHit.contains(.SacFlyError) {
                        errorTotal += 1
                    }
                    if pitch.bipHit.contains(.SacBuntError) {
                        errorTotal += 1
                    }
                }
                total += errorTotal
            }
        }
        
        return total
    }
    
//    func getTotalScore(forTeam team : GameTeamType) -> Int {
//        switch team {
//        case .Home:
//            return homeScore + earnedHomeScore
//        case .Away:
//            return awayScore + earnedAwayScore
//        }
//    }
    
    
    
    func getTotalHits(forTeam team : GameTeamType, settingsViewModel : SettingsViewModel) -> Int {
        var totalHits = 0
        for snapshot in 0..<snapShotIndex {
            let currentSnapshot = gameSnapshots[snapshot]
            if let atBat = currentSnapshot.currentAtBat, team == .Away ? currentSnapshot.currentInning?.isTop ?? false : !(currentSnapshot.currentInning?.isTop ?? true) {
                let prevFirstBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter : nil
                let prevSecondBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter : nil
                let prevThirdBaseState : BaseState? = snapshot-1 >= 0 ? gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter : nil
                if let pitch = currentSnapshot.eventViewModel.pitchEventInfo?.completedPitch {
                    // Checks if the filter is satisfied and it's not looking at the current at bat
                    if satifysFilter(forPitch: pitch, withSnapshot: currentSnapshot, withAtBatID: atBat.atBatID, settingsViewModel: settingsViewModel, prevFirstBaseState: prevFirstBaseState, prevSecondBaseState: prevSecondBaseState, prevThirdBaseState: prevThirdBaseState) {
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
    
    func satifysFilter(forPitch pitch : Pitch, withSnapshot snapshot: GameSnapshot, withAtBatID atBat : String, settingsViewModel : SettingsViewModel, prevFirstBaseState : BaseState?, prevSecondBaseState : BaseState?, prevThirdBaseState : BaseState?) -> Bool {
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
            currentAtBat?.atBatID != atBat &&
            // Filters by pitcher if necessary
            settingsViewModel.pitcherSelectedFilterType == .All ? true : settingsViewModel.pitcherSelected == snapshot.eventViewModel.pitcherID &&
            // Filters by hitter if necessary
            settingsViewModel.hitterSelectedFilterType == .All ? true : settingsViewModel.hitterSelected == snapshot.eventViewModel.hitterID
        
    }
    
    func getAllPlayers(whoPlayedPosition position : Positions, forTeam team : GameTeamType) -> [Member] {
        var members : [Member] = []
        for snapshotIndex in 0..<self.snapShotIndex {
            let snapshot = gameSnapshots[snapshotIndex]
            let lineup = team == .Away ? snapshot.lineup.curentAwayTeamLineup :
                snapshot.lineup.currentHomeTeamLineup
            for member in lineup {
                if member.positionInGame == position,
                   !members.contains(member.member) {
                    members.append(member.member)
                }
            }
        }
        return members
    }
    
    func getAllPitchers(forTeam team: GameTeamType) -> [Member] {
        var members: [Member] = []
        for snapIndex in 0..<self.snapShotIndex {
            let snapshot = gameSnapshots[snapIndex]
            let pitcherID = snapshot.eventViewModel.pitcherID
            let roster = team == .Away ? snapshot.lineup.totalAwayTeamRoster : snapshot.lineup.totalHomeTeamRoster
            for member in roster {
                if member.member.memberID == pitcherID, !members.contains(member.member) {
                    members.append(member.member)
                }
            }
        }
        return members
    }
    
    func getAllHitters(forTeam team: GameTeamType) -> [Member] {
        var members: [Member] = []
        for snapIndex in 0..<self.snapShotIndex {
            let snapshot = gameSnapshots[snapIndex]
            let hitterID = snapshot.eventViewModel.hitterID
            let roster = team == .Away ? snapshot.lineup.totalAwayTeamRoster : snapshot.lineup.totalHomeTeamRoster
            for member in roster {
                if member.member.memberID == hitterID, !members.contains(member.member) {
                    members.append(member.member)
                }
            }
        }
        return members
    }
    
    func getCurrentStrikes() -> Int {
        if let _ = currentHitter,
           let inning = currentInning,
           let atBat = currentAtBat {
            // Navigate the snapshots in reverse order
            for snapshotIndex in (0..<snapShotIndex).reversed() {
                // Gets the current snapshot
                let snapshot = gameSnapshots[snapshotIndex]
                // Return the number of strikes
                if snapshot.currentInning == inning,
                   snapshot.currentAtBat == atBat {
                    return snapshot.eventViewModel.numStrikes
                }
            }
        }
        // Return 0 strikes
        return 0
    }

    func getCurrentBalls() -> Int {
        if let _ = currentHitter,
           let inning = currentInning,
           let atBat = currentAtBat {
            // Navigate the snapshots in reverse order
            for snapshotIndex in (0..<snapShotIndex).reversed() {
                // Get the current snapshot
                let snapshot = gameSnapshots[snapshotIndex]
                // Return the number of balls
                if snapshot.currentInning == inning,
                   snapshot.currentAtBat == atBat {
                    return snapshot.eventViewModel.numBalls
                }
            }
        }
        // Return 0 balls
        return 0
    }
    
    func getNumberOfPitches() -> Int {
        // Store the total pitches
        var totalPitches: Int = 0
        // Navigate the snapshots
        for snapshotIndex in 0..<snapShotIndex {
            // Get the current snapshot
            let snapshot = gameSnapshots[snapshotIndex]
            // Check if the snapshot has a pitch
            if snapshot.eventViewModel.pitchEventInfo?.completedPitch != nil {
                // Increase the pitch count
                totalPitches += 1
            }
        }
        // Return the total pitches
        return totalPitches
    }
    
    func getCurrentNumberOfOuts() -> Int {
        if snapShotIndex >= 1 {
            if gameSnapshots[snapShotIndex - 1].currentInning == currentInning {
                return gameSnapshots[snapShotIndex - 1].eventViewModel.numberOfOuts
            }
        }
        return 0
    }
    
    func generatePitchTracker() -> [String : Int] {
        // Store the pitch tracker
        var pitchTracker: [String : Int] = [:]
        // Navigate the snapshots
        for snapshotIndex in 0..<snapShotIndex {
            // Get the current snapshot
            let snapshot = gameSnapshots[snapshotIndex]
            // Check if the snapshot has a pitch
            if let pitch = snapshot.eventViewModel.pitchEventInfo?.completedPitch {
                // Get the pitcher of the pitch
                let pitcherID = snapshot.eventViewModel.pitcherID
                // Get the current total or set to zero
                var currentTotal = pitchTracker[pitcherID] ?? 0
                // Add a pitch to the total for the pitcher
                currentTotal += 1
                // Update the dictionary
                pitchTracker.updateValue(currentTotal, forKey: pitcherID)
            }
        }
        // Return the pitch tracker
        return pitchTracker
    }
    
    func getPlayerOnBase(base: Base) -> BaseState? {
        // Get the last snapshot, if it exists
        if snapShotIndex-1 >= 0 && snapShotIndex-1 < gameSnapshots.count && 
           gameSnapshots[snapShotIndex-1].currentInning == currentInning
           {
            switch base {
            case .First:
                return gameSnapshots[snapShotIndex-1].eventViewModel.playerAtFirstAfter
            case .Second:
                return gameSnapshots[snapShotIndex-1].eventViewModel.playerAtSecondAfter
            case .Third:
                return gameSnapshots[snapShotIndex-1].eventViewModel.playerAtThirdAfter
            default:
                return nil
            }
        }
        return nil
    }
    
    func getPlayerOnBaseBefore(base: Base) -> BaseState? {
        // Get the last snapshot, if it exists
        if snapShotIndex >= 0 && snapShotIndex-2 < gameSnapshots.count &&
            gameSnapshots[snapShotIndex-1].currentInning == currentInning {
            switch base {
            case .First:
                return gameSnapshots[snapShotIndex-2].eventViewModel.playerAtFirstAfter
            case .Second:
                return gameSnapshots[snapShotIndex-2].eventViewModel.playerAtSecondAfter
            case .Third:
                return gameSnapshots[snapShotIndex-2].eventViewModel.playerAtThirdAfter
            default:
                return nil
            }
        }
        return nil
    }
    
    func getCurrentGameScore(forTeam team: GameTeamType) -> Int {
        // Get the last snapshot, if it exists
        if let snapshot = gameSnapshots.last {
            switch team {
            case .Away:
                return snapshot.eventViewModel.awayScore + snapshot.eventViewModel.earnedAwayScore
            case .Home:
                return snapshot.eventViewModel.homeScore + snapshot.eventViewModel.earnedHomeScore
            }
        }
        return 0
    }
    
    func getCurrentTeamScoreUnearned(forTeam team: GameTeamType) -> Int {
        if let lastSnapshot = gameSnapshots.last {
            switch team {
            case .Away:
                return lastSnapshot.eventViewModel.awayScore
            case .Home:
                return lastSnapshot.eventViewModel.homeScore
            }
        }
        return 0
    }
    
    func getCurrentTeamScoreEarned(forTeam team: GameTeamType) -> Int {
        if let lastSnapshot = gameSnapshots.last {
            switch team {
            case .Away:
                return lastSnapshot.eventViewModel.earnedAwayScore
            case .Home:
                return lastSnapshot.eventViewModel.earnedHomeScore
            }
        }
        return 0
    }
}

enum GameTeamType {
    case Away
    case Home
    
    func getString() -> String {
        switch self {
        case .Away:
            return "Away"
        case .Home:
            return "Home"
        }
    }
}

enum Base : Int {
    case First = 0
    case Second = 1
    case Third = 2
    case Home = 3
    
    func getBaseString() -> String {
        switch self {
        case .First:
            return "1B"
        case .Second:
            return "2B"
        case .Third:
            return "3B"
        case .Home:
            return "Home"
        }
    }
}

struct BaseState : Equatable {
    var playerOnBase: MemberInGame
    var originalAtBat: AtBat
    var inInning: Inning
    
    var pinchRunner: MemberInGame? = nil
    
    static func == (lhs : BaseState, rhs : BaseState) -> Bool {
        return lhs.playerOnBase == rhs.playerOnBase
    }
}

struct BaseStateBuilder {
    var base: Base
    var player: String
    var atBatNum: Int
    var inningNum: Int
    var pinchRunner: String
}

enum FieldEditMode {
    case Normal
    case Zone
    case PlayerSequence
}
