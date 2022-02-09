// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct AddPitchButtonView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @State var isShowingSheet : Bool = false
    @State var modalView : ModalActionOptionView? = nil
    
    @State var sheetViewing : FieldPositionSheetViewing = .ErrorHandling
   
    @Binding var state : Int?
    
    // View data loss warning if the user dismisses the addpitch view
    @State var savedPitchingData: Bool = false
    @State var viewDataLossWarning: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            if let view = modalView {
                view
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            }
//            if gameViewModel.fieldEditingMode == .PlayerSequence {
//                Button(action: {
////                        if let pitch = eventViewModel.pitchEventInfo, (pitch.selectedBIPHit.contains(.Error) || pitch.selectedBIPHit.contains(.AdvancedHomeError) || pitch.selectedBIPHit.contains(.AdvancedToSecondError) || pitch.selectedBIPHit.contains(.AdvancedToThirdError)) {
//////                            modalView = ModalActionOptionView(message: "Player Who Committed Error", actionOptions: generateErrorButtons(), allowMultiSelect: true, finishAction: { (optionsSelected) in
//////                                for option in optionsSelected {
//////                                    option.action()
//////                                }
//////                                if optionsSelected.count > 0 {
//////                                    sheetViewing = .ErrorHandling
//////                                    isShowingSheet = true
//////                                } else {
//////                                    gameViewModel.addEvent(eventViewModel: eventViewModel)
//////                                    eventViewModel.reset()
//////                                }
//////                                modalView = nil
//////                            })
////                        } else {
//                        gameViewModel.addEvent(eventViewModel: eventViewModel)
//                        eventViewModel.reset()
//                       // }
//                        gameViewModel.fieldEditingMode = .Normal
//                    }, label: {
//                        //Text(gameViewModel.fieldEditingMode == .PlayerSequence && eventViewModel.pitchEventInfo == nil ? "Add Pitch" : "Next")
//                        Text("")
//                    }).padding().disabled(satisfyRequirements())
//            } else
        if gameViewModel.fieldEditingMode == .Normal && (gameViewModel.roles.contains(.PitchOutcome) || gameViewModel.roles.contains(.PitchLocation)) {
                Button(action: {
                    self.sheetViewing = .AddPitch
                    self.isShowingSheet = true
                }, label: {
                    Text("Pitch")
                }).padding().border(Color.black, width: 1).background(Color.white).padding()
                .border(Color.black, width: 5).cornerRadius(6.0)
                .foregroundColor(.blue)
                .position(x: geometry.size.width*0.5, y: geometry.size.height*0.67)
                .sheet(isPresented: $isShowingSheet) {
              //      if sheetViewing == .AddPitch {
                        AddPitchView(savedPitchData: $savedPitchingData)
                            .environmentObject(gameViewModel)
                            .environmentObject(eventViewModel)
               //     }
//                    else if sheetViewing == .ErrorHandling {
//                        ErrorHandlingView()
//                            .environmentObject(gameViewModel)
//                            .environmentObject(eventViewModel)
//                    }
                    
                }
            }
        }.actionSheet(isPresented: $savedPitchingData) {
//            ActionSheet(title: Text("Data Loss Warning"), message:
//                            Text("You're about to dismiss this view without saving the information, would you like to add the pitch data you just entered?"), buttons: [Alert.Button.cancel(Text("No")), Alert.Button.default(Text("Yes"), action: {
//                    if satisfysRequirements() {
////                        if let velo = Float(pitchVelo) {
////                            eventViewModel.pitchEventInfo?.pitchVelo = velo
////                        }
////                        if let exitVelo = Float(exitVelo) {
////                            eventViewModel.pitchEventInfo?.exitVelo = exitVelo
////                        }
//                        if eventViewModel.pitchEventInfo?.selectedPitchOutcome == .BIP {
//                            gameViewModel.fieldEditingMode = .Zone
//                        } else {
//                            gameViewModel.addEvent(eventViewModel: eventViewModel)
//                            eventViewModel.reset()
//                        }
//                    }
//            })])
            ActionSheet(title: Text("Pitch Added"), message: Text("The pitch was added"), buttons: [Alert.Button.default(Text("Ok"))])
        }
    }
    func satisfysRequirements() -> Bool {
        return (gameViewModel.roles.contains(.PitchLocation) ? eventViewModel.pitchEventInfo?.pitchLocations != nil && eventViewModel.pitchEventInfo?.selectedPitchThrown != nil: true) &&
                    (gameViewModel.roles.contains(.PitchOutcome) ?
                    eventViewModel.pitchEventInfo?.selectedPitchOutcome != nil && (eventViewModel.pitchEventInfo?.selectedPitchOutcome == .BIP ? eventViewModel.pitchEventInfo?.selectedBIPType != nil && eventViewModel.pitchEventInfo?.selectedBIPHit != [] : true) : true)
    }
//    func satisfyRequirements() -> Bool {
//        return eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.HR) ?? false ?
//            false : eventViewModel.playersInvolved == []
//    }
    
//    func generateErrorButtons() -> [ActionOption] {
//        var buttons : [ActionOption] = []
//        for player in eventViewModel.playersInvolved {
//            let button = ActionOption(message: "\(player.member.lastName) - \(player.positionInGame.getPositionString())") {
//                eventViewModel.playerWhoCommittedError.append(PlayerErrorInfo(fielderInvolved: player, type: .FieldingError))
//            }
//            buttons.append(button)
//        }
//        return buttons
//    }
}
