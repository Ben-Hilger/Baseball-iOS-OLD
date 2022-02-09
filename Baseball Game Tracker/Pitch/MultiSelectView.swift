// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct MultiSelectView: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var types : [PitchOutcome]
    var mainText : String
    
    var body: some View {
        NavigationLink(destination:
                        List {
                            ForEach(types.indices, id: \.self) { index in
                                SingleSelectCell(type: types[index])
                                    .environmentObject(eventViewModel)
                            }
                        }
                    
        ) {
            Text(mainText)
                .font(.system(size: 10))
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct MultiSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectView(types: [], mainText: "")
    }
}
