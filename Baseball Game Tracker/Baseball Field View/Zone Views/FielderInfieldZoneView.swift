// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FielderInfieldZoneView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZoneView(location: .DeepFirstBase, widthModifier: 0.75, heightModidfer: 0.55)
                .environmentObject(eventViewModel)
            ZoneView(location: .Pitcher, widthModifier: 0.5, heightModidfer: 0.67)
                .environmentObject(eventViewModel)
            Group {
                ZoneView(location: .Catcher, widthModifier: 0.5, heightModidfer: 0.95)
                    .environmentObject(eventViewModel)
                ZoneView(location: .CatcherFair, widthModifier: 0.5, heightModidfer: 0.81)
                    .environmentObject(eventViewModel)
            }
            Group {
                ZoneView(location: .ThirdBase, widthModifier: 0.36, heightModidfer: 0.63)
                    .environmentObject(eventViewModel)
                ZoneView(location: .DeepThirdBase, widthModifier: 0.25, heightModidfer: 0.55)
                    .environmentObject(eventViewModel)
                ZoneView(location: .ShallowThirdBase, widthModifier: 0.415, heightModidfer: 0.75)
                    .environmentObject(eventViewModel)
            }
            Group {
                ZoneView(location: .DeepShortStop, widthModifier: 0.35, heightModidfer: 0.45)
                    .environmentObject(eventViewModel)
                ZoneView(location: .ShortStop, widthModifier: 0.415, heightModidfer: 0.55)
                    .environmentObject(eventViewModel)
            }
            Group {
                ZoneView(location: .DeepUpTheMiddle, widthModifier: 0.5, heightModidfer: 0.4)
                    .environmentObject(eventViewModel)
                ZoneView(location: .UpTheMiddle, widthModifier: 0.5, heightModidfer: 0.535)
                    .environmentObject(eventViewModel)
            }
            Group {
                ZoneView(location: .DeepSecondBase, widthModifier: 0.65, heightModidfer: 0.45)
                    .environmentObject(eventViewModel)
                ZoneView(location: .SecondBase, widthModifier: 1-0.415, heightModidfer: 0.55)
                    .environmentObject(eventViewModel)
            }
            Group {
                ZoneView(location: .DeepFirstBase, widthModifier: 0.75, heightModidfer: 0.55)
                    .environmentObject(eventViewModel)
                ZoneView(location: .ShallowFirstBase, widthModifier: 1-0.415, heightModidfer: 0.75)
                    .environmentObject(eventViewModel)
                ZoneView(location: .FirstBase, widthModifier: 1-0.36, heightModidfer: 0.63)
                    .environmentObject(eventViewModel)
            }
            Group {
                ZoneView(location: .ThirdShortStop, widthModifier: 0.3, heightModidfer: 0.5)
                    .environmentObject(eventViewModel)
                ZoneView(location: .ShortStopMiddle, widthModifier: 0.42, heightModidfer: 0.41)
                    .environmentObject(eventViewModel)
                ZoneView(location: .MiddleSecond, widthModifier: 1-0.42, heightModidfer: 0.41)
                    .environmentObject(eventViewModel)
                ZoneView(location: .SecondFirst, widthModifier: 1-0.3, heightModidfer: 0.5)
                    .environmentObject(eventViewModel)
            }
        }
    }
}

struct FielderInfieldZoneView_Previews: PreviewProvider {
    static var previews: some View {
        FielderInfieldZoneView()
    }
}
