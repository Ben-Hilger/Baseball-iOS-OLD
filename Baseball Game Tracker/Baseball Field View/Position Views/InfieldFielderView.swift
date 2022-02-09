// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct InfieldFielderView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    @Binding var fieldEditMode : FieldEditMode
    
    var body: some View {
        GeometryReader { geometry in
            FielderView(position: .FirstBase, widthAdjustment: 0.75, heightAdjustment: 0.55)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            FielderView(position: .SecondBase, widthAdjustment: 0.65, heightAdjustment: 0.45)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            FielderView(position: .ShortStop, widthAdjustment: 0.35, heightAdjustment: 0.45)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            FielderView(position: .ThirdBase, widthAdjustment: 0.25, heightAdjustment: 0.55)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
        }
    }
}

struct InfieldFielderView_Previews: PreviewProvider {
    static var previews: some View {
        InfieldFielderView(fieldEditMode: .constant(.Normal))
    }
}
