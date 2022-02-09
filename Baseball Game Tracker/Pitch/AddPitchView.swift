// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct AddPitchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    @State var pitchVelo : String = ""
    @State var exitVelo : String = ""
    
    @Binding var savedPitchData: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if gameViewModel.roles.contains(.PitchLocation) {
                        VStack {
                            Text("Total Pitches in Game: \(gameViewModel.getNumberOfPitches() + 1)").padding()
                            HStack {
                                VStack {
                                    Text("Pitch Velocity:")
                                    TextField("Pitch Velocity", text: $pitchVelo)
                                        .padding()
                                        .border(Color.black, width: 1)
                                        .keyboardType(.numberPad)
                                }
                                VStack {
                                    Text("Hitter Exit Velo:")
                                    TextField("Hitter Exit Velo", text: $exitVelo)
                                        .padding()
                                        .border(Color.black, width: 1)
                                        .keyboardType(.numberPad)
                                }
                            }
                            StrikeZoneView()
                                .environmentObject(gameViewModel)
                                .environmentObject(eventViewModel)
                        }
                        PitchThrownView()
                            .environmentObject(eventViewModel)
                    }
                    if gameViewModel.roles.contains(.PitchOutcome) {
                        PitchOutcomeView()
                            .environmentObject(gameViewModel)
                            .environmentObject(eventViewModel)
                    }
                }
                HStack {
                    Button(action: {
                        if satisfysRequirements() {
                            
                            if let velo = Float(pitchVelo) {
                                eventViewModel.pitchEventInfo?.pitchVelo = velo
                            }
                            if let exitVelo = Float(exitVelo) {
                                eventViewModel.pitchEventInfo?.exitVelo = exitVelo
                            }
                            eventViewModel.isAddingPitch = true
                            if isBallInPlay() {
                                gameViewModel.fieldEditingMode = .Zone
                            } else {
                                gameViewModel.addEvent(eventViewModel: eventViewModel)
                                eventViewModel.reset()
                            }
                            self.savedPitchData = true
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text(satisfysRequirements() ? isBallInPlay() ? "Next" : "Add Pitch" : "Please select all required parts before adding a new pitch!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .border(Color.blue)
                    }).padding().disabled(!satisfysRequirements())
                    .foregroundColor(satisfysRequirements() ? Color.blue : Color.gray)
                    
                    
                }.onAppear {
                    eventViewModel.pitchEventInfo = PitchEventInfo()
                }.onDisappear {
                    if gameViewModel.fieldEditingMode != .Zone {
                        eventViewModel.pitchEventInfo = nil
                    }
                }
                
            }
            .padding()
        }
    }
    
    func satisfysRequirements() -> Bool {
        return (gameViewModel.roles.contains(.PitchLocation) ?
                    (eventViewModel.pitchEventInfo?.pitchLocations != nil &&
                    eventViewModel.pitchEventInfo?.selectedPitchThrown != nil) ||
                    (eventViewModel.pitchEventInfo?.selectedPitchOutcome?.doesntRequireStrikeZone() ?? false): true) &&
                    (gameViewModel.roles.contains(.PitchOutcome) ? 
                    eventViewModel.pitchEventInfo?.selectedPitchOutcome != nil && (eventViewModel.pitchEventInfo?.selectedPitchOutcome == .BIP ? eventViewModel.pitchEventInfo?.selectedBIPType != nil && eventViewModel.pitchEventInfo?.selectedBIPHit != [] : true) : true)
    }
    func isBallInPlay() -> Bool {
        return gameViewModel.roles.contains(.PitchOutcome) && eventViewModel.pitchEventInfo?.selectedPitchOutcome == .BIP
    }
}
//
//struct AddPitchDelegateObserver: UIViewControllerRepresentable {
//
//    var controller = AddPitchViewController()
//    var runOnDismissal : () -> Void
//    func makeUIViewController(context: Context) -> some UIViewController {
//        return controller
//    }
//
////
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(vc: controller, runOnDismissal: runOnDismissal)
//    }
//
//    class Coordinator: UIPresentationController {
//        var runOnDismissal : () -> Void
//        init(vc: AddPitchViewController, runOnDismissal : @escaping () -> Void) {
//            self.runOnDismissal = runOnDismissal
//            super.init(presentedViewController: vc, presenting: vc)
//            vc.delegate = self
//        }
//        override func dismissalTransitionWillBegin() {
//            runOnDismissal()
//        }
//
//
//    }
//
//}
//
//class AddPitchViewController : UIViewController {
//
//    var delegate : UIPresentationController?
//
//    override func viewWillDisappear(_ animated: Bool) {
//        delegate?.dismissalTransitionWillBegin()
//    }
//}
