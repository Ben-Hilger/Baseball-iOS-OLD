// Copyright 2021-Present Benjamin Hilger

import Foundation
import SwiftUI
import PDFKit

struct PitchTendenciesSeriesReportView : View {
    
    @EnvironmentObject var pitchTendenciesViewModel :
        PitchTendenciesSeriesReportViewModel

    var mainZoneWidth : CGFloat = 100
    var mainZoneHeight : CGFloat = 75
    
    var playerViewing : [MemberInGame]
  
    // var pitchCounts : [PitchLocation : [PitchType : Int]]
    
    @State var pdfView : PDFViewUI?
    @State var pdfFileLoc : URL?
    @State var showPDF : Bool = true
  
    var pdfMode: Bool = false
    
    var playerEditing : PersonEditing
    var pitcherHand: HandUsed?
    
    var extraInfo: String? = nil
    
    var body: some View {
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
                Text("\(playerViewing.count == 1 ? playerViewing[0].member.getFullName() : "Multiple") \(extraInfo != nil ? extraInfo! : "")")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            HStack {
                ForEach(0...4, id: \.self) { index in
                    ZStack {
                        StrikeZoneElementView(
                            width: mainZoneWidth,
                            height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight,
                            shouldFill: false,
                            shouldShowBorder: true)
                            .onTapGesture {
                            // Reset the on tap gesture
                            }
                        StrikeZoneSeriesPitchOverlayView(
                            width: mainZoneWidth,
                            height: mainZoneHeight/10,//(pdfMode ? mainZoneHeight * 2 : mainZoneHeight)/10,
                            pitchLocation: index == 0 ? .OutTopLeftCorner :
                                index == 1 ? .OutTopLeft :
                                index == 2 ? .OutTopMiddle :
                                index == 3 ? .OutTopRight :
                                .OutTopLeftCorner,
                            playerViewing: getMembers(),
                            withPitchCounts: pitchTendenciesViewModel.getProperPitchCount(hand: pitcherHand)[index == 0 ? .OutTopLeftCorner :
                                                            index == 1 ? .OutTopLeft :
                                                            index == 2 ? .OutTopMiddle :
                                                            index == 3 ? .OutTopRight :
                                                            .OutTopLeftCorner] ?? [:])
                            .environmentObject(pitchTendenciesViewModel)
                    }.frame(width: mainZoneWidth, height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight)
                }
            }
            HStack {
                ForEach(0...4, id: \.self) { index in
                    ZStack {
                        StrikeZoneElementView(
                            width: mainZoneWidth,
                            height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight,
                            shouldFill: false,
                            shouldShowBorder: true)
                            .onTapGesture {
                            // Reset the on tap gesture
                            }.if(index != 0 && index != 4) {
                                $0.border(Color.black, width: 5)
                            }
                        StrikeZoneSeriesPitchOverlayView(
                            width: mainZoneWidth,
                            height: mainZoneHeight/10,//(pdfMode ? mainZoneHeight * 2 : mainZoneHeight)/10,
                            pitchLocation: index == 0 ? .OutLeftTop :
                                index == 1 ? .TopLeft :
                                index == 2 ? .TopMiddle :
                                index == 3 ? .TopRight : .OutRightTop,
                            playerViewing: getMembers(),
                            withPitchCounts: pitchTendenciesViewModel.getProperPitchCount(hand: pitcherHand)[index == 0 ? .OutLeftTop :
                                                            index == 1 ? .TopLeft :
                                                            index == 2 ? .TopMiddle :
                                                            index == 3 ? .TopRight : .OutRightTop] ?? [:])
                            .environmentObject(pitchTendenciesViewModel)
                    }.frame(width: mainZoneWidth, height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight)
                }
            }
            HStack {
                ForEach(0...4, id: \.self) { index in
                    ZStack {
                        StrikeZoneElementView(
                            width: mainZoneWidth,
                            height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight,
                            shouldFill: false,
                            shouldShowBorder: true)
                            .onTapGesture {
                            // Reset the on tap gesture
                            }.if(index != 0 && index != 4) {
                                $0.border(Color.black, width: 5)
                            }
                        StrikeZoneSeriesPitchOverlayView(
                            width: mainZoneWidth,
                            height: mainZoneHeight/10,//(pdfMode ? mainZoneHeight * 2 : mainZoneHeight)/10,
                            pitchLocation: index == 0 ? .OutLeftMiddle :
                                index == 1 ? .MiddleLeft :
                                index == 2 ? .Middle :
                                index == 3 ? .MiddleRight :
                                .OutRightMiddle,
                            playerViewing: getMembers(),
                            withPitchCounts: pitchTendenciesViewModel.getProperPitchCount(hand: pitcherHand)[index == 0 ? .OutLeftMiddle :
                                                            index == 1 ? .MiddleLeft :
                                                            index == 2 ? .Middle :
                                                            index == 3 ? .MiddleRight :
                                                            .OutRightMiddle] ?? [:])
                            .environmentObject(pitchTendenciesViewModel)
                    }.frame(width: mainZoneWidth, height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight)
                }
            }
            HStack {
                ForEach(0...4, id: \.self) { index in
                    ZStack {
                        StrikeZoneElementView(
                            width: mainZoneWidth,
                            height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight,
                            shouldFill: false,
                            shouldShowBorder: true)
                            .onTapGesture {
                            // Reset the on tap gesture
                            }.if(index != 0 && index != 4) {
                                $0.border(Color.black, width: 5)
                            }
                        StrikeZoneSeriesPitchOverlayView(
                            width: mainZoneWidth,
                            height: mainZoneHeight/10,
                            pitchLocation: index == 0 ? .OutLeftLow :
                                index == 1 ? .LowLeft :
                                index == 2 ? .LowMiddle :
                                index == 3 ? .LowRight : .OutRightLow,
                            playerViewing: getMembers(),
                            withPitchCounts: pitchTendenciesViewModel.getProperPitchCount(hand: pitcherHand)[index == 0 ? .OutLeftLow :
                                                            index == 1 ? .LowLeft :
                                                            index == 2 ? .LowMiddle :
                                                            index == 3 ? .LowRight : .OutRightLow] ?? [:])
                            .environmentObject(pitchTendenciesViewModel)
                    }.frame(width: mainZoneWidth, height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight)
                }
            }
            HStack {
                ForEach(0...4, id: \.self) { index in
                    ZStack {
                        StrikeZoneElementView(
                            width: mainZoneWidth,
                            height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight,
                            shouldFill: false,
                            shouldShowBorder: true)
                            .onTapGesture {
                            // Reset the on tap gesture
                            }
                        StrikeZoneSeriesPitchOverlayView(
                            width: mainZoneWidth,
                            height: mainZoneHeight/10, //(pdfMode ? mainZoneHeight * 2 : mainZoneHeight)/10,
                            pitchLocation: index == 0 ? .OutBottomLeftCorner :
                                index == 1 ? .OutBottomLeft :
                                index == 2 ? .OutBottomMiddle :
                                index == 3 ? .OutBottomRight :
                                .OutBottomLeftCorner,
                            playerViewing: getMembers(),
                            withPitchCounts: pitchTendenciesViewModel.getProperPitchCount(hand: pitcherHand)[index == 0 ? .OutBottomLeftCorner :
                                                            index == 1 ? .OutBottomLeft :
                                                            index == 2 ? .OutBottomMiddle :
                                                            index == 3 ? .OutBottomRight :
                                                            .OutBottomLeftCorner] ?? [:])
                            .environmentObject(pitchTendenciesViewModel)
                    }.frame(width: mainZoneWidth, height: pdfMode ? mainZoneHeight * 2 : mainZoneHeight)
                }
            }
            Divider()
            PitchTendencySeriesFastballCountView(pdfMode: pdfMode, membersViewing: getMembers(), playerEditing: playerEditing, pitcherHand: pitcherHand)
                .environmentObject(pitchTendenciesViewModel)
                .navigationBarTitle(Text("\(playerViewing.count > 1 ? "Multiple" : playerViewing.first?.member.getFullName() ?? "")"), displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        exportToPDF()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                }))
        }.padding()
    }
    
    func getMembers() -> [Member] {
        var members: [Member] = []
        for player in playerViewing {
            members.append(player.member)
        }
        return members
    }
    
    func exportToPDF() {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("PitchTendencies.pdf")

        //Normal with
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
            
        let charts = PitchTendenciesReportView(playerViewing: playerViewing,
                                               pitchCounts: pitchTendenciesViewModel.pitchCounts,
                                               showPDF: true,
                                               pdfMode: true,
                                               playerEditing: playerEditing,
                                               pitcherHand: pitcherHand)
            .environmentObject(pitchTendenciesViewModel)

        let pdfVC = UIHostingController(rootView: charts)
        pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        //Render the view behind all other views
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        rootVC?.addChild(pdfVC)
        rootVC?.view.insertSubview(pdfVC.view, at: 0)

        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))

        do {
            try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                context.beginPage()
                pdfVC.view.layer.render(in: context.cgContext)
            })

            self.pdfView = PDFViewUI(url: outputFileURL)
            self.showPDF = true

        }catch {
            // self.showError = true
            print("Could not create PDF file: \(error)")
        }

        print(outputFileURL)
        
        pdfVC.removeFromParent()
        pdfVC.view.removeFromSuperview()
    }
    
}

