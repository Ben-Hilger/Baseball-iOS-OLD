// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct TeamMemberSelectionView: View {
    
    @EnvironmentObject var teamViewModel : TeamViewModel
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    
    @State var currentTeam : Int = 0
    
    @State var state : Int? = 0
    
    var body: some View {
        VStack {
            if let team = teamViewModel.teamSelected {
                List {
                    ForEach(teamViewModel.selectedMembers) { member in
                        HStack {
                            Text(member.getFullName())
                            Spacer()
                            Image(systemName: teamViewModel.membersToAdd.contains(member) ? "checkmark.square" : "square")
                        }.onTapGesture {
                            if let index = teamViewModel.membersToAdd.firstIndex(of: member) {
                                teamViewModel.membersToAdd.remove(at: index)
                            } else {
                                teamViewModel.membersToAdd.append(member)
                            }
                        }
                    }
                }
                Button(action: {
                    self.state = 1
                }, label: {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .border(Color.blue, width: 3)
                })
                NavigationLink(
                    destination: TeamMemberAssignmentView()
                        .environmentObject(seasonViewModel)
                        .environmentObject(teamViewModel),
                    tag: 1,
                    selection: $state,
                    label: {
                        EmptyView()
                    })
                    .navigationBarTitle("Select the Members that will be on the team this season", displayMode: .inline).navigationBarBackButtonHidden(true)
            }
        }
    }
}
