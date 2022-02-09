// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineupEditTabView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    var lineupChangeState : LineupChangeState = .Normal
    
    var body: some View {
        VStack {
            TabView {
                LineupEditView(editingAwayTeam: true)
                    .environmentObject(lineupViewModel)
                    .tabItem {
                        Text("Away Team")
                    }
                LineupEditView(editingAwayTeam: false)
                    .environmentObject(lineupViewModel)
                    .tabItem {
                        Text("Home Team")
                    }
            }.onDisappear {
                gameViewModel.submitLineupChange(
                    forLineupViewModel: lineupViewModel)
                lineupViewModel.objectWillChange.send()
            }
        }
    }
}

enum LineupChangeState {
    case Normal
    case GameCreate
}