struct StrikeZoneSeriesPitchOverlayView : View {
    
    @EnvironmentObject var pitchTendenciesViewModel : PitchTendenciesViewModel
    
    var width: CGFloat
    var height: CGFloat
    
    var pitchCounts : [PitchType : Int] = [:]
    
    var keys : [PitchType] = []
    
    var pitchCountX: Int = 0
    var pitchCountY: Int = 0
    
    var pitchLocation : PitchLocation
    
    var playerViewing : [Member]

    init (width: CGFloat, height: CGFloat,
          pitchLocation: PitchLocation,
          playerViewing: [Member],
          withPitchCounts pitchCounts : [PitchType : Int]) {
        self.width = width
        self.height = height
        self.pitchLocation = pitchLocation
        self.playerViewing = playerViewing
        self.pitchCounts = pitchCounts
        keys = []
        for key in pitchCounts {
            keys.append(key.key)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<keys.count, id: \.self) { index in
                ForEach(0..<(pitchCounts[keys[index]] ?? 0),
                        id: \.self) {
                    pitchNum in
                    PitchSeriesCircleView(pitchNum: pitchNum,
                                    pichType: keys[index],
                                    width: width,
                                    height: height,
                                    xPos:
                                        getNextX(currentIndex: index,
                                                 currentPitchNum: pitchNum),
                                    yPos:
                                        getNextY(currentIndex: index,
                                                 currentPitchNum: pitchNum))
                }
            }
        }
    }
    
    func calculateCurrentPitch(currentIndex index : Int,
                        currentPitchNum pitchNum : Int) -> Int {
        var previousPitchNum: Int = 0
        
        for i in 0..<index {
            if let prevPitchCount = pitchCounts[keys[i]] {
                previousPitchNum += prevPitchCount
            }
        }
        return previousPitchNum + pitchNum
    }
    
    func getNextX(currentIndex index : Int,
                  currentPitchNum pitchNum : Int) -> CGFloat {
        return CGFloat((calculateCurrentPitch(currentIndex: index,
                                              currentPitchNum: pitchNum)
                            % 9) * 9 + 6)
        
    }
    
    func getNextY(currentIndex index : Int,
                  currentPitchNum pitchNum : Int) -> CGFloat {
        return CGFloat((calculateCurrentPitch(currentIndex: index,
                                              currentPitchNum: pitchNum)
                            / 9) * 9 + 6)
    }

}

