// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GroupRunnerView: View {
   
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    @State var firstSelected : Bool = false
    @State var secondSelected : Bool = false
    @State var thirdSelected : Bool = false
    
    @State var modalView : ModalActionOptionView?
    
    @State var playerInvolvementNeeded : Bool = false
        
    @State var width : CGFloat = 0
    @State var height : CGFloat = 0

    var body: some View {
        GeometryReader { (geometry) in
            if let player = gameViewModel.getPlayerOnBase(base: .First)?.pinchRunner ?? gameViewModel.getPlayerOnBase(base: .First)?.playerOnBase {
                RunnerView(player: player, widthAdjustment: 0.68, heightAdjustment: 0.66)
                    .onTapGesture {
                        assignModalPosition(forBase: .First)
                        modalView = ModalActionOptionView(message: "Runner on \(Base.First.getBaseString())", actionOptions: getCurrentOptions(forBase: .First))
                    }.sheet(isPresented: $firstSelected, content: {
                        if let inning = gameViewModel.currentInning {
                            PinchRunnerSelectionView(base: .First, editingAwayTeam: inning.isTop ? true : false, runnerSelectionType: .Occupied)
                                .environmentObject(gameViewModel)
                                .environmentObject(lineupViewModel)
                        }
                    })
            } else {
                EmptyRunnerView(widthAdjustment: 0.68, heightAdjustment: 0.66)
                    .onTapGesture {
                        assignModalPosition(forBase: .First)
                        modalView = ModalActionOptionView(message: "First Base", actionOptions: generateEmptyBaseOptions(forBase: .First))
                    }.sheet(isPresented: $firstSelected, content: {
                        if let inning = gameViewModel.currentInning {
                            PinchRunnerSelectionView(base: .First, editingAwayTeam: inning.isTop ? true : false, runnerSelectionType: .Empty)
                                .environmentObject(gameViewModel)
                                .environmentObject(lineupViewModel)
                        }
                    })
            }
            if let player = gameViewModel.getPlayerOnBase(base: .Second)?.pinchRunner ?? gameViewModel.getPlayerOnBase(base: .Second)?.playerOnBase {
                RunnerView(player: player, widthAdjustment: 0.5, heightAdjustment: 0.45)
                    .onTapGesture {
                        assignModalPosition(forBase: .Second)
                        modalView = ModalActionOptionView(message: "Second on \(Base.Second.getBaseString())", actionOptions: getCurrentOptions(forBase: .Second))
                    }.sheet(isPresented: $secondSelected, content: {
                        if let inning = gameViewModel.currentInning {
                            PinchRunnerSelectionView(base: .Second, editingAwayTeam: inning.isTop ? true : false, runnerSelectionType: .Occupied)
                                .environmentObject(gameViewModel)
                                .environmentObject(lineupViewModel)
                        }
                    })
            } else {
                EmptyRunnerView(widthAdjustment: 0.5, heightAdjustment: 0.45)
                    .onTapGesture {
                        assignModalPosition(forBase: .Second)
                        modalView = ModalActionOptionView(message: "Empty Base", actionOptions: generateEmptyBaseOptions(forBase: .Second))
                    }.sheet(isPresented: $secondSelected, content: {
                        if let inning = gameViewModel.currentInning {
                            PinchRunnerSelectionView(base: .Second, editingAwayTeam: inning.isTop ? true : false, runnerSelectionType: .Empty)
                                .environmentObject(gameViewModel)
                                .environmentObject(lineupViewModel)
                        }
                    })
            }
            if let player = gameViewModel.getPlayerOnBase(base: .Third)?.pinchRunner ?? gameViewModel.getPlayerOnBase(base: .Third)?.playerOnBase {
                RunnerView(player: player, widthAdjustment: 0.32, heightAdjustment: 0.66)
                    .onTapGesture {
                        assignModalPosition(forBase: .Third)
                        modalView = ModalActionOptionView(message: "Runner on \(Base.Third.getBaseString())", actionOptions: getCurrentOptions(forBase: .Third), widthMod: 0.15, heightMod: 0.4)
                    }.sheet(isPresented: $thirdSelected, content: {
                        if let inning = gameViewModel.currentInning {
                            PinchRunnerSelectionView(base: .Third, editingAwayTeam: inning.isTop ? true : false, runnerSelectionType: .Occupied)
                                .environmentObject(gameViewModel)
                                .environmentObject(lineupViewModel)
                        }
                    })
            } else {
                EmptyRunnerView(widthAdjustment: 0.32, heightAdjustment: 0.66)
                    .onTapGesture {
                        assignModalPosition(forBase: .Third)
                        modalView = ModalActionOptionView(message: "Third Base", actionOptions: generateEmptyBaseOptions(forBase: .Third))
                    }.sheet(isPresented: $thirdSelected, content: {
                        if let inning = gameViewModel.currentInning {
                            PinchRunnerSelectionView(base: .Third, editingAwayTeam: inning.isTop ? true : false, runnerSelectionType: .Empty)
                                .environmentObject(gameViewModel)
                                .environmentObject(lineupViewModel)
                        }
                    })
            }
            if let view = modalView {
                view
                    .position(x: geometry.size.width * (width), y: geometry.size.height * (height))
            }
        }.onReceive(gameViewModel.$runnerEditingMode, perform: { _ in
            if gameViewModel.runnerEditingMode == .Pitch, gameViewModel.getBasesWithRunners().count > 0 {
                let base : Base = (gameViewModel.getPlayerOnBase(base: .Third) != nil ? .Third : gameViewModel.getPlayerOnBase(base: .Second) != nil ? .Second : gameViewModel.getPlayerOnBase(base: .First) != nil ? .First : .Home)
                assignModalPosition(forBase: base)
                modalView = ModalActionOptionView(message: "Runner on \(base.getBaseString())", actionOptions: generatePitchOptionButtons(forBase: base))
            } else if gameViewModel.runnerEditingMode == .Pitch {
                finish()
            }
        })
    }
    
    func getCurrentOptions(forBase base : Base) -> [ActionOption] {
        if gameViewModel.runnerEditingMode == .Pitch  || gameViewModel.runnerEditingMode == .StoleBase {
            return generatePitchOptionButtons(forBase: base)
        } else {
            return generateOptions(forBase: base)
        }
    }
    
    func generateEmptyBaseOptions(forBase base : Base) -> [ActionOption] {
        var buttons : [ActionOption] = []
        
        let setPinchRunner = ActionOption(message: "Put Player On Base") {
            switch base {
            case .First:
                firstSelected = true
                break
            case .Second:
                secondSelected = true
                break
            case .Third:
                thirdSelected = true
                break
            case .Home:
                break
            }
            modalView = nil
        }

        let safe = ActionOption(message: "Dismiss") {
            modalView = nil
        }

        buttons.append(setPinchRunner)
        buttons.append(safe)
        
        return buttons
    }
    
    func generateOptions(forBase base : Base) -> [ActionOption] {
        var buttons : [ActionOption] = []
        
        // Button to track that there was an attempted pickoff
        let aP = ActionOption(message: "Attempted Pickoff") {
            // Check if there's a valid runner on base
            if let runner = gameViewModel.getPlayerOnBase(base: base)?.playerOnBase {
                // Add the base path info
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: runner, type: base == .First ? .AttemptedPickoffFirst : base == .Second ? .AttemptedPickoffSecond : .AttemptedThirdPickoff))
                // Create a modal view to display the secondary options
                if base != .Home {
                    modalView = ModalActionOptionView(message: "Runner on \(base.getBaseString())", actionOptions : generateSecondOptionButtons(forBase: base))
                } else {
                    // Attempt to update other runners
                    updateOtherRunners(fromBase: base)
                }
            }
        }
        
        // Button to track if the runner was picked off successfully
        let pickedOff = createActionOption(forBase: base, withType: base == .First ? .PickoffOutAtFirst : base == .Second ? .PickoffOutAtSecond : .PickoffOutAtThird, withTitle: "Picked Off")
        
        
        // Button to track if the runner was caught stealing the previous pitch
        let cS = ActionOption(message: "Caught Stealing Last Pitch") {
            // Check if there's a valid runner
            if let runner = gameViewModel.getPlayerOnBase(base: base)?.playerOnBase {
                // Add the caught stealing information to the event
                let info = BasePathEventInfo(runnerInvolved: runner, type: base == .First ? .CaughtStealingSecond : base == .Second ? .CaughtStealingThird : .CaughtStealingHome)
                eventViewModel.basePathInfo.append(info)
                // Update the other runners as necessary
                updateOtherRunners(fromBase: base)
            }
        }

        // Button to track if the runner was successfull in stealing during the previous pitch
        let sS = ActionOption(message: "Stole Base Last Pitch") {
            // Check if there's a valid runner
            if let runner = gameViewModel.getPlayerOnBase(base: base)?.playerOnBase {
                // Add the stole base info to the event
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: runner, type: base == .First ? .StoleSecond : base == .Second ? .StoleThird : .StoleHome))
                // Set runner editing mode to stolen base (TODO: Check if this is still necessary)
                gameViewModel.runnerEditingMode = .StoleBase
                // Check if the secondary options need to be viewed
                if base != .Third {
                    // Show the secondary options
                    modalView = ModalActionOptionView(message: "Runner on \(base.getBaseString())", actionOptions : generateSecondOptionButtons(forBase: base))
                } else {
                    // If the runner is on third, there is no further
                    // advancement that can be take so update
                    // other runners if necessary
                    updateOtherRunners(fromBase: base)
                }
            }
        }
        
        // Button to track if the runner advanced in the previous pitch
        let advancedPrevious = ActionOption(message: "Advanced Last Pitch") {
            if let runner = gameViewModel.getPlayerOnBase(base: base)?.playerOnBase {
                // Add the advanced event to the basepath
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: runner, type: base == .First ? .AdvancedSecond : base == .Second ? .AdvancedThird : base == .Third ? .AdvancedHome : .None))
                // Check if the secondary options need to be viewed
                if base != .Third {
                    // Show the secondary options
                    modalView = ModalActionOptionView(message: "Runner on \(base.getBaseString())", actionOptions : generateSecondOptionButtons(forBase: base))
                } else {
                    // If the runner is on third, there is no further
                    // advancement that can be take so update
                    // other runners if necessary
                    updateOtherRunners(fromBase: base)
                }
            }
        }
        
        // Button to assign the runner a pinch runner
        let assignPinchHitter = ActionOption(message: "Assign Pinch Runner") {
            switch base {
            case .First:
                firstSelected = true
                break
            case .Second:
                secondSelected = true
                break
            case .Third:
                thirdSelected = true
                break
            case .Home:
                break
            }
            modalView = nil
        }
        
        // Button to track if the runner is out on interference
        let outInterference = createActionOption(forBase: base, withType: .OutInterference, withTitle: "Out on Interference")
        
        // Button to forcefully remove player from base
        let removeFromBase = createActionOption(forBase: base, withType: .RemoveFromBase, withTitle: "Remove from Base")
        
        // Dismiss the runner since nothing happened
        // This is here in case the user accidentally clicked or is just
        // curious of the options and no events actually happened
        let dismiss = createActionOption(forBase: base, withType: .None, withTitle: "Dismiss")
        
        
        buttons.append(aP)
        buttons.append(pickedOff)
        buttons.append(cS)
        buttons.append(sS)
        buttons.append(advancedPrevious)
        buttons.append(assignPinchHitter)
        buttons.append(outInterference)
        buttons.append(removeFromBase)
        buttons.append(dismiss)
        
        return buttons
    }

    func generateSecondOptionButtons(forBase base : Base) -> [ActionOption] {
        var buttons : [ActionOption] = []
        if let player = gameViewModel.getPlayerOnBase(base: base)?.playerOnBase {
            let AdvancedToSecondOnError = ActionOption(message: "Advanced to Second on Error") {
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: player, type: .AdvancedSecondError))
                updateOtherRunners(fromBase: base)
            }
            
            let AdvancedToThirdOnError = ActionOption(message: "Advanced to Third on Error") {
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: player, type: .AdvancedThirdError))
                updateOtherRunners(fromBase: base)
            }
            
            let AdvancedToHomeOnError = ActionOption(message: "Advanced to Home on Error") {
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: player, type: .AdvancedHomeError))
                updateOtherRunners(fromBase: base)
            }
            
            if base.rawValue <= Base.Third.rawValue {
                buttons.append(AdvancedToHomeOnError)
            }
            if base.rawValue <= Base.Second.rawValue {
                buttons.append(AdvancedToThirdOnError)
            }
            if  base.rawValue <= Base.First.rawValue {
                buttons.append(AdvancedToSecondOnError)
            }
        }
        let Nothing = ActionOption(message: "Dismiss") {
            updateOtherRunners(fromBase: base)
        }
        buttons.append(Nothing)
        
        return buttons
    }
    
    func generatePitchOptionButtons(forBase base : Base) -> [ActionOption] {
        var buttons : [ActionOption] = []

        if gameViewModel.getPlayerOnBase(base: base)?.playerOnBase != nil {
            var nextBase = Base(rawValue: base.rawValue+1) ?? .Home
            
            if let pitch = eventViewModel.pitchEventInfo {
                if pitch.selectedBIPHit.contains(.SecondB) {
                    nextBase = Base(rawValue: base.rawValue+2) ?? .Home
                } else if pitch.selectedBIPHit.contains(.ThirdB) {
                    nextBase = Base.Home
                }
            }
            
            let stillOnBase = createActionOption(forBase: base, withType: .StillOnBase, withTitle: "Still on Base")
            let advancedToSecondError = createActionOption(forBase: base, withType: .AdvancedSecondError, withTitle: "Advanced to Second on Error")
            let advancedToThirdError = createActionOption(forBase: base, withType: .AdvancedThirdError, withTitle: "Advanced to Third on Error")
            let advancedHomeError = createActionOption(forBase: base, withType: .AdvancedHomeError, withTitle: "Advanced Home on Error")
            let fieldersChoiceOut = createActionOption(forBase: base, withType: .OutonBasePath, withTitle: "Out on Fielder's Choice", playerInvNeeded: true)
            let caughtInDoublePlay = createActionOption(forBase: base, withType: .CaughtInDouble, withTitle: "Caught in Double Play", playerInvNeeded: true)
            let caughtInTriplePlay = createActionOption(forBase: base, withType: .CaughtInTriple, withTitle: "Caught in Triple Play", playerInvNeeded: true)
            
            let outOnBase = createActionOption(forBase: base, withType: .OutonBasePath, withTitle: "Out on Base Path")
            
            buttons.append(outOnBase)
            
            if nextBase.rawValue <= Base.Home.rawValue {
                
                buttons.append(advancedHomeError)
                
                if let pitch = eventViewModel.pitchEventInfo {
                    if pitch.selectedBIPHit.contains(.DoublePlay) {
                        buttons.append(caughtInDoublePlay)
                    }
                    if pitch.selectedBIPHit.contains(.TriplePlay) {
                        buttons.append(caughtInTriplePlay)
                    }
                    if pitch.selectedBIPHit.contains(.FielderChoiceOut) {
                        buttons.append(fieldersChoiceOut)
                    }
                }
            }
            
            if nextBase.rawValue <= Base.Third.rawValue {
                buttons.append(advancedToThirdError)
            }
            
            if nextBase.rawValue <= Base.Second.rawValue {
                buttons.append(advancedToSecondError)
            }
            
            if nextBase.rawValue <= Base.First.rawValue {
            }
            buttons.append(stillOnBase)
            
            var safeAtNextBase = createActionOption(forBase: base, withType: nextBase == .Second ? .AdvancedSecond : nextBase == .Third ? .AdvancedThird : .AdvancedHome, withTitle: "Safe at \(nextBase.getBaseString())")
            buttons.append(safeAtNextBase)
            while (nextBase != .Home) {
                nextBase = Base(rawValue: nextBase.rawValue + 1) ?? .Home
                safeAtNextBase = createActionOption(forBase: base, withType: nextBase == .Second ? .AdvancedSecond : nextBase == .Third ? .AdvancedThird : .AdvancedHome, withTitle: "Safe at \(nextBase.getBaseString())")
                buttons.append(safeAtNextBase)
            }
        }
        
        return buttons.reversed()
    }
    
    func requestEdit(forBase base : Base, withPlayer player : MemberInGame) {
        if base == .Home {
            return
        }
        assignModalPosition(forBase: base)
        modalView = ModalActionOptionView(message: "Runner on \(base.getBaseString())", actionOptions: getCurrentOptions(forBase: base))
    }
    
    func assignModalPosition(forBase base : Base ) {
        switch base {
        case .First:
            width = 0.53
            height = 0.6
            break
        case .Second:
            width = 0.35
            height = 0.45
            break
        case .Third:
            width = 0.15
            height = 0.6//settingsViewModel.handMode == .Right ? 0.35 : 0.6
            break
        case .Home:
            return
        }
    }
    
    func createActionOption(forBase base : Base, withType type : BasePathType, withTitle title : String, playerInvNeeded : Bool = false) -> ActionOption {
        return ActionOption(message: title) {
            if let player = gameViewModel.getPlayerOnBase(base: base)?.playerOnBase {
                eventViewModel.basePathInfo.append(BasePathEventInfo(runnerInvolved: player, type: type))
                if playerInvNeeded {
                    self.playerInvolvementNeeded = true
                }
                updateOtherRunners(fromBase: base)
            }
        }
    }
    
    func updateOtherRunners(fromBase base : Base) {
        var currentBase = Base(rawValue: base.rawValue-1) ?? .Home
        while gameViewModel.getPlayerOnBase(base: currentBase)?.playerOnBase == nil && currentBase != .Home {
            currentBase = Base(rawValue: currentBase.rawValue-1) ?? .Home
        }
        if let nextRunner = gameViewModel.getPlayerOnBase(base: currentBase)?.playerOnBase {
            requestEdit(forBase: currentBase, withPlayer: nextRunner)
        } else if currentBase == .Home {
            finish()
        }
    }
    
    func finish() {
        gameViewModel.addEvent(eventViewModel: eventViewModel)
        eventViewModel.reset()
        gameViewModel.fieldEditingMode = .Normal
        gameViewModel.runnerEditingMode = .Normal
        modalView = nil
    }
}

enum RunnerUpdate {
    case Normal
    case Pitch
    case StoleBase
}
