// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineScoreView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var isViewingForceEvents : Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            LineScoreStatisticsView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            LineScoreSettingsView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(eventViewModel)
            LineScoreCountTrackerView()
                .environmentObject(gameViewModel)
            LineScoreInningTrackerView()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            LineScorePlayerInformationView()
                .environmentObject(gameViewModel)
                .navigationBarTitle("").navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.25).border(Color.black, width: 1)
    }
}
enum LiveScoreTotalType : CaseIterable {
    case Runs
    case Hits
    case Error
    case LOB
    case EarnedRuns
    
    func getString() -> String {
        switch self {
        case .EarnedRuns:
            return "ER"
        case .LOB:
            return "LOB"
        case .Error:
            return "E"
        case .Hits:
            return "H"
        case .Runs:
            return "R"
        }
    }
}

struct InningScoreElementView : View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var index : Int
    
    var body : some View {
        VStack(spacing: 0) {
            Text("\(index > 0 ? "\(index)" : "Team")")
                    .padding(5)
                    .font(.system(size: 15))
            VStack(spacing: 0) {
                Text("\(index > 0 ? String(gameViewModel.getTotalRunsByInning()[index * 2 - 1] as? Int ?? 0) : gameViewModel.game?.awayTeam.teamNickname ?? "")")
                    .padding(10)
                    .border(gameViewModel.currentInning?.inningNum == index * 2 - 1 ? Color.red : Color.black, width: gameViewModel.currentInning?.inningNum == index * 2 - 1 ? 2 : 1)
                    .background(Color(UIColor.lightGray))
                    .padding(2)
                    .font(.system(size: 17))
                Text("\(index > 0 ? String(gameViewModel.getTotalRunsByInning()[index * 2] as? Int ?? 0) : gameViewModel.game?.homeTeam.teamNickname ?? "")")
                    .padding(10)
                    .border(gameViewModel.currentInning?.inningNum == index * 2 ? Color.red : Color.black, width: gameViewModel.currentInning?.inningNum == index * 2 ? 2 : 1)
                    .background(Color(UIColor.lightGray))
                    .padding(2)
                    .font(.system(size: 17))

            }
        }
    }
}

struct InningSummaryElementView : View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var type : LiveScoreTotalType
    
    var body : some View {
        VStack(spacing: 0) {
            Text("\(type.getString())")
                .padding(5)
                .font(.system(size: 15, weight: .bold))
            VStack(spacing: 0) {
                Text("\(getProperDisplay(forTeam: .Away))")
                    .padding(10)
                    .border(Color.black, width: 1)
                    .background(Color(UIColor.lightGray))
                    .padding(2)
                    .font(.system(size: 17))
                Text("\(getProperDisplay(forTeam: .Home))")
                    .padding(10)
                    .border(Color.black, width: 1)
                    .background(Color(UIColor.lightGray))
                    .padding(2)
                    .font(.system(size: 17))
            }.contentShape(Rectangle())
        }
    }
    
    func getProperDisplay(forTeam team : GameTeamType) -> Int {
        switch type {
        case .EarnedRuns:
            return gameViewModel.getCurrentTeamScoreEarned(forTeam: team)
        case .Error:
            return gameViewModel.getTotalErrors(forTeam: team)
        case .Hits:
            return gameViewModel.getTotalHits(forTeam: team)
        case .LOB:
            return AnalyticsCore.getTotalLOB(fromGameViewModel: gameViewModel, forTeam: team)
        case .Runs:
            return gameViewModel.getCurrentGameScore(forTeam: team)
        }
    }
}
