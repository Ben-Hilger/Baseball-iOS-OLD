// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct EmptyRunnerView: View {
    
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    var widthAdjustment : CGFloat
    var heightAdjustment: CGFloat

    var body: some View {
        GeometryReader { (geometry) in
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: CGFloat(settingsViewModel.runnerFontSize)))
                    .foregroundColor(Color.black)
                    .position(x: geometry.size.width * widthAdjustment, y: geometry.size.height * heightAdjustment)
                    
                //Text("None")
            }
        }
    }
}

struct EmptyRunnerVIew_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRunnerView(widthAdjustment: 0, heightAdjustment: 0)
    }
}
