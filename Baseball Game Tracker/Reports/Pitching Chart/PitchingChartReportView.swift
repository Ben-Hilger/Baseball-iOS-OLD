// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchingChartReportView: View {
    
    @EnvironmentObject var pitchingChartViewModel : PitchingChartViewModel
    
    var pitcherViewing: [Member] = []
    
    var pdfMode: Bool = false
    @State var pdfView : PDFViewUI?
    @State var showPDF : Bool = true
    
    var isLimitingBy: Int = 0
    var isStartingAt: Int = 0
    
    var isShowingTotals: Bool = false
    
    @State var totals: [PitchingTotalRow] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if let pdfView: PDFViewUI = pdfView, showPDF {
                    HStack {
                        Text("Player Name")
                            .font(.title)
                            .fontWeight(.bold)
                            .onAppear {
                                showPDF = false
                            }
                        pdfView
                    }
                }
                if pdfMode {
                    Text("\(pitcherViewing.count == 1 ? pitcherViewing[0].getFullName() : "Multiple")")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                       
                }
                List {
                    if !pdfMode || (pdfMode && !isShowingTotals) {
                        HStack(spacing: 0) {
                            Text("Batter + RHH/LHH")
                                .multilineTextAlignment(.center)
                                .frame(width: geometry.size.width * 0.25,
                                       height: geometry.size.height * 0.05)
                                .border(Color.black, width: 2)
                                .font(.system(size: 12))
                            Text("STR?")
                                .frame(width: geometry.size.width * 0.09,
                                       height: geometry.size.height * 0.05)
                                .border(Color.black, width: 2)
                                .font(.system(size: 12))
                            Text("Pitch + Location")
                                .frame(width: geometry.size.width * 0.2,
                                       height: geometry.size.height * 0.05)
                                .border(Color.black, width: 2)
                                .font(.system(size: 12))
                            Text("Strike?")
                                .frame(width: geometry.size.width * 0.11,
                                       height: geometry.size.height * 0.05)
                                .border(Color.black, width: 2)
                                .font(.system(size: 12))
                            Text("Velocity")
                                .frame(width: geometry.size.width * 0.12,
                                       height: geometry.size.height * 0.05)
                                .border(Color.black, width: 2)
                                .font(.system(size: 12))
                            Text("Outcome")
                                .frame(width: geometry.size.width * 0.18,
                                       height: geometry.size.height * 0.05)
                                .border(Color.black, width: 2)
                                .font(.system(size: 12))
                        }
                        ForEach(pdfMode ? pitchingChartViewModel.loadedInformation[min((isStartingAt), pitchingChartViewModel.loadedInformation.count)..<min((isStartingAt+isLimitingBy), pitchingChartViewModel.loadedInformation.count)].reversed().reversed() : pitchingChartViewModel.loadedInformation) { row in
                            VStack {
                                if let pitcherName = row.pitcherName {
                                    Text(pitcherName)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)

                                }
                                HStack(spacing: 0) {
                                    Text(getProperDisplay(withType: .HitterInfo, withInfo: row))
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.25,
                                               height: geometry.size.height * 00.05)
                                        .border(Color.black, width: 1)
                                    Image(systemName: getProperDisplay(withType: .STR, withInfo: row))
                                        .frame(width: geometry.size.width * 0.09,
                                               height: geometry.size.height * 00.05)
                                        .border(Color.black, width: 1)
                                    Text("\(getProperDisplay(withType: .PitchLocation, withInfo: row, withPitcherHand: row.pitcherHand))")
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.2,
                                               height: geometry.size.height * 00.05)
                                        .border(Color.black, width: 1)
                                    if let location = row.location, let wasStrike = row.isBIP {
                                        PitchingChartStrikeCellView(location: location, isBIP: wasStrike)
                                            .frame(width: geometry.size.width * 0.11,
                                                   height: geometry.size.height * 00.05)
                                            .border(Color.black, width: 1)
                                    } else {
                                        Text("")
                                            .frame(width: geometry.size.width * 0.11,
                                                   height: geometry.size.height * 00.05)
                                            .border(Color.black, width: 1)
                                    }
        //                            Image(systemName: getProperDisplay(withType: .Strike, withInfo: row))
        //                                .frame(width: geometry.size.width * 0.11,
        //                                       height: geometry.size.height * 00.1)
        //                                .border(Color.black, width: 1)
                                    Text(getProperDisplay(withType: .Velocity, withInfo: row))
                                        .frame(width: geometry.size.width * 0.12,
                                               height: geometry.size.height * 00.05)
                                        .border(Color.black, width: 1)
                                    if let outcome = row.outcome {
                                        PitchingChartOutcomeCellView(bipType: row.type, outcome: outcome)
                                            .frame(width: geometry.size.width * 0.18,
                                                   height: geometry.size.height * 00.05)
                                            .border(Color.black, width: 1)
                                    } else {
                                        Text("")
                                            .frame(width: geometry.size.width * 0.18,
                                                   height: geometry.size.height * 00.05)
                                            .border(Color.black, width: 1)
                                    }
                                   
        //                            Text(getProperDisplay(withType: .Outcome, withInfo: row))
        //                                .padding()
        //                                .frame(width: geometry.size.width * 0.15,
        //                                       height: geometry.size.height * 00.1)
        //                                .border(Color.black, width: 1)
                                }
                                if row.lastInInning {
                                    Divider()
                                }
                            }
                        }
                    }
                    if !pdfMode || (pdfMode && isShowingTotals) {
                        ForEach(totals) { row in
                            VStack {
                                VStack {
                                    Text(row.pitcherName)
                                        .fontWeight(.bold)
                                    Text("LHH")
                                    HStack {
                                        VStack {
                                            Text("FB K =\n\(row.FBK) / \(row.FBTotal)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.FBSM)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("BB K =\n\(row.BBK) / \(row.BBTotal)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.BBSM)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("SL K =\n\(row.SLK) / \(row.SLTotal)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.SLSM)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("CHUP K =\n\(row.CHUPK) / \(row.CHUPTotal)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.CHUPSM)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("OTHER K =\n\(row.OTHERK) / \(row.OTHERTotal)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.OTHERSM)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("FP K = \(row.FPK) / \(row.totalAtbats)")
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)

                                        VStack {
                                            Text("1st 2o3 =\n\(row.first2o3) / \(row.totalAtbats)")
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                    }
                                    Text("RHH")
                                    HStack {
                                        VStack {
                                            Text("FB K =\n\(row.FBKRHH) / \(row.FBTotalRHH)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.FBSMRHH)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("BB K =\n\(row.BBKRHH) / \(row.BBTotalRHH)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.BBSMRHH)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("SL K =\n\(row.SLKRHH) / \(row.SLTotalRHH)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.SLSMRHH)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("CHUP K =\n\(row.CHUPKRHH) / \(row.CHUPTotalRHH)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.CHUPSMRHH)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("OTHER K =\n\(row.OTHERKRHH) / \(row.OTHERTotalRHH)")
                                                .font(.system(size: 15))
                                            Text("S+M = \(row.OTHERSMRHH)" )
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                        VStack {
                                            Text("FP K = \(row.FPKRHH) / \(row.totalAtbatsRHH)")
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)

                                        VStack {
                                            Text("1st 2o3 =\n\(row.first2o3RHH) / \(row.totalAtbatsRHH)")
                                                .font(.system(size: 15))
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width * 0.125, height: geometry.size.height * 0.1)
                                        .border(Color.black)
                                    }
                                    Text("Pitches")
                                    HStack {
                                        ForEach(0..<row.pitchTypes.count, id: \.self) { type in
                                            VStack {
                                                Text(" \(row.pitchTypes[type].getPitchTypeString())")
                                                    .font(.system(size: 15))
                                                Text("Max: \(row.maxValues[type])")
                                                    .font(.system(size: 15))
                                                Text("Avg: \(row.avgValues[type])")
                                                    .font(.system(size: 15))
                                            }
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width /
                                                    CGFloat(row.pitchTypes.count) * 0.75, height: geometry.size.height * 0.1)
                                            .border(Color.black)
                                        }
                                    }
                                }
                            }
                        
                        }
                    }
                }
            }
        }.navigationBarTitle("\(pitcherViewing.count == 1 ? pitcherViewing[0].getFullName() : "Multiple")", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                exportToPDF()
        }, label: {
            Image(systemName: "square.and.arrow.up")
        }))
        .onAppear {
            totals = pitchingChartViewModel.loadedTotals
        }
    }
    
    func getProperDisplay(withType type: PitchingChartColumn,
                          withInfo info: PitchingChartRow,
                          withPitcherHand hand: HandUsed? = nil) -> String {
        switch type {
        case .HitterInfo:
            return "\(info.batter.member.getFullName()) \n \(info.batterHand == .Left ? "LHH" : "RHH")"
        case .STR:
            return info.str ? "checkmark" : ""
        case .PitchLocation:
            var string = " "
            if let pitchType = info.pitch?.getPitchTypeString() {
                string += "\(pitchType) \n "
            }
            if let location = info.location, let hand = hand {
                let nums = location.convertToMiamiPitcherNumbers(withHand: hand)
                // Add the first number
                string += "\(nums[0])"
                // Add the remaining numbers
                for index in 1..<nums.count {
                    string += "/\(nums[index])"
                }
            }
            return string
        case .Strike:
            return info.isBIP?.isStrike() ?? false ? "checkmark" : "xmark"
        case .Velocity:
            if let velo = info.velocity {
                return "\(Int(velo))"
            } else {
                return ""
            }
        case .Outcome:
            return ""
        }
    }
    
    func exportToPDF() {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("PitchingChart.pdf")
        
        
        //Normal with
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
            
        let arraySplt = Int(ceil(Double(pitchingChartViewModel.loadedInformation.count)/13.0))
        let totalArraySplit = Int(ceil(Double(pitchingChartViewModel.loadedTotals.count)/3.0))
        
        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))

        do {
            try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                
                for arrayIndex in 0..<(arraySplt) {
                    context.beginPage()
                    let charts = PitchingChartReportView(pitcherViewing: pitcherViewing, pdfMode: true, isLimitingBy: 13, isStartingAt: arrayIndex * 13)
                        .environmentObject(pitchingChartViewModel)
                    let pdfVC = UIHostingController(rootView: charts)
                    pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    //Render the view behind all other views
                    let rootVC = UIApplication.shared.windows.first?.rootViewController
                    rootVC?.addChild(pdfVC)
                    rootVC?.view.insertSubview(pdfVC.view, at: 0)
                    pdfVC.view.layer.render(in: context.cgContext)
                    pdfVC.removeFromParent()
                    pdfVC.view.removeFromSuperview()
                }
                for arrayIndex in 0..<totalArraySplit {
                    context.beginPage()
                    let charts = PitchingChartReportView(pitcherViewing: pitcherViewing, pdfMode: true, isShowingTotals: true, totals: pitchingChartViewModel.loadedTotals[min(arrayIndex * 2, pitchingChartViewModel.loadedTotals.count)..<min(arrayIndex * 2 + 2, pitchingChartViewModel.loadedTotals.count)].reversed().reversed())
                        .environmentObject(pitchingChartViewModel)
                    let pdfVC = UIHostingController(rootView: charts)
                    pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    //Render the view behind all other views
                    let rootVC = UIApplication.shared.windows.first?.rootViewController
                    rootVC?.addChild(pdfVC)
                    rootVC?.view.insertSubview(pdfVC.view, at: 0)
                    pdfVC.view.layer.render(in: context.cgContext)
                    pdfVC.removeFromParent()
                    pdfVC.view.removeFromSuperview()
                }
                

            })
            
            print(outputFileURL)
            
            self.pdfView = PDFViewUI(url: outputFileURL)
            self.showPDF = true

        }catch {
            // self.showError = true
            print("Could not create PDF file: \(error)")
        }
        
    }
}