struct PitchSeriesCircleView : View {
    
    var pitchNum: Int
    var pichType: PitchType
    
    var width: CGFloat
    var height: CGFloat
    
    var xPos: CGFloat
    var yPos: CGFloat
    
    var body: some View {
        Circle()
            .fill(getProperColor(forPitchType: pichType))
            .frame(width: width, height: height)
            .position(x: xPos,
                      y: yPos)
    }
    
    func getProperColor (forPitchType pitchType : PitchType) -> Color {
        if pitchType == .Fastball {
            return Color.red
        } else if pitchType == .Curveball || pitchType == .Slider {
            return Color.blue
        } else if pitchType == .Changeup {
            return Color.green
        }
        return Color.black
    }
}

struct PitchTendencySeriesFastballCountView : View {
    
    @EnvironmentObject var pitchTendenciesViewModel : PitchTendenciesSeriesReportViewModel
    
    let counts: [String] = ["0-0","1-0","0-1","1-1","HC","2K"]
    
    var pdfMode: Bool
    
    var membersViewing: [Member]
    
    var playerEditing : PersonEditing
    
    var pitcherHand: HandUsed?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                HStack(spacing: 0) {
                    PitchTendencySeriesFastballBaseCountLabelView(counts: counts, pdfMode: pdfMode)
                     
                    PitchTendencySeriesFastballBaseCountViewRow(title: "Bases Empty",
                                                                pdfMode: pdfMode,
                                                                playerViewing: membersViewing,
                                                                playerEditing: playerEditing,
                                                                pitchingHand: pitcherHand)
                        .environmentObject(pitchTendenciesViewModel)
                        //.border(Color.black)
                      //  .frame(width: geometry.size.width * 0.2)
                
                    PitchTendencySeriesFastballBaseCountViewRow(title: "Runner on First",
                                                          playerOnFirst: true,
                                                          pdfMode: pdfMode,
                                                          playerViewing: membersViewing,
                                                          playerEditing: playerEditing,
                                                          pitchingHand: pitcherHand)
                        .environmentObject(pitchTendenciesViewModel)
                        //.border(Color.black)
                       // .frame(width: geometry.size.width * 0.25)
                    PitchTendencySeriesFastballBaseCountViewRow(title: "RISP",
                                                          playerOnSecond: true,
                                                          playerOnThird: true,
                                                          allowCombinations: true,
                                                          pdfMode: pdfMode,
                                                          playerViewing: membersViewing,
                                                          playerEditing: playerEditing,
                                                          pitchingHand: pitcherHand)
                        .environmentObject(pitchTendenciesViewModel)
                        //.border(Color.black)
                      //  .frame(width: geometry.size.width * 0.25)
                    
                }
            }.frame(width: geometry.size.width * 0.8, alignment: .center)
        }
    }
}

