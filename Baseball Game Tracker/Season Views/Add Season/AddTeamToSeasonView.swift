// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct AddTeamToSeasonView: View {
    
    @EnvironmentObject var teamViewModel : TeamViewModel
    @EnvironmentObject var seasonViewModel : SeasonViewModel
        
    @State var state : Int? = 0
    
    var body: some View {
        VStack {
            Text("Add Teams to Season")
                .padding()
                .border(Color.black, width: 3)
            List {
                ForEach(teamViewModel.allTeams) { team in
                    HStack {
                        Text(team.teamName)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName : teamViewModel.teamSelected == team ? "checkmark.square" : "square")
                    }.onTapGesture {
                        if teamViewModel.teamSelected == team {
                            teamViewModel.teamSelected = nil
                        } else {
                            teamViewModel.teamSelected = team
                        }
                    }
                }
            }
            Button(action: {
                teamViewModel.loadPlayers()
                self.state = 1
            }, label: {
                Text("Next")
                    .padding()
                    .border(Color.blue, width: 3)
            })
            NavigationLink(
                destination: TeamMemberSelectionView()
                    .environmentObject(seasonViewModel)
                    .environmentObject(teamViewModel),
                tag: 1,
                selection: $state,
                label: {
                    EmptyView()
                })
            .navigationBarTitle("").navigationBarHidden(true)
        }
    }
}

struct AddTeamToSeasonView_Previews: PreviewProvider {
    static var previews: some View {
        AddTeamToSeasonView()
    }
}
