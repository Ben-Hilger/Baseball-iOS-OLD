// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var viewEndGameWarning : Bool = false
    
    var body: some View {
        if !viewEndGameWarning {
            VStack {
                Button {
                    self.viewEndGameWarning = true
                } label: {
                    Text("End Game")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .border(Color.red, width: 3)
                        .foregroundColor(Color.red)
                }
                TabView {
                    FieldSettingsView()
                        .environmentObject(settingsViewModel)
                        .environmentObject(gameViewModel)
                        .tabItem { Text("Field Settings") }
                    ScoreCardSettingsView()
                        .environmentObject(settingsViewModel)
                        .environmentObject(gameViewModel)
                       .tabItem { Text("Game Settings") }
                    ForceAddEventView()
                        .environmentObject(gameViewModel)
                        .environmentObject(eventViewModel)
                        .tabItem { Text("Force Events") }
                    DeveloperSettingsView()
                        .tabItem { Text("Developer Settings") }
                }.padding().border(Color.black, width: 3)
            }
        } else {
            EndGameWarningView(showing: $viewEndGameWarning)
                .environmentObject(gameViewModel)
        }
    }
}

struct EndGameWarningView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @Binding var showing: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text("WARNING!!!!")
                .font(.system(size: 50))
            Text("ARE YOU SURE YOU WANT TO CONTINUE? ONCE YOU PERFORM THIS ACTION IT CAN'T BE UNDONE")
                .multilineTextAlignment(.center)
                .padding()
                .border(Color.red, width: 3)
                .foregroundColor(Color.red)
            HStack {
                Button(action: {
                    self.showing = false
                }, label: {
                    Text("Nevermind")
                })
                .padding().border(Color.black)
                
                Spacer()
                Button(action: {
                    gameViewModel.markGameForCompletion()
                    gameViewModel.objectWillChange.send()
                }, label: {
                    Text("Let's do it!!")
                })
                .padding().border(Color.red)
            }.padding()
        }.padding()
        
        
    }
    
}