struct PitchingChartTotalView: View {
    
    @EnvironmentObject var pitchingChartViewModel : PitchingChartViewModel
    @EnvironmentObject var gameViewModel : GameViewModel

    var row: PitchingTotalRow
    
    var body: some View {
        GeometryReader { geometry in
            
        }
    }
//
//    func getTotal(ofPitchThrown pitchThrown: [PitchType]) -> Int {
//        var total: Int = 0
//        for snapshot in gameViewModel.gameSnapshots {
//            if snapshot.eventViewModel.pitcherID == player.memberID,
//               let pitchT = snapshot.eventViewModel.pitchEventInfo?.selectedPitchThrown,
//               pitchThrown.contains(pitchT) {
//                total += 1
//            }
//        }
//        return total
//    }
//
//    func getTotalK(ofPitchThrown pitchThrown: [PitchType]) -> Int  {
//        var total: Int = 0
//        for snapshot in gameViewModel.gameSnapshots {
//            if snapshot.eventViewModel.pitcherID == player.memberID,
//               let pitchT = snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchType,
//               pitchThrown.contains(pitchT),
//               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false {
//                total += 1
//            }
//        }
//        return total
//    }
//
//    func getTotalSM(ofPitchThrown pitchThrown: [PitchType]) -> Int {
//        var total: Int = 0
//        for snapshot in gameViewModel.gameSnapshots {
//            if snapshot.eventViewModel.pitcherID == player.memberID,
//               let pitchT = snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchType,
//               pitchThrown.contains(pitchT),
//               snapshot.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrikeSwinging() ?? false {
//                total += 1
//            }
//        }
//        return total
//    }
//
//    func getTotalFPS() -> Int {
//        var total: Int = 0
//        var atBats: [Int : [GameSnapshot]] = [:]
//
//        for snapshot in gameViewModel.gameSnapshots {
//            if snapshot.eventViewModel.pitcherID == player.memberID,
//               snapshot.eventViewModel.isAddingPitch {
//                var currentEvents: [GameSnapshot] = atBats[Int(snapshot.currentAtBat!.atBatID)!] ?? []
//                currentEvents.append(snapshot)
//                atBats.updateValue(currentEvents, forKey: Int(snapshot.currentAtBat!.atBatID)!)
//            }
//        }
//
//
//        for atBat in atBats {
//            var als = atBat.value
//            als.sort { (snapshot, snapshot2) -> Bool in
//                snapshot.snapshotIndex < snapshot2.snapshotIndex
//            }
//            if let first = als.first {
//                if first.eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false {
//                    total += 1
//                }
//            }
//        }
//
//        return total
//    }
//
//    func getTotal2o3() -> Int {
//        var total: Int = 0
//        var atBats: [Int : [GameSnapshot]] = [:]
//
//        for snapshot in gameViewModel.gameSnapshots {
//            if snapshot.eventViewModel.pitcherID == player.memberID,
//               snapshot.eventViewModel.isAddingPitch {
//                var currentEvents: [GameSnapshot] = atBats[Int(snapshot.currentAtBat!.atBatID)!] ?? []
//                currentEvents.append(snapshot)
//                atBats.updateValue(currentEvents, forKey:Int(snapshot.currentAtBat!.atBatID)!)
//            }
//        }
//
//        for atBat in atBats {
//            var als = atBat.value
//            als.sort { (snapshot, snapshot2) -> Bool in
//                snapshot.snapshotIndex < snapshot2.snapshotIndex
//            }
//            if atBat.value.count >= 3 {
//                let first: Int = atBat.value[0].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false ?
//                atBat.value[0].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP ? -3 : 1 : 0
//                let second: Int = atBat.value[1].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false ?
//                    atBat.value[1].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP ? -3 : 1 : 0
//                let third: Int = atBat.value[2].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult?.isStrike() ?? false ?
//                    atBat.value[2].eventViewModel.pitchEventInfo?.completedPitch?.pitchResult == .HBP ? -3 : 1 : 0
//                if first + second + third >= 2 {
//                    total += 1
//                }
//            } else {
//                total += 1
//            }
//        }
//
//        return total
//    }
//
//    func getTotalAtBat() -> Int {
//        var atBats: [Int : [GameSnapshot]] = [:]
//
//        for snapshot in gameViewModel.gameSnapshots {
//            if snapshot.eventViewModel.pitcherID == player.memberID {
//                var currentEvents: [GameSnapshot] = atBats[Int(snapshot.currentAtBat!.atBatID)!] ?? []
//                currentEvents.append(snapshot)
//                atBats.updateValue(currentEvents, forKey: Int(snapshot.currentAtBat!.atBatID)!)
//            }
//        }
//        return atBats.keys.count
//    }
//
}

