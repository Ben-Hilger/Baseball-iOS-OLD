// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FieldView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    @EnvironmentObject var settingsViewModel : EventViewModel
    
    @State var modalView : ModalActionOptionView? = nil

    var body: some View {
        if let game = gameViewModel.game {
            VStack {
                FieldAccessoryView()
                    .environmentObject(gameViewModel)
                ZStack {
                    GeometryReader { (geometry) in
                        Image("baseball-field")
                            .resizable()
                        FieldPositionView()
                            .environmentObject(gameViewModel)
                            .environmentObject(eventViewModel)
                            .environmentObject(settingsViewModel)
                        HandSelectionView()
                            .environmentObject(gameViewModel)
                            .environmentObject(settingsViewModel)
                        if gameViewModel.fieldEditingMode == .Normal {
                                GroupRunnerView()
                                    .environmentObject(gameViewModel)
                                    .environmentObject(eventViewModel)
                                    .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup))
                                    .environmentObject(settingsViewModel)
                                
                        }
                        
                        if let view = modalView, gameViewModel.roles.contains(.PitchOutcome) {
                            view
                                .position(x: geometry.size.width * 0.5,
                                          y: geometry.size.height * 0.5)
                        }
                       
                    }
                }
            }.onAppear {
                // Ensures the proper information is available on startup
                ensureProperData()
            }
            .onChange(of: gameViewModel.currentPitchingHand) { value in
                // Ensures the proper hand informaiton is available when the pitching hand info is updated
                ensureProperData()
            }
            .onChange(of: gameViewModel.currentHittingHand) { value in
                // Ensures the proper hand information is available when a new pitcher is put in
                // Ensures the proper hand information is available when a new hitter is put in
                ensureProperData()
            }
            .onChange(of: gameViewModel.currentPitchingStyle, perform: { value in
                ensureProperData()
            })
        }
    }
    
    func handDataIsProper() -> Bool {
        return gameViewModel.currentHittingHand != .Switch &&
            gameViewModel.currentPitchingHand != .Switch
    }
    
    func ensureProperData() {
        // Check if the hand data is good
        if handDataIsProper() {
            // Check if the pitching style is unknown
            if gameViewModel.currentPitchingStyle == .Unknown {
                if gameViewModel.getPlayerOnBase(base: .First) != nil ||
                    gameViewModel.getPlayerOnBase(base: .Second) != nil {
                    gameViewModel.currentPitchingStyle = .Stretch
                } else {
                    // Ask for pitching style
                    askForPitchingStyle()
                }
               
            }
        } else {
            // Force the user to select hand data
            ensureProperHandData()
        }
    }
    
    func ensureProperHandData() {
        // Checks if the hitter is a switch hitter
        if gameViewModel.currentHittingHand == .Switch {
            modalView = ModalActionOptionView(message: "Select Hitter Hand", actionOptions: generateHandOptions(forPlayer: .Hitter))
        // Checks if the pitcher is a switch hitte
        } else if gameViewModel.currentPitchingHand == .Switch {
            modalView = ModalActionOptionView(message: "Select Pitcher Hand", actionOptions: generateHandOptions(forPlayer: .Pitcher))
        }
    }
    
    func askForPitchingStyle() {
        // Set the modal view to display options for pitching style
        modalView = ModalActionOptionView(message: "Select Pitching Style", actionOptions: generatePitchingStyleOptions())
    }
    
    func generateHandOptions(forPlayer playerEditing : PersonEditing) -> [ActionOption] {
        var buttons : [ActionOption] = []
        
        buttons.append(ActionOption(message: "Left", action: {
            if playerEditing == .Hitter {
                gameViewModel.currentHittingHand = .Left
            } else if playerEditing == .Pitcher {
                gameViewModel.currentPitchingHand = .Left
            }
            self.modalView = nil
        }))
        
        buttons.append(ActionOption(message: "Right", action: {
            if playerEditing == .Hitter {
                gameViewModel.currentHittingHand = .Right
            } else if playerEditing == .Pitcher {
                gameViewModel.currentPitchingHand = .Right
            }
            self.modalView = nil
        }))
        
        return buttons
    }
    
    func generatePitchingStyleOptions() -> [ActionOption] {
        // Store the buttons
        var buttons: [ActionOption] = []
        for style in PitchingStyle.allCases {
            if style != .Unknown {
                buttons.append(ActionOption(message: style.getString(), action: {
                    // Set the pitching style
                    gameViewModel.currentPitchingStyle = style
                    // Remove the modal view
                    modalView = nil
                }))
            }
        }
        // Return the buttons
        return buttons
    }
}

enum FieldSheetToView {
    case AddPitch
    case Error
}

enum AlertSheetViewing {
    case HandSelect
}

enum PersonEditing {
    case Hitter
    case Pitcher
    
    func getString() -> String {
        switch self {
        case .Hitter:
            return "Hitter"
        case .Pitcher:
            return "Pitcher"
        }
    }
}
