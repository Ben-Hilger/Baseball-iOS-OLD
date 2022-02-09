// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct AddGameView: View {
    
    @EnvironmentObject var teamViewModel : TeamViewModel
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    
    var body: some View {
        VStack {
            Text("Add Game")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            HStack {
                VStack {
                    Text("Home Team")
                }
                VStack {
                    Text("Away Team")
                }
            }
        }
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}
