// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FieldSettingsView: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
        
    var body: some View {
        VStack {
            Text("Field Settings")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .border(Color.black, width: 1)
            FieldSettingHeader(title: "Runner Display Settings", type: .RunnerDisplay)
                .environmentObject(settingsViewModel)
            if settingsViewModel.fieldSelectionType == .RunnerDisplay {
                List {
                    ForEach(RunnerDislaySetting.allCases.indices, id: \.self) { runnerCase in
                        HStack {
                            Text("\(RunnerDislaySetting.allCases[runnerCase].getString())")
                                .font(.system(size: 15))
                            Spacer()
                            Image(systemName: settingsViewModel.runnerDisplaySettings == RunnerDislaySetting.allCases[runnerCase] ? "checkmark.square" : "square")
                        }.contentShape(Rectangle())
                        .onTapGesture {
                            settingsViewModel.runnerDisplaySettings = RunnerDislaySetting.allCases[runnerCase]
                        }
                    }
                }
            }
            FieldSettingHeader(title: "Fielder Display Settings", type: .FielderDisplay)
                .environmentObject(settingsViewModel)
            if settingsViewModel.fieldSelectionType == .FielderDisplay {
                List {
                    ForEach(RunnerDislaySetting.allCases.indices, id: \.self) { runnerCase in
                        HStack {
                            Text("\(RunnerDislaySetting.allCases[runnerCase].getString())")
                                .font(.system(size: 15))
                            Spacer()
                            Image(systemName: settingsViewModel.fielderDisplaySettings == RunnerDislaySetting.allCases[runnerCase] ? "checkmark.square" : "square")
                        }.contentShape(Rectangle())
                        .onTapGesture {
                            settingsViewModel.fielderDisplaySettings = RunnerDislaySetting.allCases[runnerCase]
                        }
                    }
                }
            }
            FieldSettingHeader(title: "Runner Font Size", type: .RunnerFontSize, hideCollapseWhenSelected: false)
                .environmentObject(settingsViewModel)
            if settingsViewModel.fieldSelectionType == .RunnerFontSize {
                Slider(value: $settingsViewModel.runnerFontSize, in: 1...100, step: 1)
                .padding()
                .accentColor(Color.red)
                .border(Color.black, width: 1)
            }
            FieldSettingHeader(title: "Fielder Font Size", type: .FielderFontSize, hideCollapseWhenSelected: false)
                .environmentObject(settingsViewModel)
            if settingsViewModel.fieldSelectionType == .FielderFontSize {
                Slider(value: $settingsViewModel.fielderFontSize, in: 1...100, step: 1)
                .padding()
                .accentColor(Color.red)
                .border(Color.black, width: 1)
            }
            Spacer()
        }
    }
}

enum FieldSettingsSelectionType {
    case RunnerDisplay
    case None
    case FielderDisplay
    case RunnerFontSize
    case FielderFontSize
}

struct FieldSettingHeader: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var title : String
    var type : FieldSettingsSelectionType
    var hideCollapseWhenSelected : Bool = true
    
    var body: some View {
        HStack {
            HStack {
                Text(title)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if type != settingsViewModel.fieldSelectionType || !hideCollapseWhenSelected {
                    Spacer()
                    Text("Display: \(getProperDisplay())")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }.contentShape(Rectangle())
            .padding()
            .border(Color.black, width: 1)
            .onTapGesture {
                settingsViewModel.fieldSelectionType = type ==  settingsViewModel.fieldSelectionType ? .None : type
            }
        }
    }
    
    func getProperDisplay() -> String {
        switch type {
        case .RunnerDisplay:
            return settingsViewModel.runnerDisplaySettings.getString()
        case .FielderDisplay:
            return settingsViewModel.fielderDisplaySettings.getString()
        case .RunnerFontSize:
            return "\(settingsViewModel.runnerFontSize)"
        case .FielderFontSize:
            return "\(settingsViewModel.fielderFontSize)"
        case .None:
            return "None"
        }
    }
    
}