struct PitchingChartStrikeCellView: View {
    
    var location: PitchLocation
    var isBIP: PitchOutcome
    
    var body: some View {
        GeometryReader { geometry in
            if isBIP == .FoulBall {
                Text("xf")
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            } else if isBIP.isStrike() {
                Image(systemName: isBIP == .BIP ? "checkmark" : "xmark")
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                    .if(isBIP.isStrikeSwinging() && isBIP != .BIP) {
                        $0.overlay(Circle()
                                    .stroke(Color.black)
                                    .frame(width: 40, height: 40)
                                    .position(x: geometry.size.width * 0.5,
                                              y: geometry.size.height * 0.5))
                    }
            }
            
            Text("O")
                .position(x: geometry.size.width * 0.65, y: geometry.size.height * 0.85)
                .font(.system(size: 12))
                .if(!location.isInZone()) {
                    $0.overlay(Circle()
                                .stroke(Color.black)
                                .frame(width: 20, height: 20)
                                .position(x: geometry.size.width * 0.65,
                                          y: geometry.size.height * 0.85))

                }
            Text("Z")
                .position(x: geometry.size.width * 0.85, y: geometry.size.height * 0.85)
                .font(.system(size: 12))
                .if(location.isInZone()) {
                    $0.overlay(Circle()
                                .stroke(Color.black)
                                .frame(width: 20, height: 20)
                                .position(x: geometry.size.width * 0.85,
                                          y: geometry.size.height * 0.85))

                }
        }
    }
}

