// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct TeamView: View {
    
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    //@EnvironmentObject var teamViewModel : TeamViewModel
    
    @State var editingSelecting : TeamInformationEditing?
    
    var body: some View {
        if let teamIndex = seasonViewModel.currentTeamIndex, let seasonIndex = seasonViewModel.currentSeasonIndex {
            HStack {
                VStack {
                    Text("Team Information")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamPrimaryColor)
                    List {
                        ForEach(0..<TeamInformationEditing.allCases.count, id: \.self) { index in
                            switch TeamInformationEditing.allCases[index] {
                            case .Name:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamName, type: .Name, selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .Name
                                    }
                            case .Nickname:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamNickname, type: .Nickname, selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .Nickname
                                    }
                            case .Abbreviation:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamAbbr, type: .Abbreviation, selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .Abbreviation
                                    }
                            case .Location:
                                TeamInformationCell(info: "\(seasonViewModel.seasons[seasonIndex].teams[teamIndex].cityLocation), \(seasonViewModel.seasons[seasonIndex].teams[teamIndex].stateLocation)", type: .Location, selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .Location
                                    }
                            case .Conference:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].conference.getString(), type: .Conference , selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .Conference
                                    }
                            case .Division:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamType.getString(), type: .Division , selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .Division
                                    }
                            case .teamPrimaryColor:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamPrimaryColor.description, type: .teamPrimaryColor , selectEdit: editingSelecting)
                                    .environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .teamPrimaryColor
                                    }
                            case .teamSecondaryColor:
                                TeamInformationCell(info: seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamSecondaryColor.description, type: .teamSecondaryColor , selectEdit: editingSelecting).environmentObject(seasonViewModel)
                                    .onTapGesture {
                                        editingSelecting = .teamSecondaryColor
                                    }
                            }
                        }
                        NavigationLink(destination: TeamMemberView()) {
                            Text("Members")
                                .padding()
                        }.border(Color.black)

                    }
                    
                }
//                if teamViewModel.addingToSeason != nil {
//                    NavigationView {
//                        VStack {
//                            Text("Members")
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .font(.title)
//                                .background(team.teamPrimaryColor)
//
//                            List {
//                                ForEach(team.members) { member in
//                                    NavigationLink(destination: MemberView(member: member, teamPrimaryColor: team.teamPrimaryColor)) {
//                                        Text(member.getFullName())
//                                    }.padding()
//                                }
//                            }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
//                        }
//                        .navigationBarTitle("").navigationBarHidden(true)
//                    }.navigationViewStyle(StackNavigationViewStyle())
//                }
            }
            Button(action : {
//                if let teamToSave = teamViewModel.teamSelected {
////                    let id = TeamSaveManagement.saveTeam(withTeam: teamToSave)
////                    teamToSave.teamID = id
////                    if let index = teamViewModel.allTeams.firstIndex(of: teamToSave) {
////                        teamViewModel.allTeams[index] = teamToSave
////                    } else {
////                        teamViewModel.allTeams.append(teamToSave)
////                    }
//                }
            }, label : {
                Text("Save Changes")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .border(Color.blue, width: 3)
            })
            .navigationBarTitle(Text(seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamName))
        } else {
            Text("No Team Information")
        }
        
    }
}

struct TeamInformationCell : View {
    
    //@EnvironmentObject var teamViewModel : TeamViewModel
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    
    var info : String
    var type : TeamInformationEditing
    var selectEdit : TeamInformationEditing?
        
    var body : some View {
        VStack {
            HStack {
                Text("\(type.getString()): \(info)")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .border(Color.black)
//            if type == selectEdit, let seasonIndex = seasonViewModel.currentSeasonIndex, let teamIndex = seasonViewModel.currentTeamIndex {
//                switch type {
//                case .Name:
//                    TextField("Team Name", text: Binding(get: {
//                        seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamName
//                    }, set: { (newVal) in
//                        seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamName = newVal
//                    }))
//                case .Nickname:
//                    TextField("Team Nickname", text: Binding(get: {
//                        seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamNickname
//                    }, set: { (newVal) in
//                        seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamNickname = newVal
//                    }))
//                case .Abbreviation:
//                    TextField("Team Abbreviation", text: Binding(get: {
//                        seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamAbbr
//                    }, set: { (newVal) in
//                        seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamAbbr = newVal
//                    }))
//                case .Location:
//                    HStack {
//                        TextField("Team City", text: Binding(get: {
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].cityLocation
//                        }, set: { (newVal) in
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].cityLocation = newVal
//                        }))
//                        TextField("Team State", text: Binding(get: {
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].stateLocation
//                        }, set: { (newVal) in
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].stateLocation = newVal
//                        }))
//                    }
//                case .Conference:
//                    HStack {
//                        ForEach(0..<ConferenceType.allCases.count, id: \.self) { index in
//                            Text(ConferenceType.allCases[index].getString())
//                                .padding()
//                                .border(seasonViewModel.seasons[seasonIndex].teams[teamIndex].conference == ConferenceType.allCases[index] ? Color.blue : Color.black)
//                                .onTapGesture {
//                                    seasonViewModel.seasons[seasonIndex].teams[teamIndex].conference = ConferenceType.allCases[index]
//                                }
//                        }
//                    }
//                case .Division:
//                    HStack {
//                        ForEach(0..<TeamType.allCases.count, id: \.self) { index in
//                            Text(TeamType.allCases[index].getString())
//                                .padding()
//                                .border(seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamType == TeamType.allCases[index] ? Color.blue : Color.black)
//                                .onTapGesture {
//                                    seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamType = TeamType.allCases[index]
//                                }
//                        }
//                    }
//                case .teamPrimaryColor:
//                    HStack {
//                        ColorPicker("Choose your team primary color", selection: Binding(get: {
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamPrimaryColor
//                        }, set: { (newVal) in
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamPrimaryColor = newVal
//                        }))
//                    }
//                case .teamSecondaryColor:
//                    HStack {
//                        ColorPicker("Choose your team secondary color", selection: Binding(get: {
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamSecondaryColor
//                        }, set: { (newVal) in
//                            seasonViewModel.seasons[seasonIndex].teams[teamIndex].teamSecondaryColor = newVal
//                        }))
//                    }
//                }
//            }
        }
    }
}

enum TeamInformationEditing : CaseIterable {
    case Name
    case Nickname
    case Abbreviation
    case Location
    case Conference
    case Division
    case teamPrimaryColor
    case teamSecondaryColor
    
    func getString() -> String {
        switch self {
        case .Name:
            return "Team Name"
        case .Nickname:
            return "Nickname"
        case .Abbreviation:
            return "Abbreviation"
        case .Location:
            return "Location"
        case .Conference:
            return "Conference"
        case .Division:
            return "Division"
        case .teamPrimaryColor:
            return "Team Primary Color"
        case .teamSecondaryColor:
            return "Team Secondary Color"
        }
    }
}
