// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SingleSelectViewBIP: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var type : BIPHit
    
    @State var extraToAdd : [BIPHit] = []
        
    var body: some View {
        HStack {
            Text(type.getBIPHitString())
                .font(.system(size: 10))
            Spacer()
            Image(systemName: eventViewModel.pitchEventInfo?.selectedBIPHit.contains(type) ?? false ? "checkmark.square" : "square")
        }.contentShape(Rectangle()).onTapGesture {
            toggleEventViewModel()
        }
    }
    
    func toggleEventViewModel() {
        // Check if this option is currently selected
        if extraToAdd.count == 1 && extraToAdd[0] == type ? false : eventViewModel.pitchEventInfo?.selectedBIPHit.contains(type) ?? false {
            // Reset the select BIP hit
            eventViewModel.pitchEventInfo?.selectedBIPHit = []
            return
        }
        // Check if the extra to add is the same as the type
        // Helps ensure it doesn't get added and then removed
        // in the next for loop
        if extraToAdd.count == 1 && extraToAdd[0] == type {
            // Check if the type is within the select BIP hit
            if let index = eventViewModel.pitchEventInfo?.selectedBIPHit
                .firstIndex(of: type) {
                // Remove the type
                eventViewModel.pitchEventInfo?.selectedBIPHit.remove(at: index)
            } else {
                // Add the type
                eventViewModel.pitchEventInfo?.selectedBIPHit.append(type)
            }
            return
        }
        // Reset the selected BIP hit
        eventViewModel.pitchEventInfo?.selectedBIPHit = []
        // Add the type
        eventViewModel.pitchEventInfo?.selectedBIPHit.append(type)
        
        // Add the extra information
        for extra in extraToAdd {
            // Check if the BIP Hit type already exists. This most likely will
            // never be true, but better safe than sorry
            if let index = eventViewModel.pitchEventInfo?.selectedBIPHit
                .firstIndex(of: extra){
                // Remove the BIP Hit type
                eventViewModel.pitchEventInfo?.selectedBIPHit.remove(at: index)
            } else {
                // Add the BIP Hit type
                eventViewModel.pitchEventInfo?.selectedBIPHit.append(extra)
            }
        }
    }
}
