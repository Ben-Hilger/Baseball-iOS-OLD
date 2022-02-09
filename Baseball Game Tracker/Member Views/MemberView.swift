// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct MemberView: View {
    
    @State var member : Member
    var teamPrimaryColor : Color
    
    var typeSelected : MemberInformationCellType = .FirstName
    
    var body: some View {
        VStack {
            VStack {
                Text("Member Information")
                    .font(.largeTitle)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(teamPrimaryColor)
            List {
                ForEach(0..<MemberInformationCellType.allCases.count, id: \.self) { index in
                    switch MemberInformationCellType.allCases[index] {
                    case .FirstName:
                        MemberInformationCell(info: member.firstName, type: .FirstName, typeSelected: typeSelected, member: $member)
                    case .LastName:
                        MemberInformationCell(info: member.lastName, type: .LastName, typeSelected: typeSelected, member: $member)
                    case .NickName:
                        MemberInformationCell(info: member.nickName, type: .NickName, typeSelected: typeSelected, member: $member)
                    case .Height:
                        MemberInformationCell(info: "\(member.height)", type: .Height, typeSelected: typeSelected, member: $member)
                    case .HighSchool:
                        MemberInformationCell(info: member.highSchool, type: .HighSchool, typeSelected: typeSelected, member: $member)
                    case .Hometown:
                        MemberInformationCell(info: member.hometown, type: .Hometown, typeSelected: typeSelected, member: $member)
                    case .Positions:
                        MemberInformationCell(info: PositionUtil.getPositionsPrintable(forPostions: member.positions), type: .Positions, typeSelected: typeSelected, member: $member)
                    case .Weight:
                        MemberInformationCell(info: "\(member.weight)", type: .Weight, typeSelected: typeSelected, member: $member)
                    case .Bio:
                        MemberInformationCell(info: member.bio, type: .Bio, typeSelected: typeSelected, member: $member)
                    case .Role:
                        MemberInformationCell(info: member.role.getString(), type: .Role, typeSelected: typeSelected, member: $member)
                    case .UniformNumber:
                        MemberInformationCell(info: "\(member.uniformNumber)", type: .UniformNumber, typeSelected: typeSelected, member: $member)
                    case .ThrowingHand:
                        MemberInformationCell(info: member.throwingHand.getString(), type: .ThrowingHand, typeSelected: typeSelected, member: $member)
                    case .HittingHand:
                        MemberInformationCell(info: member.hittingHand.getString(), type: .HittingHand, typeSelected: typeSelected, member: $member)
                    case .PlayerClass:
                        MemberInformationCell(info: member.playerClass.getString(), type: .PlayerClass, typeSelected: typeSelected, member: $member)
                    case .isRedshirt:
                        MemberInformationCell(info: member.isRedshirt ? "Redshirt" : "Not Redshirt", type: .isRedshirt, typeSelected: typeSelected, member: $member)
                    }
                }
            }
            .navigationBarTitle(Text(member.getFullName()))

        }
    }
}

struct MemberInformationCell : View {
    
    var info : String
    
    var type : MemberInformationCellType
    var typeSelected : MemberInformationCellType?
    
    @Binding var member : Member
    
    var body: some View {
        VStack {
            Text("\(type.getString()): \(info)")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding()
                .border(Color.black)
            if typeSelected == type  {
                TextField(member.firstName, text: Binding(get: {
                    member.firstName
                }, set: { (newVal) in
                    member.firstName = newVal
                }))
            }
//            if type == typeSelected {
//                switch type {
//                case .FirstName:
//                    TextField(member.firstName, text: Binding(get: {
//                        member.firstName
//                    }, set: { (newVal) in
//                        member.firstName = newVal
//                    }))
//                case .LastName:
//                    TextField(member.lastName, text: Binding(get: {
//                        member.lastName
//                    }, set: { (newVal) in
//                        member.lastName = newVal
//                    }))
//                case .NickName:
//                    TextField(member.nickname, text: Binding(get: {
//                        member.nickname
//                    }, set: { (newVal) in
//                        member.nickname = newVal
//                    }))
//                case .Height:
//                    HStack {
//
//                    }
//                case .HighSchool:
//                    HStack {
//
//                    }
//                case .Hometown:
//                    HStack {
//
//                    }
//                case .Positions:
//                    HStack {
//
//                    }
//                case .Weight:
//                    HStack {
//
//                    }
//                case .Bio:
//                    HStack {
//
//                    }
//                case .Role:
//                    HStack {
//
//                    }
//                case .UniformNumber:
//                    HStack {
//
//                    }
//                case .ThrowingHand:
//                    HStack {
//
//                    }
//                case .HittingHand:
//                    HStack {
//
//                    }
//                case .PlayerClass:
//                    HStack {
//
//                    }
//                case .isRedshirt:
//                    HStack {
//
//                    }
//                }
//            }
        }
    }
}

enum MemberInformationCellType : CaseIterable {
    case FirstName
    case LastName
    case NickName
    case Height
    case HighSchool
    case Hometown
    case Positions
    case Weight
    case Bio
    case Role
    case UniformNumber
    case ThrowingHand
    case HittingHand
    case PlayerClass
    case isRedshirt
    
    func getString() -> String {
        switch self {
        case .FirstName:
            return "First Name"
        case .LastName:
            return "Last Name"
        case .NickName:
            return "Nickname"
        case .Height:
            return "Height"
        case .HighSchool:
            return "High School"
        case .Hometown:
            return "Hometown"
        case .Positions:
            return "Positions"
        case .Weight:
            return "Weight"
        case .Bio:
            return "Bio"
        case .Role:
            return "Role"
        case .UniformNumber:
            return "Uniform Number"
        case .ThrowingHand:
            return "Throwing Hand"
        case .HittingHand:
            return "Hitting Hand"
        case .PlayerClass:
            return "Class"
        case .isRedshirt:
            return "Redshirted"
        }
    }
}
