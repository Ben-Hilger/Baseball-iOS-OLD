// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SeasonTeamView: View {
    
    @EnvironmentObject var seasonViewModel : SeasonViewModel
   // @EnvironmentObject var teamViewModel : TeamViewModel
    
    @State var state : Int?
    var body: some View {
        if let seasonIndex = seasonViewModel.currentSeasonIndex {
            VStack {
                Text("Teams")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                List {
                    ForEach(seasonViewModel.seasons[seasonIndex].teams) { currentTeam  in
                        HStack {
                            Button(action: {
                                seasonViewModel.setCurrentTeam(teamToSet: currentTeam)
//                                teamViewModel.addingToSeason = season
//                                teamViewModel.teamSelected = currentTeam
//                                teamViewModel.loadTeamInformationForCurrentSeason()
                                self.state = seasonViewModel.seasons[seasonIndex].teams.firstIndex(of: currentTeam) ?? 1
                            }, label: {
                                Text(currentTeam.teamName)
                            })
                            NavigationLink(
                                destination: TeamView()
                                    .environmentObject(seasonViewModel),
                                tag: seasonViewModel.seasons[seasonIndex].teams.firstIndex(of: currentTeam) ?? 1,
                                selection: $state,
                                label: {
                                    EmptyView()
                            })
                        }
                    }
                }.border(Color.black, width: 1)
                
            }.navigationBarTitle(Text("Teams In Season"), displayMode: .inline)
        } else {
            Text("No Season Data To Load")
        }
    }
}
