// Copyright 2021-Present Benjamin Hilger


import SwiftUI

struct AnalyticsView: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @State var selectedFormula : Formula?
    
    var body: some View {
        VStack {
            Text("Available Statistics")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(10)
                .border(Color.black,  width: 3)
            Text("You can select up to three statistics to view next to the line score")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(4)
                .border(Color.black,  width: 1)
            List {
                ForEach(settingsViewModel.allFormulas.indices, id: \.self) { formula in
                    VStack {
                        HStack {
                            Text("#\(formula+1)")
                                .frame(alignment: .leading)
                            //Spacer()
                            Text("\(settingsViewModel.allFormulas[formula].getFormulaLongName())  \(settingsViewModel.allFormulas[formula].getFormulaResult(withGameViewModel: gameViewModel, withSettingsViewModel: settingsViewModel))").frame(maxWidth: .infinity, alignment: .center).multilineTextAlignment(.center).onTapGesture {
                                if self.selectedFormula == settingsViewModel.allFormulas[formula] {
                                    selectedFormula = nil
                                } else {
                                    selectedFormula = settingsViewModel.allFormulas[formula]
                                }
                            }
                            //Spacer()
                            Text("\(settingsViewModel.allFormulas[formula].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamName ?? "Away" : gameViewModel.game?.homeTeam.teamName ?? "Home")")
                                .frame(maxWidth: .infinity)
                            //Spacer()
                            Image(systemName: (settingsViewModel.formulas.contains(settingsViewModel.allFormulas[formula])) ? "checkmark.square" : "square")                    }.onTapGesture {
                                let currentFormula = settingsViewModel.allFormulas[formula]
                                if let index = settingsViewModel.formulas.firstIndex(of: currentFormula) {
                                    settingsViewModel.formulas.remove(at: index)
                                } else if settingsViewModel.formulas.count < 3 {
                                    settingsViewModel.formulas.append(currentFormula)
                                }
                            }.padding().border(settingsViewModel.allFormulas[formula].analyzeTeam == .Away ? gameViewModel.game?.awayTeam.teamPrimaryColor ?? Color.black : gameViewModel.game?.homeTeam.teamPrimaryColor ?? Color.black, width: 3)                                .frame(maxWidth: .infinity)

                        if selectedFormula == settingsViewModel.allFormulas[formula] {
                            HStack {
                                Text("\(gameViewModel.game?.homeTeam.teamName ?? "Home")")
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        settingsViewModel.allFormulas[formula].analyzeTeam = .Home
                                        // Forces an UI update
                                        settingsViewModel.objectWillChange.send()
                                        selectedFormula?.analyzeTeam = .Home
                                    }.foregroundColor(Color.blue).padding().border(Color.blue)
                                Text("\(gameViewModel.game?.awayTeam.teamName ?? "Away")")
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        settingsViewModel.allFormulas[formula].analyzeTeam = .Away
                                        // Forces an UI update
                                        settingsViewModel.objectWillChange.send()
                                        selectedFormula?.analyzeTeam = .Away
                                    }.foregroundColor(Color.blue).padding().border(Color.blue)
                            }.padding().border(Color.black, width: 3)
                        }
                    }
                    
                }
            }.border(Color.black, width: 1)
        }
    }
}
