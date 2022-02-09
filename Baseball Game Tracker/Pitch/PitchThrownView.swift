// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchThrownView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var body: some View {
        VStack {
            Text("Pitch Thrown")
                .padding()
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
            List {
                ForEach(0..<PitchType.allCases.count) { index in
//                    HStack {
//                        Text(PitchType.allCases[index].getPitchTypeString())
//                            .font(.system(size: 10))
//                            .padding()
//                            .onTapGesture {
//                                eventViewModel.selectedPitchThrown = PitchType.allCases[index]
//                            }
//                        Spacer()
//                        Image(systemName: eventViewModel.selectedPitchThrown == PitchType.allCases[index] ? "checkmark.square" : "square")
//                    }
                    PitchThrownListView(pitchType: PitchType.allCases[index])
                        .environmentObject(eventViewModel)
                }
            }.border(Color.black, width: 1)
        }.border(Color.black, width: 1)
    }
}

struct PitchThrownListView : View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var pitchType : PitchType
    
    var body: some View {
        HStack {
            Text(pitchType.getPitchTypeString())
                .font(.system(size: 10))
                .padding()
            Spacer()
            Image(systemName: eventViewModel.pitchEventInfo?.selectedPitchThrown == pitchType ? "checkmark.square" : "square")
        }.contentShape(Rectangle()).onTapGesture {
            eventViewModel.pitchEventInfo?.selectedPitchThrown = pitchType
        }
    }
}
