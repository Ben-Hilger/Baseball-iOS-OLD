// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct FieldAccessoryView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel

    var body: some View {
        VStack {
            if gameViewModel.fieldEditingMode == .PlayerSequence {
                Text("Please select the fielder sequence").padding().border(Color.black, width: 1)
            } 
        }
        
    }
}
