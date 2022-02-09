// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct TeamMemberAssignmentView: View {
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var teamViewModel : TeamViewModel
    @EnvironmentObject var seasonViewModel : SeasonViewModel

    @State var selectedMemberNumber : Double = 23.0
    
    var body: some View {
        VStack {
            List {
                ForEach(teamViewModel.membersToAdd) { member in
                    HStack {
                        Text(member.getFullName())
                            .frame(maxWidth: .infinity)
                        Text("Number: \(Int(member.uniformNumber))")
                            .frame(maxWidth: .infinity)
                        Text("Class: \(member.playerClass.getString())")
                            .frame(maxWidth: .infinity)
                        Text("\(member.isRedshirt ? "Redshirt" : "Not Redshirt")")
                            .frame(maxWidth: .infinity)
                    }.onTapGesture {
                        if teamViewModel.selectedMember == member {
                            teamViewModel.selectedMember = nil
                        } else {
                            teamViewModel.selectedMember = member
                            selectedMemberNumber = Double(member.uniformNumber)
                        }
                    }
                    if teamViewModel.selectedMember == member {
                        VStack {
                            Slider(value: Binding(get: {self.selectedMemberNumber}, set: { (newVal) in
                                self.selectedMemberNumber = newVal
                                teamViewModel.selectedMember?.uniformNumber = Int(newVal)
                                if let index = teamViewModel.membersToAdd.firstIndex(of: teamViewModel.selectedMember!) {
                                    teamViewModel.membersToAdd[index].uniformNumber = Int(newVal)
                                }
                            }), in: 0...150, step: 1)
                            
                        }
                        SelectMemberPlayerClassView(member: member)
                            .environmentObject(teamViewModel)
                        RedShirtSelectionView(member: member)
                            .environmentObject(teamViewModel)
                    }
                }
            }
            Button(action: {
                teamViewModel.submitNewTeamToSeason()
                seasonViewModel.seasons.append(teamViewModel.addingToSeason!)
                presentation.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .border(Color.blue)
            })
            .navigationBarTitle(Text("Member Assignment"))
        }
    }
}

struct SelectMemberPlayerClassView : View {
    
    @EnvironmentObject var teamViewModel : TeamViewModel

    var member : Member
    
    var body: some View {
        HStack {
            ForEach(PlayerClass.allCases, id: \.self) { currentClass in
                Text(currentClass.getString())
                    .padding()
                    .border(member.playerClass == currentClass ? Color.blue : Color.black, width: 3)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if let index = teamViewModel.membersToAdd.firstIndex(of: teamViewModel.selectedMember!) {
                            teamViewModel.membersToAdd[index].playerClass = currentClass
                        }
                    }
            }
        }
    }
}

struct RedShirtSelectionView : View {
    
    @EnvironmentObject var teamViewModel : TeamViewModel
    
    var member : Member
    
    var body: some View {
        HStack {
            Text("Redshirt")
                .padding()
                .frame(maxWidth: .infinity)
                .border(member.isRedshirt ? Color.blue : Color.black, width: 3)
                .onTapGesture {
                    if let index = teamViewModel.membersToAdd.firstIndex(of: member) {
                        teamViewModel.membersToAdd[index].isRedshirt = true
                    }
                }
            Text("Not Redshirt")
                .padding()
                .frame(maxWidth: .infinity)
                .border(member.isRedshirt ? Color.black : Color.blue, width: 3).onTapGesture {
                    if let index = teamViewModel.membersToAdd.firstIndex(of: member) {
                        teamViewModel.membersToAdd[index].isRedshirt = false
                    }
                }
        }
    }
}
