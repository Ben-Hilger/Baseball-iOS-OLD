// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct StrikeZoneSnapshotEditView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    var mainZoneWidth : CGFloat = 60
    var mainZoneHeight : CGFloat = 100
    
    var outZoneWidth : CGFloat = 60
    var outZoneHeight : CGFloat = 50
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopLeftCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopLeft,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopMiddle,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopRight,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutTopRightCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                }
                HStack {
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutLeftTop,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.TopLeft,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.TopMiddle,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.TopRight,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutRightTop,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                }
                HStack {
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutLeftMiddle,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.MiddleLeft,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.Middle,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.MiddleRight,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutRightMiddle,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                }
                HStack {
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutLeftLow,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.LowLeft,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.LowMiddle,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.LowRight,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutRightLow,
                                          width: outZoneWidth,
                                          height: mainZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                }
                HStack {
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomLeftCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomLeft,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomMiddle,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomRight,
                                          width: mainZoneWidth,
                                          height: outZoneHeight)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                    StrikeZoneSnapshotElementView(pitchLocationsToAdd:
                                            PitchLocation.OutBottomRightCorner,
                                          width: mainZoneWidth,
                                          height: mainZoneHeight/2)
                        .environmentObject(gameViewModel)
                        .environmentObject(gameSnapshotViewModel)
                }
            }.background(Color.black).border(Color.black, width: 2)
            .frame(width: 300, height: 500).padding()
        }
    }
}

