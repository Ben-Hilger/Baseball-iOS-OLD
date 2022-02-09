// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        // Vertical Stack
        VStack(alignment: .center, spacing: 10.0,  content: {
            Image("logo")

            Text("Miami University Baseball Game Tracker")
                .fontWeight(.black)
                .foregroundColor(Color.red)
                .multilineTextAlignment(.center)
            Image("baseball-diamond")
            
        })
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainMenuView()
                .font(.largeTitle)
        }
    }
}
