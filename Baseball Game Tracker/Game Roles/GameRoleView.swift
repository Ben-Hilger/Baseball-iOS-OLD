// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameRoleView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    @State var selectedRoles : [GameRole] = []
    @State var isFinished : Bool = false
    @State var state : Int?
    
    var body: some View {
        if !gameViewModel.isCheckingForInitialData {
            VStack(alignment: .center) {
                List {
                    ForEach(0..<GameRole.allCases.count, id: \.self) { index in
                        HStack {
                            Text(GameRole.allCases[index].getGameRoleString()).onTapGesture {
                                if let index = selectedRoles.firstIndex(of: GameRole.allCases[index]) {
                                    selectedRoles.remove(at: index)
                                } else {
                                    selectedRoles.append(GameRole.allCases[index])
                                }
                            }
                            Spacer()
                            Image(systemName: selectedRoles.contains(GameRole.allCases[index]) ? "checkmark.square" : "square")
                        }
                    }
                }
                HStack {
                    Button(action: {
                        gameViewModel.setupAndBeginGame(withRoles: selectedRoles)
                        self.state = 1
                    }, label: {
                        Text("Continue")
                    }).padding().border(Color.blue, width: 1).frame(width: UIScreen.main.bounds.width)
                    NavigationLink(
                        destination:
                            LiveGameView()
                            .environmentObject(gameViewModel)
                            .navigationBarTitle("").navigationBarHidden(true)
                        ,
                        tag: 1,
                        selection: $state,
                        label: {
                            EmptyView()
                        })
                }
            }.navigationBarTitle("Role Selection", displayMode: .inline)
        } else {
            ActivityIndicator()
        }
        
    }
}
