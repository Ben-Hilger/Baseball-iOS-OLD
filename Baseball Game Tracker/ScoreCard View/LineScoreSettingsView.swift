// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineScoreSettingsView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
    @State var viewSheet : Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 30))
            }.position(x: geometry.size.width * 0.05 ,y: geometry.size.height*0.325)
            .onTapGesture {
                self.viewSheet = true
            }
        }.sheet(isPresented: $viewSheet, content: {
            SettingsView()
                .environmentObject(settingsViewModel)
                .environmentObject(gameViewModel)
                .environmentObject(eventViewModel)
        })
    }
}

struct LineScoreSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LineScoreSettingsView()
    }
}
