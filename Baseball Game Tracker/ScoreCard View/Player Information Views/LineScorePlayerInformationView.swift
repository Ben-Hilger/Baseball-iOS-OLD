// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineScorePlayerInformationView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @State var viewSheet : Bool = false
    @State var viewActionSheet : Bool = false
    
    @State var playerViewing : LineScorePlayerInformationViewing = .Pitcher
    
    var body: some View {
        GeometryReader { geometry in
            PitcherInformationView()
                .environmentObject(gameViewModel)
            HitterInformationView()
                .environmentObject(gameViewModel)
        }
    }
}

enum LineScorePlayerInformationViewing {
    case Pitcher
    case Hitter
}
