// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LiveGameView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
        
    @StateObject var eventViewModel : EventViewModel =
        EventViewModel()
    @StateObject var settingsViewModel : SettingsViewModel =
        SettingsViewModel()
    
    //@State var isAddingPitch = false
    @State var atPitchOutcome = false
    @State var isViewingBattingLineup = false
    @State var currentPitchNum : [Member : Int] = [:]
    
    @State var pitchThrown : PitchType? = nil
    @State var pitchOutcome : PitchOutcome? = nil
    
    @State var isSetup: Bool = false
    
    @State var state: Int?
    
    var body: some View {
        if gameViewModel.game?.gameScheduleState == .Finished {
            Button(action: {
                self.state = 6
            }, label: {
                Text("Click Here to Return to the Game Information Tab")
            })
            NavigationLink(
                destination: GameTabView()
                    .environmentObject(gameViewModel)
                    .environmentObject(GameSetupViewModel(withGame: gameViewModel.game!)),
                tag: 6,
                selection: $state,
                label: {EmptyView()})
        } else if isSetup {
            GeometryReader { geometry in
                if let game = gameViewModel.game {
                    VStack {
                        LineScoreView()
                            .environmentObject(gameViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(eventViewModel)
                        VStack(alignment: .leading) {
                            HStack {
                                if settingsViewModel.handMode == .Left {
                                    GameModifyTabView()
                                        .environmentObject(gameViewModel)
                                        .environmentObject(settingsViewModel)
                                        .frame(width: geometry.size.width*0.2)
                                        .border(Color.black, width: 1)
                                }
                                if gameViewModel.fieldEditingMode == .Zone {
                                    FieldZoneView()
                                        .environmentObject(gameViewModel)
                                        .environmentObject(eventViewModel)
                                        .environmentObject(settingsViewModel)
                                } else {
                                    FieldView()
                                        .environmentObject(gameViewModel)
                                        .environmentObject(eventViewModel)
                                        .environmentObject(settingsViewModel)
                                }
                                if settingsViewModel.handMode == .Right {
                                    GameModifyTabView()
                                        .environmentObject(gameViewModel)
                                        .environmentObject(settingsViewModel)
                                        .frame(width: geometry.size.width*0.2)
                                        .border(Color.black, width: 1)
                                }
                                
                            }
                        }.frame(width: geometry.size.width, alignment: Alignment.leading)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    }
                } else if gameViewModel.roles.contains(.PitchLocation) {
                    VStack {
                        LineScoreView()
                            .environmentObject(gameViewModel)
                            .environmentObject(settingsViewModel)
                        FieldView()
                            .environmentObject(gameViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(eventViewModel)
                    }
                }
            }.navigationBarTitle("").navigationBarHidden(true)
        } else {
            ActivityIndicator()
                .onAppear {
                    if gameViewModel.numberOfPreloadedSnapshots > 0 {
                        for _ in 0..<gameViewModel.numberOfPreloadedSnapshots-1 {
                            eventViewModel.reset()
                        }
                    }
                    
                    self.isSetup = true
                }
        }
    }
    
    func generatePitchThrownButton() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        // Explores all of the possible pitch types
        for pitchType in PitchType.allCases {
            let button = Alert.Button.default(Text(pitchType.getPitchTypeString())) {
                self.pitchThrown = pitchType
                self.atPitchOutcome = true
            }
            buttons.append(button)
        }
        return buttons
    }
    
    func generatePitchOutComeButtons() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        for outcome in PitchOutcome.allCases {
            let button = Alert.Button.default(Text(outcome.getPitchOutcomeString())) {
            }
            buttons.append(button)
        }
        return buttons
    }
}

struct GameModifyTabView: View {
 
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                LineupView()
                    .environmentObject(gameViewModel)
                    .environmentObject(LineupViewModel(
                                        withLineup: gameViewModel.lineup))
                    .tabItem { Text("Lineup") }
                    
                GameSnapshotView()
                    .environmentObject(gameViewModel)
                    .environmentObject(settingsViewModel)
                    .tabItem { Text("History") }
                
                AnalyticsReportView()
                    .environmentObject(gameViewModel)
                    .environmentObject(settingsViewModel)
                    .tabItem { Text("Reports") }
            }
        }
        
    }
}

enum PitchType : Int, CaseIterable, Codable {
    case Fastball = 0
    case Curveball = 1
    case Slider = 2
    case Changeup = 3
    case Cutter = 5
    case Splitter = 6
    case KnuckleCurve = 7
    case KnuckleBall = 8
    case Eephus = 9
    case None = 10
    
    func getPitchTypeString() -> String {
        switch self {
        case .Fastball:
            return "Fastball"
        case .Curveball:
            return "Curveball"
        case .Slider:
            return "Slider"
        case .Changeup:
            return "Changeup"
        case .Cutter:
            return "Cutter"
        case .Splitter:
            return "Splitter"
        case .KnuckleCurve:
            return "Knuckle Curve"
        case .KnuckleBall:
            return "Knuckle Ball"
        case .Eephus:
            return "Eephus"
        case .None:
            return "None"
        }
    }
}

