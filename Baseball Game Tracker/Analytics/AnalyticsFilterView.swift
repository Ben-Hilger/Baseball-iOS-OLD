// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct AnalyticsFilterView: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Filter Options")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .border(Color.black,  width: 1)
                Text("Pitching Filter Options")
                VStack {
                    HStack {
                        ForEach(PitcherFilterType.allCases.indices, id: \.self) { index in
                            Text(PitcherFilterType.allCases[index].getString())
                                .padding(3)
                                .frame(maxWidth: .infinity)
                                .border(settingsViewModel.pitcherFilterTypes == PitcherFilterType.allCases[index] ? Color.blue : Color.black, width: 3)
                                .onTapGesture {
                                    settingsViewModel.pitcherFilterTypes = PitcherFilterType.allCases[index]
                                }
                        }
                    }.padding(.bottom, 2)
                    HStack {
                        Text("All Pitchers")
                            .padding(3)
                            .frame(maxWidth: .infinity)
                            .border(settingsViewModel.pitcherSelectedFilterType == .All ? Color.blue : Color.black, width: 3)
                            .onTapGesture {
                                settingsViewModel.pitcherSelectedFilterType = .All
                            }
                           
                        Text("Current Pitcher")
                            .padding(3)
                            .frame(maxWidth: .infinity)
                            .border(settingsViewModel.pitcherSelectedFilterType == .Specific ? Color.blue : Color.black, width: 3)
                            .onTapGesture {
                                settingsViewModel.pitcherSelectedFilterType = .Specific
                                settingsViewModel.pitcherSelected = gameViewModel.getCurrentPitcher()?.member.memberID
                            }
                    }.padding(.top, 2)
                }
                Text("Hitter Filter Options")
                VStack {
                    HStack {
                        ForEach(HitterFilterType.allCases.indices, id: \.self) { index in
                            Text(HitterFilterType.allCases[index].getString())
                                .padding(3)
                                .frame(maxWidth: .infinity)
                                .border(settingsViewModel.hitterFilterTypes == HitterFilterType.allCases[index] ? Color.blue : Color.black, width: 3)
                                .onTapGesture {
                                    settingsViewModel.hitterFilterTypes = HitterFilterType.allCases[index]
                                }
                        }
                        
                    }
                    HStack {
                        Text("All Hitters")
                            .padding(3)
                            .frame(maxWidth: .infinity)
                            .border(settingsViewModel.hitterSelectedFilterType == .All ? Color.blue : Color.black, width: 3)
                            .onTapGesture {
                                settingsViewModel.hitterSelectedFilterType = .All
                            }
                        Text("Current Hitter")
                            .padding(3)
                            .frame(maxWidth: .infinity)
                            .border(settingsViewModel.hitterSelectedFilterType == .Specific ? Color.blue : Color.black, width: 3)
                            .onTapGesture {
                                settingsViewModel.hitterSelectedFilterType = .Specific
                                settingsViewModel.hitterSelected = gameViewModel.currentHitter?.member.memberID
                            }
                    }
                }
                
                Text("Pitch Filter Options")
                VStack {
                    HStack {
                        ForEach(0..<PitchType.allCases.count/2, id: \.self) { index in
                            Text(PitchType.allCases[index].getPitchTypeString())
                                .padding(3)
                                .frame(maxWidth: .infinity)
                                .border(settingsViewModel.pitchFilterType == PitchType.allCases[index] ? Color.blue : Color.black, width: 3)
                                .onTapGesture {
                                    settingsViewModel.pitchFilterType = PitchType.allCases[index]
                                }
                        }
                    }
                    HStack {
                        ForEach(PitchType.allCases.count/2..<PitchType.allCases.count, id: \.self) { index in
                            Text(PitchType.allCases[index].getPitchTypeString())
                                .padding(3)
                                .frame(maxWidth: .infinity)
                                .border(settingsViewModel.pitchFilterType == PitchType.allCases[index] ? Color.blue : Color.black, width: 3)
                                .onTapGesture {
                                    settingsViewModel.pitchFilterType = PitchType.allCases[index]
                                }
                        }
                    }
                }
                Text("Runners On Base Filter")
                HStack {
                    ForEach(PlayerOnBaseFilter.allCases.indices, id: \.self) { index in
                        Text(PlayerOnBaseFilter.allCases[index].getString())
                            .padding(3)
                            .frame(maxWidth: .infinity)
                            .border(settingsViewModel.playerOnBaseFilter == PlayerOnBaseFilter.allCases[index] ? Color.blue : Color.black, width: 3)
                            .onTapGesture {
                                settingsViewModel.playerOnBaseFilter = PlayerOnBaseFilter.allCases[index]
                            }
                    }
                }
                Group {
                    Text("Pitch Velocity Filter (> \(formatPitch()) mph)")
                    VStack {
                        HStack {
                            Text("Enabled")
                                .padding(3)
                                .frame(maxWidth: .infinity)
                                .border(settingsViewModel.pitchVelocityFilterType == .Enabled ? Color.blue : Color.black, width: 3)
                                .onTapGesture {
                                    settingsViewModel.pitchVelocityFilterType = .Enabled
                                }
                            Text("Disabled")
                                .padding(3)
                                .frame(maxWidth: .infinity)
                                .border(settingsViewModel.pitchVelocityFilterType == .Disabled ? Color.blue : Color.black, width: 3)
                                .onTapGesture {
                                    settingsViewModel.pitchVelocityFilterType = .Disabled
                                }
                        }
                        Slider(value: $settingsViewModel.pitchVelocityFilter, in: 0...110, step: 1)
                    }
                }
            }.padding()
        }
    }
    
    func formatPitch() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: settingsViewModel.pitchVelocityFilter)) ?? "0.0"
    }
}
