// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct StrikeZoneView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var mainZoneWidth : CGFloat = 60
    var mainZoneHeight : CGFloat = 100
    
    var outZoneWidth : CGFloat = 60
    var outZoneHeight : CGFloat = 50
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopLeftCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopLeft,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopMiddle,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopRight,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopRightCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                }
                HStack {
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutLeftTop,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.TopLeft,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.TopMiddle,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.TopRight,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutRightTop,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                }
                HStack {
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutLeftMiddle,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.MiddleLeft,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.Middle,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.MiddleRight,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutRightMiddle,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                }
                HStack {
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutLeftLow,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.LowLeft,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.LowMiddle,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.LowRight,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutRightLow,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                }
                HStack {
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomLeftCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomLeft,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomMiddle,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomRight,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                    StrikeZoneElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomRightCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                }
            }.background(Color.black).border(Color.black, width: 2)
            .padding()
        }
    }
}
