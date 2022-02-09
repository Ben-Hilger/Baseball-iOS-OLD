// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameView: View {
    
    var game : Game
    
    var body: some View {
        VStack {
            HStack {
                
            }
            HStack {
                List {
                    Text("home Team Lineup")
                }
                List {
                    Text("Away Team Lineup")
                }
            }
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
