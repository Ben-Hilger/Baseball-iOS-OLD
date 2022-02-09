// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SingleSelectViewBIPType: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var type : BIPType
    
    @State var state : Int? = 0
    
    var body: some View {
        HStack {
            Text(type.getBIPTypeString())
                .font(.system(size: 10))
            Spacer()
            NavigationLink(destination: BIPView().environmentObject(eventViewModel), tag: 1, selection: $state) {
                EmptyView()
            }
        }.contentShape(Rectangle()).onTapGesture {
            eventViewModel.pitchEventInfo?.selectedPitchOutcome = .BIP
            eventViewModel.pitchEventInfo?.selectedBIPType = type
            self.state = 1
        }
    }
}

struct SingleSelectViewBIPType_Previews: PreviewProvider {
    static var previews: some View {
        SingleSelectViewBIPType(type: .GB)
    }
}
