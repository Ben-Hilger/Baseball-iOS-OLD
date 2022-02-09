// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineScoreCountTrackerView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
       
    var body: some View {
        if let currentInning = gameViewModel.currentInning {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    HStack {
                        Text("Balls")
                        Image(systemName: gameViewModel.getCurrentBalls() >= 1 ? "circle.fill" : "circle")
                        Image(systemName: gameViewModel.getCurrentBalls() >= 2 ? "circle.fill" : "circle")
                        Image(systemName: gameViewModel.getCurrentBalls() >= 3 ? "circle.fill" : "circle")
                    }.padding(1)
                    HStack {
                        Text("Strikes")
                        Image(systemName: gameViewModel.getCurrentStrikes() >= 1 ? "circle.fill" : "circle")
                        Image(systemName: gameViewModel.getCurrentStrikes() >= 2 ? "circle.fill" : "circle")
                    }.padding(1)
                    HStack {
                        Text("Outs")
                        Image(systemName: gameViewModel.getCurrentNumberOfOuts() >= 1 ? "circle.fill" : "circle")
                        Image(systemName: gameViewModel.getCurrentNumberOfOuts() >= 2 ? "circle.fill" : "circle")
                    }.padding(1)
                }.position(x: geometry.size.width*0.14, y: geometry.size.height*0.325)
            }
        }
    }
}

struct LineScoreCountTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        LineScoreCountTrackerView()
    }
}
