// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct BIPTypeView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var body: some View {
        VStack {
            List {
                SingleSelectViewBIPType(type: .GB)
                    .environmentObject(eventViewModel)
                SingleSelectViewBIPType(type: .HGB)
                    .environmentObject(eventViewModel)
                SingleSelectViewBIPType(type: .FlyBall)
                    .environmentObject(eventViewModel)
                SingleSelectViewBIPType(type: .LineDrive)
                    .environmentObject(eventViewModel)
                SingleSelectViewBIPType(type: .PopFly)
                    .environmentObject(eventViewModel)
                SingleSelectViewBIPType(type: .Bunt)
                    .environmentObject(eventViewModel)
                SingleSelectViewBIPType(type: .Flare)
                    .environmentObject(eventViewModel)
            }
            .navigationBarTitle("BIP Type")
        }
    }
}

struct BIPTypeView_Previews: PreviewProvider {
    static var previews: some View {
        BIPTypeView()
    }
}
