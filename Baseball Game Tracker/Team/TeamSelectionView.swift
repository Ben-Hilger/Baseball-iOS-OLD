// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct TeamSelectionView: View {
    
    @EnvironmentObject var teamViewModel : TeamViewModel
    
    @State var state : Int?
    
    var body: some View {
        VStack {
            HStack {
                Text("Team Selection")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 25))
                Button {
                    teamViewModel.teamSelected = Team(teamID: "", teamName: "", teamAbbr: "", teamNickname: "", city: "", state: "", conference: 0, type: 0, colorPrimary: Color.red, colorSecondary: Color.red)
                } label: {
                    Image(systemName: "plus.rectangle.fill")
                        .font(.system(size: 25))
                        .frame(alignment: .leading)
                }
            }
            
            List {
                ForEach(teamViewModel.allTeams) { team in
                    HStack {
                        Text("\(team.teamName)")
                        NavigationLink(
                            destination: TeamView()
                                .environmentObject(teamViewModel),
                            tag: teamViewModel.allTeams.firstIndex(of: team) ?? 0,
                            selection: $state,
                            label: {
                                EmptyView()
                            })
                    }.onTapGesture {
                        teamViewModel.teamSelected = team
                        self.state = teamViewModel.allTeams.firstIndex(of: team) ?? 0
                    }
                }
            }.padding()
        }
    }
}
