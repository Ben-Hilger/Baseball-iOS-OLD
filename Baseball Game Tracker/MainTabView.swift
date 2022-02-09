// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct MainTabView: View {
    
    @StateObject var seasonViewModel : SeasonViewModel = SeasonViewModel()
    @StateObject var teamViewModel : TeamViewModel = TeamViewModel()
    
    var body: some View {
        TabView {
            SeasonSelectionView()
                .environmentObject(seasonViewModel)
                .environmentObject(teamViewModel)
                .tabItem { Text("Seasons") }
            TeamSelectionView()
                .environmentObject(teamViewModel)
                .tabItem { Text("Teams") }
        }
       .navigationBarTitle("", displayMode: .inline)
    }
}
