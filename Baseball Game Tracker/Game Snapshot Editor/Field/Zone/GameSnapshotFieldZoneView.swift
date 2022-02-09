// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotFieldZoneView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    @State var isPresentingPlayerField : Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { (geometry) in
                    Image("baseball-field")
                        .resizable()
                    Group {
                        GameSnapshotZoneView(location: .HRLeftField, widthModifier: 0.08, heightModidfer: 0.22)
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .HRLeftCenterField, widthModifier: 0.27, heightModidfer: 0.05)
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .HRCenterField, widthModifier: 0.5, heightModidfer: -0.005)
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .HRRightCenterField, widthModifier: 1-0.27, heightModidfer: 0.05)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .HRRightField, widthModifier: 1-0.08, heightModidfer: 0.22)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotZoneView(location: .DeepLeftField, widthModifier: 0.13, heightModidfer: 0.29)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .LeftField, widthModifier: 0.18, heightModidfer: 0.36)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowLeftField, widthModifier: 0.23, heightModidfer: 0.43)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotZoneView(location: .DeepLeftCenterField, widthModifier: 0.295, heightModidfer: 0.13)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .LeftCenterField, widthModifier: 0.33, heightModidfer: 0.23)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowLeftCenterField, widthModifier: 0.365, heightModidfer: 0.33)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotZoneView(location: .DeepCenterField, widthModifier: 0.5, heightModidfer: 0.07)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .CenterField, widthModifier: 0.5, heightModidfer: 0.18)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowCenterField, widthModifier: 0.5, heightModidfer: 0.31)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotZoneView(location: .DeepRightCenterField, widthModifier: 1-0.295, heightModidfer: 0.13)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .RightCenterField, widthModifier: 1-0.33, heightModidfer: 0.23)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowRightCenterField, widthModifier: 1-0.365, heightModidfer: 0.33)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotZoneView(location: .DeepRightField, widthModifier: 1-0.13, heightModidfer: 0.29)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .RightField, widthModifier: 1-0.18, heightModidfer: 0.36)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowRightField, widthModifier: 1-0.23, heightModidfer: 0.43)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotInfieldZoneView()
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSnapshotViewModel)
                    }
                    Group {
                        GameSnapshotZoneView(location: .DeepThirdBaseFoul, widthModifier: 0.105, heightModidfer: 0.45)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowThirdBaseFoul, widthModifier: 0.3075, heightModidfer: 0.7)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .DeepFirstBaseFoul, widthModifier: 1-0.105, heightModidfer: 0.45)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                        GameSnapshotZoneView(location: .ShallowFirstBaseFoul, widthModifier: 1-0.3075, heightModidfer: 0.7)
                            .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                    }
                    Group {
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
            }//.padding(.top)
        }
    }
}

