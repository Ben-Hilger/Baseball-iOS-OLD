// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SeasonTabView: View {
    
    //var season : Season? = SeasonManager.instance().getCurrentSeason()
    
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    //@EnvironmentObject var teamViewModel : TeamViewModel
    
    var body: some View {
        TabView {
            SeasonTeamView()
                .environmentObject(seasonViewModel)
                .tabItem { Text("Teams") }
            
            SeasonGameView()
                .environmentObject(seasonViewModel)
                 .tabItem { Text("Games") }
            SeasonSeriesView()
                .environmentObject(seasonViewModel)
                .tabItem { Text("Series") }
            
        }.navigationBarTitle("\(seasonViewModel.seasons[seasonViewModel.currentSeasonIndex ?? 0].getFullSeasonName())",
                             displayMode: .inline)
    }
}

struct SeasonTabView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonTabView()
    }
}

struct SeasonSeriesView: View {
    
    @EnvironmentObject var seasonViewModel: SeasonViewModel
    
    @State var state: Int?
    
    var body: some View {
        VStack {
            Text("Series")
                .padding()
            List {
                ForEach(seasonViewModel.series) { series in
                    HStack {
                        Button {
                            self.state = seasonViewModel.series.firstIndex(of: series) ?? 1
                        } label: {
                            Text("\(series.name)")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        NavigationLink(
                            destination: SeriesTabView(seriesViewing: series)
                                .environmentObject(seasonViewModel),
                            tag: seasonViewModel.series.firstIndex(of: series) ?? 1,
                            selection: $state,
                            label: {
                                EmptyView()
                            })
                    }
                }
            }
        }
    }
}