struct PitchTendencySeriesFastballBaseCountLabelView : View {
    
    var counts : [String]
    
    var pdfMode: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Text("")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
//                    .if(!pdfMode, transform: {
//                        $0.padding()
//                    })
                    .border(Color.black)
                    .hidden()
                    .frame(height:
                            geometry.size.height/CGFloat((counts.count+1)))
                ForEach(0..<counts.count, id: \.self) { index in
                    Text(counts[index])
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
//                        .if(!pdfMode, transform: {
//                            $0.padding()
//                        })
                        .frame(height:
                                geometry.size.height/CGFloat((counts.count+1)))
                        .border(Color.black)
                        .font(.system(size: 13))
                }
                
            }.padding(0)
        }
    }
}

struct PitchTendencySeriesFastballBaseCountViewRow : View {
    @EnvironmentObject var pitchTendenciesViewModel : PitchTendenciesSeriesReportViewModel
    
    var title : String
    
    var playerOnFirst : Bool = false
    var playerOnSecond : Bool = false
    var playerOnThird : Bool = false
    
    var allowCombinations : Bool = false
    
    var pdfMode: Bool
    
    var playerViewing: [Member]
    
    var playerEditing : PersonEditing
    
    var pitchingHand: HandUsed?
    
    var body: some View {
        GeometryReader { geometry  in
            VStack(alignment: .center, spacing: 0) {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height:
                                geometry.size.height/CGFloat((7)))
                        .border(Color.black)
                        .font(.system(size: 13))
                    Text("\(FormatUtil.formatNumber(forNumber: NSNumber(value: calculateFastballPercentage(numBalls: 0, numStrikes: 0)), numberOfDecimalPlaces: 0))")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height:
                                geometry.size.height/CGFloat((7)))
                        .border(Color.black)
                        .font(.system(size: 13))
                    Text("\(FormatUtil.formatNumber(forNumber: NSNumber(value: calculateFastballPercentage(numBalls: 1, numStrikes: 0)), numberOfDecimalPlaces: 0))")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height:
                                geometry.size.height/CGFloat((7)))
                        .border(Color.black)
                        .font(.system(size: 13))
                    Text("\(FormatUtil.formatNumber(forNumber: NSNumber(value: calculateFastballPercentage(numBalls: 0, numStrikes: 1)), numberOfDecimalPlaces: 0))")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height:
                            geometry.size.height/CGFloat((7)))
                        .border(Color.black)
                        .font(.system(size: 13))
                    Text("\(FormatUtil.formatNumber(forNumber: NSNumber(value: calculateFastballPercentage(numBalls: 1, numStrikes: 1)), numberOfDecimalPlaces: 0))")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height:
                                geometry.size.height/CGFloat((7)))
                        .border(Color.black)
                        .font(.system(size: 13))
                Text("\(FormatUtil.formatNumber(forNumber: NSNumber(value:calculateHCFastballPercentage(withPitchingHand: pitchingHand)), numberOfDecimalPlaces: 0))")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height:
                                geometry.size.height/CGFloat((7)))
                        .border(Color.black)

                        .font(.system(size: 13))
                    Text("\(FormatUtil.formatNumber(forNumber: NSNumber(value: calculateFastballPercentage(numBalls: 0, numStrikes: 2)), numberOfDecimalPlaces: 0))")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height/CGFloat((7)))
                        .border(Color.black)
                        .font(.system(size: 13))
            }.padding(0)
        }
    }
    
    func calculateFastballPercentage(numBalls balls: Int,
                                     numStrikes strikes: Int,
                                     pitchThrown : PitchType = .Fastball)
    -> Double {
        
        var totalPitches = 0
        var totalFastballs = 0
        
        for pitcher in playerViewing {
            //
            totalFastballs += getTotalNumber(ofPitchThrown: pitchThrown,
                                             forPitcher: playerEditing == .Pitcher ? pitcher : nil,
                                             forHitter: playerEditing == .Hitter ? pitcher : nil,
                                             pitchingHand: pitchingHand,
                                                ballCount: balls,
                                                strikeCount: strikes)
            totalPitches += getTotalNumber(forPitcher: playerEditing == .Pitcher
                                            ? pitcher : nil,
                                           forHitter: playerEditing == .Hitter
                                            ? pitcher : nil,
                                           pitchingHand: pitchingHand,
                                              ballCount: balls,
                                              strikeCount: strikes)
        }
        
        if totalPitches == 0 {
            return 0
        }
        return Double(totalFastballs) / Double(totalPitches)
    }
    
    func getTotalNumber(ofPitchThrown pitch : PitchType? = nil,
                        forPitcher pitcher : Member? = nil,
                        forHitter hitter: Member? = nil,
                        pitchingHand: HandUsed? = nil,
                        ballCount : Int?=nil,
                        strikeCount : Int?=nil) -> Int {
        var totalNumber = 0
        // Get the pitch summary based on the given values
        // ballCount and strikeCount can be nil, which means
        // they will be ignored by the filter
        if allowCombinations {
            // Check if they want to have a player on first
            if playerOnFirst {
                totalNumber += pitchTendenciesViewModel.getTotal(
                    ofPitchThrown: pitch,
                    forPitcher: pitcher,
                    forHitter: hitter,
                    playerOnFirst: playerOnFirst,
                    playerOnSecond: false,
                    playerOnThird: false,
                    numBalls: ballCount,
                    numStrikes: strikeCount,
                    withPtchingHand: pitchingHand)
            }
            // Check if they want to have a player on first and second
            if playerOnFirst && playerOnSecond {
                totalNumber += pitchTendenciesViewModel.getTotal(
                    ofPitchThrown: pitch,
                    forPitcher: pitcher,
                    forHitter: hitter,
                    playerOnFirst: playerOnFirst,
                    playerOnSecond: playerOnSecond,
                    playerOnThird: false,
                    numBalls: ballCount,
                    numStrikes: strikeCount,
                    withPtchingHand: pitchingHand)
            }
            // Check if they want to have a player on all bases
            if playerOnFirst && playerOnSecond && playerOnThird {
                totalNumber += pitchTendenciesViewModel.getTotal(
                    ofPitchThrown: pitch,
                    forPitcher: pitcher,
                    forHitter: hitter,
                    playerOnFirst: playerOnFirst,
                    playerOnSecond: playerOnSecond,
                    playerOnThird: playerOnThird,
                    numBalls: ballCount,
                    numStrikes: strikeCount,
                    withPtchingHand: pitchingHand)
            }
            // Check if they only want a player on second
            if playerOnSecond {
                totalNumber += pitchTendenciesViewModel.getTotal(
                      ofPitchThrown: pitch,
                      forPitcher: pitcher,
                      forHitter: hitter,
                      playerOnFirst: false,
                      playerOnSecond: playerOnSecond,
                      playerOnThird: false,
                      numBalls: ballCount,
                      numStrikes: strikeCount,
                      withPtchingHand: pitchingHand)
            }
            // Check if they want a player on second and third
            if playerOnSecond && playerOnThird {
                totalNumber += pitchTendenciesViewModel.getTotal(
                    ofPitchThrown: pitch,
                    forPitcher: pitcher,
                    forHitter: hitter,
                    playerOnFirst: false,
                    playerOnSecond: playerOnSecond,
                    playerOnThird: playerOnThird,
                    numBalls: ballCount,
                    numStrikes: strikeCount,
                    withPtchingHand: pitchingHand)
            }
            // Check if they want a player on third
            if playerOnThird {
                totalNumber += pitchTendenciesViewModel.getTotal(
                    ofPitchThrown: pitch,
                    forPitcher: pitcher,
                    forHitter: hitter,
                    playerOnFirst: false,
                    playerOnSecond: false,
                    playerOnThird: playerOnThird,
                    numBalls: ballCount,
                    numStrikes: strikeCount,
                    withPtchingHand: pitchingHand)
            }
            // Check if they want a player on first and third
            if playerOnThird && playerOnFirst {
                totalNumber += pitchTendenciesViewModel.getTotal(
                    ofPitchThrown: pitch,
                    forPitcher: pitcher,
                    forHitter: hitter,
                    playerOnFirst: playerOnFirst,
                    playerOnSecond: false,
                    playerOnThird: playerOnThird,
                    numBalls: ballCount,
                    numStrikes: strikeCount,
                    withPtchingHand: pitchingHand)
            }
        } else {
            totalNumber = pitchTendenciesViewModel.getTotal(
                ofPitchThrown: pitch,
                forPitcher: pitcher,
                forHitter: hitter,
                playerOnFirst: playerOnFirst,
                playerOnSecond: playerOnSecond,
                playerOnThird: playerOnThird,
                numBalls: ballCount,
                numStrikes: strikeCount,
                withPtchingHand: pitchingHand)
        }
        
        // Return the total number
        return totalNumber
    }
    
    func calculateHCFastballPercentage(pitchThrown : PitchType = .Fastball,
                                withPitchingHand pHand: HandUsed? = nil)
        -> Double  {
        
        // Store the total number of fastballs
        var totalFastballs: Int = 0
        // Store the total number of pitches
        var totalPitches: Int = 0
        
        for pitcher in playerViewing {
            // Store the HC for ball and strikes
            // Index's line up with count
            // Ex. @ index = 0, numBalls = 1, numStrikes = 0 (1-0 count)
            let ballCount = [1, 2, 3, 2, 3]
            let strikeCount = [0, 0, 0, 1, 1]
            
            // Go through each ball count
            for index in 0..<ballCount.count {
                // Add the number of fastballs to the total
                totalFastballs += getTotalNumber(ofPitchThrown: pitchThrown,
                                                 forPitcher: playerEditing == .Pitcher ? pitcher : nil,
                                                 forHitter: playerEditing == .Hitter ? pitcher : nil,
                                                 pitchingHand: pHand,
                                                 ballCount: ballCount[index],
                                                 strikeCount:
                                                    strikeCount[index])
                // Get the summary of the total pitches
                totalPitches += getTotalNumber(forPitcher: playerEditing == .Pitcher ? pitcher : nil,
                                               forHitter: playerEditing == .Hitter ? pitcher : nil,
                                               pitchingHand: pHand,
                                                  ballCount: ballCount[index],
                                                  strikeCount: strikeCount[index])
            }
        }
        // Check if the total pitches is 0
        if totalPitches == 0 {
            return 0
        }
        // Return the calculation
        return Double(totalFastballs) / Double(totalPitches)
    }
    
}

