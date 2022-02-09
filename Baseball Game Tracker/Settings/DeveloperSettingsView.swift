// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct DeveloperSettingsView: View {
    var body: some View {
        VStack {
            Text("Developer Settings")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .border(Color.black, width: 1)
            HStack {
                Text("Test Mode")
                Spacer()
                Toggle(isOn: Binding(get: {
                    return SettingsViewModel.isInTestMode
                }, set: { (newVal) in
                    SettingsViewModel.isInTestMode = newVal
                })) {
                    Text("")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .border(Color.black, width: 1)
            Spacer()
        }
    }
}

struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
