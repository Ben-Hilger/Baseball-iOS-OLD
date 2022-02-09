//
//  MongoDB.swift
//  MU baseball game tracker
//
//  Created by Benjamin Hilger on 2/21/21.
//

import Foundation
import RealmSwift

class MongoDBViewModel {
    
    let app = App(id: "")
    
    let partitionValue = "baseballpartition"
    
    func loginUser(completion: @escaping () -> Void) {
        // Logs in the user anonymously
        app.login(credentials: Credentials.anonymous) { (result) in
            // Return to the main thread upon completion
            DispatchQueue.main.async {
                switch result {
                // Login failed
                case .failure(let error):
                    print("Login failed: \(error)")
                // Login succedded
                case .success(let user):
                    print("Logged in as user: \(user)")
                    completion()
                }
            }
        }
    }
    
    func setupMongoDBConnection(testMember member: Member) {
        let currentUser = app.currentUser!
    
        var configuration = currentUser.configuration(partitionValue: partitionValue)
        
        configuration.objectTypes = [RealmMember.self]
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error)")
            case .success(let realm):
                print("Successfully opened realm: \(realm)")
                let realmMember = RealmMember()
                realmMember._id = member.memberID
                realmMember.bio = member.bio
                realmMember.firstName = member.firstName
                realmMember.height = member.height
                realmMember.highSchool = member.highSchool
                realmMember.hittingHand = member.hittingHand.rawValue
                realmMember.homeTown = member.hometown
                realmMember.isRedshirt = member.isRedshirt
                realmMember.lastName = member.lastName
                realmMember.nickName = member.nickName
                realmMember.playerClass = member.playerClass.rawValue
                var convertedPositions: [Int] = []
                for positon in member.positions {
                    convertedPositions.append(positon.rawValue)
                }
                realmMember.positions = convertedPositions
                realmMember.role = member.role.rawValue
                realmMember.throwingHand = member.throwingHand.rawValue
                realmMember.uniformNumber = Int(member.uniformNumber)
                realmMember.weight = member.weight
                self.saveMemberInformation(memberToSave: realmMember)
            }
            
        }
    }
        
    func saveMemberInformation(memberToSave member: RealmMember) {
        
        guard let currentUser = app.currentUser else {
            return
        }
        
        var configuration = currentUser.configuration(
            partitionValue: partitionValue)
        
        configuration.objectTypes = [RealmMember.self]
        
        Realm.asyncOpen(configuration: configuration) { (result) in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error)")
            case .success(let realm):
                try! realm.write({
                    realm.add(member, update: .modified)
                })
            }
        }
    }
    
}

class RealmMember: Object {
    
    @objc dynamic var  _id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var nickName: String = ""
    @objc dynamic var height: Int = 0
    @objc dynamic var highSchool: String = ""
    @objc dynamic var homeTown: String = ""
    @objc dynamic var positions: [Int] = []
    @objc dynamic var weight: Int = 0
    @objc dynamic var bio: String = ""
    @objc dynamic var role: Int = 0
    @objc dynamic var uniformNumber: Int = 0
    @objc dynamic var throwingHand: Int = 0
    @objc dynamic var hittingHand: Int = 0
    @objc dynamic var playerClass: Int = 0
    @objc dynamic var isRedshirt: Bool = false
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
}

