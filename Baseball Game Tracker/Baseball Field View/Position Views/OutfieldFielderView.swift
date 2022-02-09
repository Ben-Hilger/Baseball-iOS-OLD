// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct OutfieldFielderView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @Binding var fieldEditMode : FieldEditMode
    
    var body: some View {
        GeometryReader { geometry in
            FielderView(position: .LeftField, widthAdjustment: 0.2, heightAdjustment: 0.3)
                .environmentObject(gameViewModel)
            FielderView(position: .CenterField, widthAdjustment: 0.5, heightAdjustment: 0.1)
                .environmentObject(gameViewModel)
            FielderView(position: .RightField, widthAdjustment: 0.8, heightAdjustment: 0.3)
                .environmentObject(gameViewModel)
        }
    }
}

struct OutfieldFielderView_Previews: PreviewProvider {
    static var previews: some View {
        OutfieldFielderView(fieldEditMode: .constant(.Normal))
    }
}
