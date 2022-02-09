// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct ErrorHandlingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    
  //  @Binding var isPresenting : Bool
    
    var body: some View {
        VStack {
            VStack {
                Text("Error Handling")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .font(.system(size: 25))
                Text("For each error selected, please specify if it was a fielding or throwing error.")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .font(.system(size: 15))
            }.border(Color.black, width: 1)

           
            ForEach(eventViewModel.playerWhoCommittedError.indices, id: \.self) { index in
                Text("\(eventViewModel.playerWhoCommittedError[index].fielderInvolved.member.lastName) - \(eventViewModel.playerWhoCommittedError[index].fielderInvolved.positionInGame.getPositionString())")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding()
                    .border(Color.black, width: 1)
                List {
                    ErrorHandlingOption(playerIndex: index, type: .FieldingError)
                        .environmentObject(eventViewModel)
                    ErrorHandlingOption(playerIndex: index, type: .ThrowingError)
                        .environmentObject(eventViewModel)
                }
            }
            Button {
            //    isPresenting = false
                presentationMode.wrappedValue.dismiss()
                gameViewModel.addEvent(eventViewModel: eventViewModel)
                eventViewModel.reset()
            } label: { 
                Text("Finish")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }.padding()
            .border(Color.blue, width: 1)

        }
    }
}

struct ErrorHandlingOption : View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var playerIndex : Int
    var type : ErrorType
    
    var body: some View {
        HStack {
            Text("\(type.getString())")
            Spacer()
            Image(systemName: playerIndex < eventViewModel.playerWhoCommittedError.count ? eventViewModel.playerWhoCommittedError[playerIndex].type == type ? "checkmark.square" : "square" : "square")
        }.contentShape(Rectangle())
        .onTapGesture {
            eventViewModel.playerWhoCommittedError[playerIndex].type = type
        }
    }
}