enum PitchOutcome : Int, CaseIterable {
    case Ball = 0
    case BallWildPitch = 1
    case BallPassedBall = 2
    case PitchOutBall = 19
    case BallForce = 18

    case StrikeCalled = 3
    case StrikeSwingMiss = 4
    case PitchOutSwinging = 20
    case WildPitchStrikeLooking = 22
    case PassedBallStrikeLooking = 21
    case PitchOutLooking = 23
    
    case PassedBallStrikeSwinging = 14
    case WildPitchStrikeSwinging  = 15
    case StrikeForce = 17
    case FoulBall = 5
    case FoulBallDropped = 39
    
    case HBP = 6
    case BIP = 7
    case Balk = 8
    case IntentionalBall = 9
    case CatcherInter = 10
    case BatterInter = 16
    case IllegalPitch = 11
    
    case DroppedThirdSwingingSafePassedBall = 35
    case DroppedThirdLookingSafePassedBall = 36
    case DroppedThirdSwingingSafe = 12
    case DroppedThirdLookingSafe = 13
    case DroppedThirdSwingingOut = 37
    case DroppedThirdLookingOut = 38
    

   
    
    func getPitchOutcomeString() -> String {
        switch self {
        case .Ball, .PitchOutBall:
            return "Ball"
        case .BallWildPitch:
            return "Ball Wild Pitch"
        case .BallPassedBall:
            return "Passed Ball"
        case .StrikeCalled, .PassedBallStrikeLooking, .WildPitchStrikeLooking, .PitchOutLooking:
            return "Strike Looking"
        case .StrikeSwingMiss, .PassedBallStrikeSwinging, .WildPitchStrikeSwinging, .PitchOutSwinging:
            return "Strike Swinging"
        case .FoulBall:
            return "Foul Ball"
        case .FoulBallDropped:
            return "Foul Ball Dropped"
        case .HBP:
            return "HBP"
        case .BIP:
            return "BIP"
        case .IntentionalBall:
            return "Intentional Walk"
        case .CatcherInter:
            return "Catcher Interference"
        case .IllegalPitch:
            return "Illegal Pitch"
        case .Balk:
            return "Balk"
        case .BatterInter:
            return "Batter Interference"
        case .StrikeForce:
            return "Forced Strike"
        case .BallForce:
            return "Forced Ball"
        case .DroppedThirdSwingingSafePassedBall:
            return "Dropped Third Swinging Safe + Passed Ball"
        case .DroppedThirdLookingSafePassedBall:
            return "Dropped Third Looking Safe + Passed Ball"
        case .DroppedThirdSwingingSafe:
            return "Dropped Third Swinging Safe"
        case .DroppedThirdLookingSafe:
            return "Dropped Third Looking Safe"
        case .DroppedThirdSwingingOut:
            return "Dropped Third Swinging Out"
        case .DroppedThirdLookingOut:
            return "Dropped Third Looking Out"
        }
    }
    
    func getEquivalentOutcomes() -> [PitchOutcome] {
        switch self {
        case .StrikeForce,.StrikeCalled,.StrikeSwingMiss, .WildPitchStrikeSwinging, .PassedBallStrikeSwinging, .PitchOutSwinging, .PassedBallStrikeLooking, .PitchOutLooking, .WildPitchStrikeLooking:
            return [.StrikeForce, .StrikeCalled, .StrikeSwingMiss, .WildPitchStrikeSwinging, .PassedBallStrikeSwinging, .PitchOutSwinging, .PassedBallStrikeLooking, .PitchOutLooking, .WildPitchStrikeLooking]
        case .Ball, .BallWildPitch, .BallPassedBall, .BallForce, .PitchOutBall:
            return [.Ball, .BallWildPitch, .BallPassedBall, .BallForce, .PitchOutBall]
        case .HBP:
            return [.HBP]
        case .BatterInter:
            return [.BatterInter]
        case .CatcherInter:
            return [.CatcherInter]
        case .IllegalPitch:
            return [.IllegalPitch]
        case .BIP:
            return [.BIP]
        case .Balk:
            return [.Balk]
        case .FoulBall, .FoulBallDropped:
            return [.FoulBall, .FoulBallDropped]
        case .DroppedThirdLookingOut, .DroppedThirdSwingingOut:
            return [.DroppedThirdLookingOut, .DroppedThirdSwingingOut]
        case .DroppedThirdLookingSafe, .DroppedThirdSwingingSafe, .DroppedThirdLookingSafePassedBall, .DroppedThirdSwingingSafePassedBall:
            return [.DroppedThirdLookingSafe, .DroppedThirdSwingingSafe, .DroppedThirdLookingSafePassedBall, .DroppedThirdSwingingSafePassedBall]
        case .IntentionalBall:
            return [.IntentionalBall]
        }
    }
    
