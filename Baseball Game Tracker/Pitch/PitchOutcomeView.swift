// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchOutcomeView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var isViewingBIP : Bool = false
    
    var body: some View {
    
                NavigationView {
                    VStack {
                        Text("Pitch Outcome")
                            .padding()
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15))
                        List {
                            SingleSelectCell(type: .StrikeCalled)
                                .environmentObject(eventViewModel)
                            SingleSelectCell(type: .StrikeSwingMiss)
                                .environmentObject(eventViewModel)
                        
                            //MultiSelectView(types: [.StrikeCalled, .StrikeSwingMiss], mainText: "Strike")
                            //    .environmentObject(eventViewModel)
                            SingleSelectCell(type: .Ball)
                                .environmentObject(eventViewModel)
                            Section {
                                SingleSelectCell(type: .FoulBall)
                                    .environmentObject(eventViewModel)
                                SingleSelectCell(type: .FoulBallDropped)
                                    .environmentObject(eventViewModel)
                            }
                            NavigationLink(destination : BIPTypeView()
                                            .environmentObject(eventViewModel)) {
                                Text("Ball In Play")
                                    .font(.system(size: 10))
                            }
                            MultiSelectView(types: [.PassedBallStrikeSwinging, .PassedBallStrikeLooking, .BallPassedBall], mainText: "Passed Ball")                            .environmentObject(eventViewModel)
                            MultiSelectView(types: [.WildPitchStrikeSwinging, .WildPitchStrikeLooking, .BallWildPitch], mainText: "Wild Pitch")
                                .environmentObject(eventViewModel)
                            if gameViewModel.getCurrentStrikes() == 2 && gameViewModel.getPlayerOnBase(base: .First) == nil {
                                MultiSelectView(types: [.DroppedThirdSwingingSafePassedBall, .DroppedThirdLookingSafePassedBall,
                                                        .DroppedThirdSwingingSafe, .DroppedThirdLookingSafe,
                                                        .DroppedThirdSwingingOut, .DroppedThirdLookingOut], mainText: "Drop Third")
                                    .environmentObject(eventViewModel)
                            }
                            Section {
                                SingleSelectCell(type: .HBP)
                                    .environmentObject(eventViewModel)
                                SingleSelectCell(type: .Balk, changePitch: .None)
                                    .environmentObject(eventViewModel)
                            }
                            Section {
                                SingleSelectCell(type: .IntentionalBall, changePitch: .None)
                                    .environmentObject(eventViewModel)
                                MultiSelectView(types: [.CatcherInter, .BatterInter], mainText: "Interference")
                                    .environmentObject(eventViewModel)
                                SingleSelectCell(type: .IllegalPitch, changePitch: .None)
                                    .environmentObject(eventViewModel)
                                MultiSelectView(types: [.PitchOutLooking, .PitchOutSwinging, .PitchOutBall], mainText: "Pitch Out")
                            }
                            
                        }.border(Color.black, width: 1)
                    }.border(Color.black, width: 1)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
                }.navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .border(Color.black, width: 1)
        }
    
    }

