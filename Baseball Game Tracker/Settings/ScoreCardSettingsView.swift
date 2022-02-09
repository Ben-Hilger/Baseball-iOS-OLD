// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct ScoreCardSettingsView: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var body: some View {
        VStack {
            Text("Game Settings")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .border(Color.black, width: 1)
//            ScoreCardSettingHeader(title: "Scorecard View Type", type: .View)
//                .environmentObject(settingsViewModel)
//                .environmentObject(gameViewModel)
//            if settingsViewModel.scoreCardViewSettingsType == .View {
//                List {
//                    ForEach(0..<ScoreCardType.allCases.count, id: \.self) { index in
//                        HStack {
//                            Text("\(ScoreCardType.allCases[index].getString())")
//                                .font(.system(size: 15))
//                            Spacer()
//                            Image(systemName: settingsViewModel.scoreCardViewSettings == ScoreCardType.allCases[index] ? "checkmark.square" : "square")
//                        }.contentShape(Rectangle())
//                        .onTapGesture {
//                            settingsViewModel.scoreCardViewSettings = ScoreCardType.allCases[index]
//                        }
//                    }
//                }
//            }
            ScoreCardSettingHeader(title: "Number of Innings", type: .NumberInnings, hideCollapseWhenSelected: false)
                .environmentObject(settingsViewModel)
                .environmentObject(gameViewModel)
            if settingsViewModel.scoreCardViewSettingsType == .NumberInnings {
                Slider(value: $settingsViewModel.numberOfInnings, in: 1...10, step: 1)
                .padding()
                .accentColor(Color.red)
                .border(Color.black, width: 1)
            }
            ScoreCardSettingHeader(title: "Roles", type: .GameRoles, hideCollapseWhenSelected: false)
                .environmentObject(settingsViewModel)
                .environmentObject(gameViewModel)
            ScoreCardSettingHeader(title: "Hand Mode", type: .HandMode, hideCollapseWhenSelected: false)
                .environmentObject(settingsViewModel)
                .environmentObject(gameViewModel)
            if settingsViewModel.scoreCardViewSettingsType == .HandMode {
                HStack {
                    Button(action: {}, label: {
                        Button(action: {
                            settingsViewModel.handMode = .Left
                        }, label: {
                            Text("Left")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(settingsViewModel.handMode == .Left ? Color.blue : Color.black)
                                .foregroundColor(settingsViewModel.handMode == .Left ? Color.blue : Color.black)
                        })
                        Button(action: {
                            settingsViewModel.handMode = .Right
                        }, label: {
                            Text("Right")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(Color.black)
                                .border(settingsViewModel.handMode == .Right ? Color.blue : Color.black)
                                .foregroundColor(settingsViewModel.handMode == .Right ? Color.blue : Color.black)
                               
                        })
                    })
                }
            }
            Spacer()
        }
    }
}

enum ScoreCardSettingType {
    case NumberInnings
    case GameRoles
    case HandMode
    case None
}

struct ScoreCardSettingHeader: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var title : String
    var type : ScoreCardSettingType
    var hideCollapseWhenSelected : Bool = true
    
    var body: some View {
        HStack {
            HStack {
                Text(title)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if type != settingsViewModel.scoreCardViewSettingsType || !hideCollapseWhenSelected {
                    Spacer()
                    Text("\(getProperDisplay())")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }.contentShape(Rectangle())
            .padding()
            .border(Color.black, width: 1)
            .onTapGesture {
                settingsViewModel.scoreCardViewSettingsType = type == settingsViewModel.scoreCardViewSettingsType ? .None : type
            }
        }
    }
    
    func getProperDisplay() -> String {
        switch type {
        case .NumberInnings:
            return "\(settingsViewModel.numberOfInnings)"
        case .None:
            return ""
        case .HandMode:
            return "\(settingsViewModel.handMode.getString())"
        case .GameRoles:
            var rolesString = ""
            for role in gameViewModel.roles {
                rolesString += role.getGameRoleString() + (gameViewModel.roles.last == role ? " " : ", ")
            }
            return rolesString
        }
    }
    
}
