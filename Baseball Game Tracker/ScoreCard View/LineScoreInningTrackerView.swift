// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineScoreInningTrackerView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                HStack(spacing: 0) {
                    ForEach(0...max(Int(settingsViewModel.numberOfInnings), gameViewModel.currentInningNum/2), id: \.self) { index in
                        InningScoreElementView(index: index)
                            .environmentObject(gameViewModel)
                    }
                }
                HStack(spacing: 0) {
                    ForEach(0..<LiveScoreTotalType.allCases.count, id: \.self) { index in
                        InningSummaryElementView(type: LiveScoreTotalType.allCases[index])
                            .environmentObject(gameViewModel)
                    }
                }
            }.position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.325)
        }
    }
}

struct LineScoreInningTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        LineScoreInningTrackerView()
    }
}
