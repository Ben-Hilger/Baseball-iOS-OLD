// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FieldPositionView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    @State var isShowingSheet : Bool = false
    @State var modalView : ModalActionOptionView? = nil
    
    @State var sheetViewing : FieldPositionSheetViewing = .AddPitch
    
    @State var state : Int?
    @State var viewSheet : Bool = false
    
    var body: some View {
        GeometryReader { geometry in  
            InfieldFielderView(fieldEditMode: $gameViewModel.fieldEditingMode)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            if let view = modalView {
                view
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            }
            if gameViewModel.fieldEditingMode == .PlayerSequence || !gameViewModel.roles.contains(.PitchOutcome) {
                FielderView(position: .Pitcher, widthAdjustment: 0.5, heightAdjustment: 0.67)
                    .environmentObject(gameViewModel)
                    .environmentObject(settingsViewModel)
            }
            AddPitchButtonView(state: $state)
                .environmentObject(gameViewModel)
                .environmentObject(eventViewModel)
            FielderView(position: .Catcher, widthAdjustment: 0.5, heightAdjustment: 0.95)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(eventViewModel)
            OutfieldFielderView(fieldEditMode: $gameViewModel.fieldEditingMode)
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(eventViewModel)
                
        }
//        .sheet(isPresented: $viewSheet) {
//            switch sheetViewing {
//            case .AddPitch:
//                
//            }
//        }
    }
}

enum FieldPositionSheetViewing {
    case ErrorHandling
    case AddPitch
}
