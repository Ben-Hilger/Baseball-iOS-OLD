// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SingleSelectCell: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var type : PitchOutcome
    var changePitch : PitchType?
    
    var body: some View {
        HStack {
            Text(type.getPitchOutcomeString())
                .font(.system(size: 10))
            Spacer()
            Image(systemName: eventViewModel.pitchEventInfo?.selectedPitchOutcome == type ? "checkmark.square" : "square")
        }.contentShape(Rectangle()).onTapGesture {
            if let pitch = eventViewModel.pitchEventInfo?.selectedPitchOutcome, pitch == type {
                eventViewModel.pitchEventInfo?.selectedPitchOutcome = nil
                return
            }
            eventViewModel.pitchEventInfo?.selectedPitchOutcome = type
            if let changePitch = changePitch {
                eventViewModel.pitchEventInfo?.selectedPitchThrown = changePitch
            }
        }
    }
}
