// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct ZoneView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var location : BallFieldLocation
    
    var widthModifier : CGFloat
    var heightModidfer : CGFloat
    
    var body: some View {
        GeometryReader { (geometry) in
            Text("\(location.getShortDescription())")
                .position(x: geometry.size.width * widthModifier, y: geometry.size.height * heightModidfer)
                .foregroundColor(eventViewModel.pitchEventInfo?.ballLocation == location ? Color.yellow : location.rawValue >= 5 ? Color.white : Color.black).onTapGesture {
                    if let position = eventViewModel.pitchEventInfo?.ballLocation, position == location {
                        eventViewModel.pitchEventInfo?.ballLocation = nil
                    } else {
                        eventViewModel.pitchEventInfo?.ballLocation = location
                    }
                    eventViewModel.objectWillChange.send()
                }
        }
    }
}

struct ZoneView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneView(location: .CenterField, widthModifier: 0.5, heightModidfer: 0.5)
    }
}