struct PitchingChartOutcomeCellView : View {
    
    var bipType: BIPType?
    var outcome: String
    var body: some View {
        GeometryReader { geometry in
            Text(outcome)
                .position(x: geometry.size.width * 0.35, y: geometry.size.height * 0.5)
                .font(.system(size: 12))
                .frame(width: geometry.size.width * 0.7)
                .multilineTextAlignment(.leading)
            Text("FB")
                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.15)
                .font(.system(size: 10))
                .if(bipType == .FlyBall, transform: {
                    $0.overlay(Circle()
                                .stroke(Color.black)
                                .frame(width: 20, height: 20)
                                .position(x: geometry.size.width * 0.9,
                                          y: geometry.size.height * 0.15))
                })
            Text("LD")
                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.5)
                .font(.system(size: 10))
                .if(bipType == .LineDrive, transform: {
                    $0.overlay(Circle()
                                .stroke(Color.black)
                                .frame(width: 20, height: 20)
                                .position(x: geometry.size.width * 0.9,
                                          y: geometry.size.height * 0.5))
                })
            Text("GB")
                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.85)
                .font(.system(size: 10))
                .if(bipType == .GB, transform: {
                    $0.overlay(Circle()
                                .stroke(Color.black)
                                .frame(width: 20, height: 20)
                                .position(x: geometry.size.width * 0.9,
                                          y: geometry.size.height * 0.85))
                })
                
        }
    }
    
}
//
//struct PitchingChartReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        PitchingChartReportView(pitcherViewing: nil)
//            .environmentObject(generateTest())
//    }
//
//    static func generateTest() -> PitchingChartViewModel {
//
//        let chart = PitchingChartViewModel()
//
//        chart.loadedInformation = [
//            PitchingChartRow(batter: MemberInGame(member: Member(withID: "", withFirstName: "Test", withLastName: "", withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Left, withHittingHands: .Left), positionInGame: .CenterField), batterHand: .Left, str: false)
//        ]
//
//        return chart
//    }
//}

enum PitchingChartColumn : String, CaseIterable {
    case HitterInfo = "Batter + RHH/LH"
    case STR = "STR?"
    case PitchLocation = "Pitch + Location"
    case Strike = "Strike?"
    case Velocity = "Velocity"
    case Outcome = "Outcome"
}