    func isStrike() -> Bool {
        return self == .StrikeForce ||
            self == .StrikeCalled ||
            self == .StrikeSwingMiss ||
            self == .WildPitchStrikeSwinging ||
            self == .PassedBallStrikeSwinging ||
            self == .BIP ||
            self == .FoulBall || self.isStrikeSwinging() ||
            self == .DroppedThirdLookingOut || self == .DroppedThirdLookingSafe
            || self == .DroppedThirdLookingSafePassedBall
    }
    
    func isStrikeSwinging() -> Bool {
        return self == .StrikeSwingMiss ||
            self == .DroppedThirdSwingingSafe ||
            self == .DroppedThirdSwingingOut ||
            self == .DroppedThirdSwingingSafePassedBall ||
            self == .WildPitchStrikeSwinging ||
            self == .PassedBallStrikeSwinging ||
            self == .BIP || self == .FoulBallDropped
    }
    
    func isBall() -> Bool {
        return self == .Ball ||
            self == .BallWildPitch ||
            self == .BallPassedBall ||
            self == .BallForce
    }
    
    func doesntRequireStrikeZone() -> Bool {
        return self == .IntentionalBall ||
            self == .IllegalPitch ||
            self == .CatcherInter ||
            self == .BatterInter ||
            self == .Balk
    }
    
    func isPassedBall() -> Bool {
        return self == .PassedBallStrikeLooking ||
            self == .PassedBallStrikeSwinging ||
            self == .BallPassedBall ||
            self == .DroppedThirdSwingingSafePassedBall ||
            self == .DroppedThirdLookingSafePassedBall
    }
}

enum BIPType : Int, CaseIterable {
    case GB = 0
    case HGB = 1
    case FlyBall = 2
    case LineDrive = 3
    case PopFly = 4
    case Bunt = 5
    case Flare = 6
    
    func getBIPTypeString() -> String {
        switch self {
        case .GB:
            return "Ground Ball"
        case .HGB:
            return "Hard Ground Ball"
        case .FlyBall:
            return "Fly Ball"
        case .LineDrive:
            return "Line Drive"
        case .PopFly:
            return "Pop Fly"
        case .Bunt:
            return "Bunt"
        case .Flare:
            return "Flare"
        }
    }
}

enum BIPHit : Int, CaseIterable {
    case FirstB = 0
    case SecondB = 1
    case SecondBGroundRule = 2
    case ThirdB = 3
    case HR = 4
    case HRInPark = 5
    case FoulBall = 7
    case FoulBallCaught = 25
    case DoublePlay = 9
    case TriplePlay = 10
    
    case SacFly = 12
    case SacFlyError = 13
    
    case SacBunt = 14
    case BuntFoulBall = 15
    case SacBuntError = 16
    
    case FielderChoice = 8
    case FielderChoiceOut = 17

    case OutAtFirst = 6
    case AdvancedToSecondError = 18
    case AdvancedToThirdError = 19
    case AdvancedHomeError = 20
    
    case CaughtAdvancingToSecond = 21
    case CaughtAdvancingToThird = 22
    case CaughtAdvancingHome = 23
    
    case Error = 24
    case ForceOut = 26
    
    func getBIPHitString() -> String {
        switch self {
        case .FirstB:
            return "Single"
        case .SecondB:
            return "Double"
        case .SecondBGroundRule:
            return "Ground Rule Double"
        case .ThirdB:
            return "Triple"
        case .HR:
            return "Home Run"
        case .HRInPark:
            return "In the Park Home Run"
        case .OutAtFirst:
            return "Out"
        case .FoulBall:
            return "Foul Ball Catch Attempt"
        case .FielderChoice:
            return "Safe on Fielder's Choice"
        case .FielderChoiceOut:
            return "Out on Fielder's Choice"
        case .DoublePlay:
            return "Double Play"
        case .TriplePlay:
            return "Triple Play"
        case .SacFly:
            return "Sac Fly"
        case .SacFlyError, .SacBuntError:
            return "Error"
        case .SacBunt:
            return "Sac Bunt"
        case .BuntFoulBall:
            return "Foul Ball"
        case .AdvancedToSecondError:
            return "Advanced to Second on Error"
        case .AdvancedToThirdError:
            return "Advanced to Third on Error"
        case .AdvancedHomeError:
            return "Advanced to Home on Error"
        case .CaughtAdvancingToSecond:
            return "Caught Streching to Second"
        case .CaughtAdvancingToThird:
            return "Caught Streching to Third"
        case .CaughtAdvancingHome:
            return "Caught Streching Home"
        case .FoulBallCaught:
            return "Foul Ball Caught"
        case .Error:
            return "Safe on Error"
        case .ForceOut:
            return "Force Out"

        }
        
    }
}
