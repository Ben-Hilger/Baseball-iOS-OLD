// Copyright 2021-Present Benjamin Hilger

import Foundation

class TeamViewModel : ObservableObject {
    
    @Published var addingToSeason : Season?
    
    @Published var allTeams : [Team] = []
    
    @Published var teamSelected : Team? = nil
    
    @Published var selectedMembers : [Member] = []
    
    @Published var membersToAdd : [Member] = []
    
    @Published var selectedMember : Member?
    
    @Published var loadedTeams : [Team] = []
    
    init() {
        TeamSaveManagement.loadAllAvailableTeams { (teams) in
            self.allTeams = teams
        }
    }
    
    func loadPlayers() {
        MemberSaveManagement.loadMembers { (members) in
            self.selectedMembers = members
            self.objectWillChange.send()
        }
    }
    
    func loadTeamInformationForCurrentSeason() {
        if let season = addingToSeason, let team = teamSelected {
            MemberSaveManagement.loadMemberTeamInformation(withSeason: season, withTeam: team) { (member) in
                if let index = self.teamSelected?.members.firstIndex(of: member) {
                    self.teamSelected?.members[index] = member
                } else {
                    self.teamSelected?.members.append(member)
                }
                self.teamSelected?.members.sort { (member, member2) -> Bool in
                    member.lastName > member2.lastName
                }
            }
        }
    }
    
    func loadTeamListForCurrentSeason() {
        if let season = addingToSeason {
            TeamSaveManagement.loadTeams(fromSeason: season) { (team) in
                if let index = self.loadedTeams.firstIndex(of: team) {
                    self.loadedTeams[index] = team
                } else {
                    self.loadedTeams.append(team)
                }
            }
        }
    }
    
    func submitNewTeamToSeason() {
        if teamSelected != nil, let addingToSeason = addingToSeason {
            teamSelected?.members = membersToAdd
            addingToSeason.teams.append(teamSelected!)
           // TeamSaveManagement.saveTeam(toSeason: addingToSeason, withTeam: selectedTeams!)
        }
    }
}
