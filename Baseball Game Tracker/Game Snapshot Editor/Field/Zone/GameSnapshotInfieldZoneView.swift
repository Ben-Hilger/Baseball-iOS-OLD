// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameSnapshotInfieldZoneView: View {
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var gameSnapshotViewModel : GameSnapshotViewModel
    
    var body: some View {
        GeometryReader { geometry in
            GameSnapshotZoneView(location: .DeepFirstBase, widthModifier: 0.75, heightModidfer: 0.55)
                .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            GameSnapshotZoneView(location: .Pitcher, widthModifier: 0.5, heightModidfer: 0.67)
                .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            Group {
                GameSnapshotZoneView(location: .Catcher, widthModifier: 0.5, heightModidfer: 0.95)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .CatcherFair, widthModifier: 0.5, heightModidfer: 0.81)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
            Group {
                GameSnapshotZoneView(location: .ThirdBase, widthModifier: 0.36, heightModidfer: 0.63)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .DeepThirdBase, widthModifier: 0.25, heightModidfer: 0.55)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .ShallowThirdBase, widthModifier: 0.415, heightModidfer: 0.75)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
            Group {
                GameSnapshotZoneView(location: .DeepShortStop, widthModifier: 0.35, heightModidfer: 0.45)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .ShortStop, widthModifier: 0.415, heightModidfer: 0.55)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
            Group {
                GameSnapshotZoneView(location: .DeepUpTheMiddle, widthModifier: 0.5, heightModidfer: 0.4)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .UpTheMiddle, widthModifier: 0.5, heightModidfer: 0.535)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
            Group {
                GameSnapshotZoneView(location: .DeepSecondBase, widthModifier: 0.65, heightModidfer: 0.45)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .SecondBase, widthModifier: 1-0.415, heightModidfer: 0.55)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
            Group {
                GameSnapshotZoneView(location: .DeepFirstBase, widthModifier: 0.75, heightModidfer: 0.55)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .ShallowFirstBase, widthModifier: 1-0.415, heightModidfer: 0.75)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .FirstBase, widthModifier: 1-0.36, heightModidfer: 0.63)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
            Group {
                GameSnapshotZoneView(location: .ThirdShortStop, widthModifier: 0.3, heightModidfer: 0.5)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .ShortStopMiddle, widthModifier: 0.42, heightModidfer: 0.41)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .MiddleSecond, widthModifier: 1-0.42, heightModidfer: 0.41)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
                GameSnapshotZoneView(location: .SecondFirst, widthModifier: 1-0.3, heightModidfer: 0.5)
                    .environmentObject(gameViewModel).environmentObject(gameSnapshotViewModel)
            }
        }
    }
}

struct GameSnapshotInfieldZoneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSnapshotInfieldZoneView()
    }
}
