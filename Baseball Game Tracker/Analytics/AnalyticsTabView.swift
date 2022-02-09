// Copyright 2021-Present Benjamin Hilger


import SwiftUI

struct AnalyticsTabView: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var body: some View {
        TabView {
            AnalyticsFilterView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .tabItem {
                    Text("Analytics Filters")
                }
            AnalyticsView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .tabItem {
                    Text("Statistics")
                }
        }
    }
}

struct AnalyticsTabView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsTabView()
    }
}
