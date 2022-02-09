// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct ModalActionOptionView: View {
    
    //var base : Base
    var message : String
    var subMessage : String?
    var actionOptions : [ActionOption] = []
    
    var widthMod : CGFloat = 0.15
    var heightMod : CGFloat = 0.5
    
    var allowMultiSelect : Bool = false
    var finishAction : (([ActionOption]) -> Void)? = nil
    
    @State var optionsSelected : [ActionOption] = []
    
    var body: some View {
        VStack {
            VStack {
                Text("\(message)")
                    .multilineTextAlignment(.center)
                if let subMess = subMessage {
                    Text("\(subMess)")
                        .multilineTextAlignment(.center)
                }
            }
            List {
                ForEach(actionOptions) { action in
                    HStack {
                        Text("\(action.message)")
                            .foregroundColor(Color.black)
                            .font(.system(size: 15))
                            .if(!allowMultiSelect) {
                                $0.multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                            }
                        if allowMultiSelect {
                            Spacer()
                            Image(systemName: allowMultiSelect && optionsSelected.contains(action) ? "checkmark.square" : "square")
                        }
                    }.contentShape(Rectangle()).onTapGesture {
                        if allowMultiSelect {
                            if let index = optionsSelected.firstIndex(of: action) {
                                optionsSelected.remove(at: index)
                            } else {
                                optionsSelected.append(action)
                            }
                        } else {
                            action.action()
                        }
                    }
                }
            }
            if allowMultiSelect, let finishAction = finishAction {
                Button {
                    finishAction(optionsSelected)
                } label: {
                    Text("Finish")
                }

            }
        }.border(Color.black, width: 3).frame(width: UIScreen.main.bounds.width * widthMod, height: UIScreen.main.bounds.height * heightMod)
    }
}

struct ActionOption : Identifiable, Equatable {
    
    static func == (lhs: ActionOption, rhs: ActionOption) -> Bool {
        return lhs.message == rhs.message
    }
    
    var id = UUID()
    
    var message : String
    
    var action : () -> Void
    
}

