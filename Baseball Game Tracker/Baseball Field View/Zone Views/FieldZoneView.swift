// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FieldZoneView: View {

    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var isPresentingPlayerField : Bool = false
    
    var body: some View {
        VStack {
            Text("Please select the zone the ball landed in").padding().border(Color.black, width: 1)
            ZStack {
                GeometryReader { (geometry) in
                    Image("baseball-field")
                        .resizable()
                    Group {
                        ZoneView(location: .HRLeftField, widthModifier: 0.08, heightModidfer: 0.22)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .HRLeftCenterField, widthModifier: 0.27, heightModidfer: 0.05)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .HRCenterField, widthModifier: 0.5, heightModidfer: -0.005)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .HRRightCenterField, widthModifier: 1-0.27, heightModidfer: 0.05)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .HRRightField, widthModifier: 1-0.08, heightModidfer: 0.22)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        ZoneView(location: .DeepLeftField, widthModifier: 0.13, heightModidfer: 0.29)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .LeftField, widthModifier: 0.18, heightModidfer: 0.36)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowLeftField, widthModifier: 0.23, heightModidfer: 0.43)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        ZoneView(location: .DeepLeftCenterField, widthModifier: 0.295, heightModidfer: 0.13)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .LeftCenterField, widthModifier: 0.33, heightModidfer: 0.23)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowLeftCenterField, widthModifier: 0.365, heightModidfer: 0.33)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        ZoneView(location: .DeepCenterField, widthModifier: 0.5, heightModidfer: 0.07)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .CenterField, widthModifier: 0.5, heightModidfer: 0.18)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowCenterField, widthModifier: 0.5, heightModidfer: 0.31)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        ZoneView(location: .DeepRightCenterField, widthModifier: 1-0.295, heightModidfer: 0.13)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .RightCenterField, widthModifier: 1-0.33, heightModidfer: 0.23)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowRightCenterField, widthModifier: 1-0.365, heightModidfer: 0.33)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        ZoneView(location: .DeepRightField, widthModifier: 1-0.13, heightModidfer: 0.29)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .RightField, widthModifier: 1-0.18, heightModidfer: 0.36)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowRightField, widthModifier: 1-0.23, heightModidfer: 0.43)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        FielderInfieldZoneView()
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        ZoneView(location: .DeepThirdBaseFoul, widthModifier: 0.105, heightModidfer: 0.45)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowThirdBaseFoul, widthModifier: 0.3075, heightModidfer: 0.7)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .DeepFirstBaseFoul, widthModifier: 1-0.105, heightModidfer: 0.45)
                            .environmentObject(eventViewModel)
                        ZoneView(location: .ShallowFirstBaseFoul, widthModifier: 1-0.3075, heightModidfer: 0.7)
                            .environmentObject(eventViewModel)
                    }
                    Group {
                        Button {
                            if eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.HR) ?? false {
                                gameViewModel.addEvent(eventViewModel: eventViewModel)
                                eventViewModel.reset()
                                gameViewModel.fieldEditingMode = .Normal
                            } else {
                                gameViewModel.runnerEditingMode = .Pitch
                                gameViewModel.fieldEditingMode = .Normal
                            }
                        } label: {
                            Text("Next")
                                    .padding()
                                    .border(Color.blue)
                        }.disabled(eventViewModel.pitchEventInfo?.ballLocation == nil)
                        .position(x: geometry.size.width * 0.92, y: geometry.size.height * 0.05)
                        
                        Button {
                            eventViewModel.reset()
                            eventViewModel.eventNum -= 1
                            gameViewModel.fieldEditingMode = .Normal
                        } label: {
                            Text("Cancel")
                                .padding()
                                .border(Color.blue)
                        }.disabled(eventViewModel.pitchEventInfo?.ballLocation == nil)
                        .position(x: geometry.size.width * 0.08, y: geometry.size.height * 0.05)
                        Path { (path) in
                            path.move(to: CGPoint(x: geometry.size.width * 0.165, y: geometry.size.height * 0.135))
                            path.addLine(to: CGPoint(x: geometry.size.width * 0.31, y: geometry.size.height * 0.43))
                        }.stroke(Color.red, lineWidth: 2)
                        Path { (path) in
                            path.move(to: CGPoint(x: geometry.size.width * 0.395, y: geometry.size.height * 0.01))
                            path.addLine(to: CGPoint(x: geometry.size.width * 0.4425, y: geometry.size.height * 0.37))
                        }.stroke(Color.red, lineWidth: 2)
                        Path { (path) in
                            path.move(to: CGPoint(x: geometry.size.width * (1-0.165), y: geometry.size.height * 0.135))
                            path.addLine(to: CGPoint(x: geometry.size.width * (1-0.31), y: geometry.size.height * 0.43))
                        }.stroke(Color.red, lineWidth: 2)
                        Path { (path) in
                            path.move(to: CGPoint(x: geometry.size.width * (1-0.395), y: geometry.size.height * 0.01))
                            path.addLine(to: CGPoint(x: geometry.size.width * (1-0.4425), y: geometry.size.height * 0.37))
                        }.stroke(Color.red, lineWidth: 2)
                    }
                    
                }
            }.padding()
        }
    }
}

