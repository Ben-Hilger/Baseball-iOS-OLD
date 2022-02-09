// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct MultiSelectViewBIP: View {
    
    @EnvironmentObject var eventViewModel : EventViewModel
    
    var types : [BIPHit]
    var mainText : String
    var extraInfo : [BIPHit] = []
    
    var body: some View {
        NavigationLink(destination:
            List {
                ForEach(types.indices, id: \.self) { index in
                    SingleSelectViewBIP(type: types[index], extraToAdd: extraInfo)
                        .environmentObject(eventViewModel)
                }
            }
           // .navigationBarTitle(mainText, displayMode: .inline)
        ) {
            Text(mainText)
                .font(.system(size: 10))
        }
    }
}

struct MultiSelectViewBIP_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectViewBIP(types: [], mainText: "Exampleget")
    }
}
