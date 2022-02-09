// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct TeamMemberView: View {
    
   // @EnvironmentObject var teamViewModel : TeamViewModel
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    
    //@State var mongoDB: MongoDBViewModel = MongoDBViewModel()
    
    var body: some View {
        if let teamIndex = seasonViewModel.currentTeamIndex, let seasonIndex = seasonViewModel.currentSeasonIndex {
            VStack {
                List {
                    ForEach(seasonViewModel.seasons[seasonIndex].teams[teamIndex].members ?? []) { member in
                        NavigationLink(destination: MemberView(member: member, teamPrimaryColor: Color.black)) {
                            Text(member.getFullName())
                                .padding()
                                .frame(maxWidth: .infinity)
                                .border(Color.black)
                        }
                    }
                }
                    .navigationBarTitle(Text("Members"))
                Button(action: {
                    //  mongoDB.loginUser { (user) in
//                        print("YAY!")
//                    let oldSeason = seasonViewModel.seasons[seasonIndex]
//                    let realmS = RealmSeason()
//                    realmS.name = oldSeason.seasonName
//                    realmS.year = oldSeason.seasonYear
//                    realmS._id = oldSeason.seasonID
//                    realmS._partitionKey = MongoDBKeys.corePartitionKey
//
//                    for team in seasonViewModel.seasons[seasonIndex].teams {
//                        var roster: RealmSwift.List<RealmSeasonTeamRosterMember> = List()
//                        for member in team.members {
//                            let newRealmMember = RealmMember()
//                            newRealmMember.bio = member.bio
//                            newRealmMember.firstName = member.firstName
//                            newRealmMember.height = member.height
//                            newRealmMember.highSchool = member.highSchool
//                            newRealmMember.hittingHand = member.hittingHand.rawValue
//                            newRealmMember.homeTown = member.hometown
//                            newRealmMember.lastName = member.lastName
//                            newRealmMember.nickName = member.nickName
//                            let convertedPos: RealmSwift.List<Int> = List()
//                            for pos in member.positions
//                            {
//                                convertedPos.append(pos.rawValue)
//                            }
//                            newRealmMember.positions = convertedPos
//                            newRealmMember.role = member.role.rawValue
//                            newRealmMember.throwingHand = member.throwingHand.rawValue
//                            newRealmMember.weight = member.weight
//                            newRealmMember._id = member.memberID
//                            newRealmMember._partitionKey = "BaseballCoreData"
//
//                            let realmRoster = RealmSeasonTeamRosterMember()
//                            realmRoster.member = newRealmMember
//                            realmRoster.isRedshirt = member.isRedshirt
//                            realmRoster.playerClass = member.playerClass.rawValue
//                            realmRoster.uniformNumber = member.playerClass.rawValue
//                            roster.append(realmRoster)
//
//                            mongoDB.writer.save(objectsToSave: [newRealmMember, realmRoster])
//                        }
//                        let teamConv = RealmTeam()
//                        let oldTeam = team
//                        teamConv.cityLocation = oldTeam.cityLocation
//                        teamConv.conference = oldTeam.conference.rawValue
//                        teamConv.stateLocation = oldTeam.stateLocation
//                        teamConv.teamAbbr = oldTeam.teamAbbr
//                        teamConv.teamLevel = oldTeam.teamType.rawValue
//                        teamConv.teamName = oldTeam.teamName
//                        teamConv.teamNickname = oldTeam.teamNickname
//                        teamConv._id = oldTeam.teamID
//                        teamConv._partitionKey = MongoDBKeys.corePartitionKey
//                        let realmSeason = RealmSeasonTeam()
//                        realmSeason.roster = roster
//                        realmSeason.team = teamConv
//                        realmS.teams.append(realmSeason)
//                        mongoDB.writer.save(objectsToSave: [realmSeason])
//
//                    }
//                    mongoDB.writer.save(objectsToSave: [realmS])
                            //}
                }, label: {
                    Text("Convert to MongoDB")
                })
            }
            
        }
    }
}
