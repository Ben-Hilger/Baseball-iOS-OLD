// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct BIPView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var body: some View {
        VStack {
            List {
                Group {
                    NavigationLink(destination: List {
                        SingleSelectViewBIP(type: BIPHit.OutAtFirst)
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.DoublePlay)
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.TriplePlay)
                            .environmentObject(eventViewModel)
                            .navigationBarTitle("Out")
                    }) {
                        Text("Out")
                            .font(.system(size: 10))
                    }
                }
                Section {
                    NavigationLink(destination: List {
                        SingleSelectViewBIP(type: BIPHit.FielderChoice)
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.FielderChoiceOut)
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.Error, extraToAdd: [BIPHit.FielderChoice])
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.AdvancedToSecondError, extraToAdd: [BIPHit.FielderChoice])
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.AdvancedToThirdError, extraToAdd: [BIPHit.FielderChoice])
                            .environmentObject(eventViewModel)
                        SingleSelectViewBIP(type: BIPHit.AdvancedHomeError, extraToAdd: [BIPHit.FielderChoice])
                            .environmentObject(eventViewModel)
                            .navigationBarTitle("Fielder's Choice")
                    }) {
                        Text("Fielder's Choice")
                            .font(.system(size: 10))
                    }
//                    MultiSelectViewBIP(types: [.FielderChoice, .FielderChoiceOut, BIPHit.Error, BIPHit.AdvancedToSecondError, BIPHit.AdvancedToThirdError, BIPHit.AdvancedHomeError], mainText: "Fielder's Choice", extraInfo: [.FielderChoice])
//                        .environmentObject(eventViewModel)
                }
                SingleSelectViewBIP(type: BIPHit.Error)
                    .environmentObject(eventViewModel)
                MultiSelectViewBIP(types: [BIPHit.FirstB, BIPHit.AdvancedToSecondError, BIPHit.AdvancedToThirdError, BIPHit.AdvancedHomeError, BIPHit.CaughtAdvancingToSecond], mainText: "Single", extraInfo: [BIPHit.FirstB])
                    .environmentObject(eventViewModel)
                Section {
                    MultiSelectViewBIP(types: [BIPHit.SecondB, BIPHit.AdvancedToThirdError, BIPHit.AdvancedHomeError, BIPHit.CaughtAdvancingToThird], mainText: "Double", extraInfo: [BIPHit.SecondB])
                        .environmentObject(eventViewModel)
                    SingleSelectViewBIP(type: BIPHit.SecondBGroundRule)
                        .environmentObject(eventViewModel)
                }
                MultiSelectViewBIP(types: [BIPHit.ThirdB, BIPHit.AdvancedHomeError, BIPHit.CaughtAdvancingHome], mainText: "Triple", extraInfo : [BIPHit.ThirdB])
                    .environmentObject(eventViewModel)
                Section {
                    SingleSelectViewBIP(type: BIPHit.HR)
                        .environmentObject(eventViewModel)
                    SingleSelectViewBIP(type: BIPHit.HRInPark)
                        .environmentObject(eventViewModel)
                }
                if eventViewModel.pitchEventInfo?.selectedBIPType == BIPType.FlyBall || eventViewModel.pitchEventInfo?.selectedBIPType == BIPType.PopFly || eventViewModel.pitchEventInfo?.selectedBIPType == BIPType.LineDrive {
                    MultiSelectViewBIP(types: [.SacFly, .SacFlyError], mainText: "Sac Fly")
                        .environmentObject(eventViewModel)
                }
            }
           .navigationBarTitle(eventViewModel.pitchEventInfo?.selectedBIPType?.getBIPTypeString() ?? "Ball In Play")
        }
    }
}
