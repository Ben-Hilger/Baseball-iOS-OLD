// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchTendenciesTabView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var pitchTendenciesViewModel: PitchTendenciesViewModel
    
    var body: some View {
        TabView {
            PitchTendenciesLoaderView(position: .Pitcher, team: .Home)
                .environmentObject(gameViewModel)
                .environmentObject(pitchTendenciesViewModel)
                .tabItem { Text("Pitchers") }
        }
    }
}

struct PitchTendenciesTabView_Previews: PreviewProvider {
    static var previews: some View {
        PitchTendenciesTabView()
    }
}
