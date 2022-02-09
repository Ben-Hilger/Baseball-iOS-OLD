////
////  MongoViewModel.swift
////  MU baseball game tracker
////
////  Created by Benjamin Hilger on 2/27/21.
////
//
// Copyright 2021-Present Benjamin Hilger


//import Foundation
//import RealmSwift
//import Combine
//
//let USE_REALM_SYNC = true
//
//let app : App? = App(id: "miamibaseballrealm-gtidg")
//
//class MongoDBViewModel: ObservableObject {
//
//    var loginPublisher = PassthroughSubject<User, Error>()
//
//    var cancellables = Set<AnyCancellable>()
//
//    let loader: MongoDBLoader = MongoDBLoader()
//    let writer: MongoDBWriter = MongoDBWriter()
//
//    @Published var shouldIndicateWork: Bool = false
//
//    @Published var seasons: Results<RealmSeason>?
//    @Published var teams: Results<RealmTeam>?
//
//    init() {
//        // Setup the realm publisher when a realm is sent
//        let realmPublisher = PassthroughSubject<Realm, Error>()
//        realmPublisher.sink { (result) in
//            switch result {
//            case .failure(let error):
//                print("Failed to log in and open realm: \(error)")
//            case .finished:
//                print("Finished")
//            }
//        } receiveValue: { (realm) in
//            print("Loading information...")
//            // Get the seasons
//            self.seasons = realm.objects(RealmSeason.self)
//
////
//            let spring = RealmSeason()
//            spring.name = "Spring"
//            spring.year = 2021
//           // self.writer.save(objectsToSave: [spring])
//            // Get the teams
//            self.teams = realm.objects(RealmTeam.self)
//        }.store(in: &cancellables)
//
//        guard let app = app else {
//            return
//        }
//
//        // Setup login publisher when a user is sent
//        loginPublisher
//            .receive(on: DispatchQueue.main)
//            .flatMap { (user) -> RealmPublishers.AsyncOpenPublisher in
//                // Setup the configuration with the core partition key
//                let configuration = user.configuration(
//                    partitionValue: MongoDBKeys.corePartitionKey)
//                // Indicates works
//                self.shouldIndicateWork = true
//                // Returns the opened realm
//                print("Logging in user")
//                return Realm.asyncOpen(configuration: configuration)
//            }
//            .receive(on: DispatchQueue.main)
//            .map {
//                // Indicates work is done
//                self.shouldIndicateWork = false
//                // Returns the realm
//                return $0
//            }
//            .subscribe(realmPublisher)
//            .store(in: &self.cancellables)
//
//        // Check if there's a user already logged in (most likely not,
//        // but it never hurts to check)
//        guard let user = app.currentUser else {
//            // Logs in the user anonymously
//            loginUser { (user) in
//                // Sends the user to the login publisher
//                self.loginPublisher.send(user)
//            }
//            // Stops the method
//            return
//        }
//        // Sends the user to the login publisher
//        loginPublisher.send(user)
//    }
//
//    func loginUser(completion: @escaping (User) -> Void) {
//        // Ensure realm sync is on, otherwise don't login
//        guard let app = app else {
//            return
//        }
//        // Logs in the user anonymously
//        let credentials = Credentials.emailPassword(email: "hilgerbj@miamioh.edu", password: "MiamiBaseball2324dSFWEF")
//        app.login(credentials: credentials) { (result) in
//            // Return to the main thread upon completion
//            DispatchQueue.main.async {
//                switch result {
//                // Login failed
//                case .failure(let error):
//                    print("Login failed: \(error)")
//                // Login succedded
//                case .success(let user):
//                    print("Logged in as user: \(user)")
//                    completion(user)
//                }
//            }
//        }
//    }
//}
//struct MongoDBLoader {
//
//    func loadSeasons(completion: @escaping (Results<RealmSeason>?) -> Void) {
//        guard let currentUser = app?.currentUser else {
//            return
//        }
//        // Configure the configuration to get all of the seasons
//        let configuration = currentUser.configuration(partitionValue:
//                                                MongoDBKeys.corePartitionKey)
//        //configuration.objectTypes = [RealmSeason.self]
//        Realm.asyncOpen(configuration: configuration) { (result) in
//            switch result {
//            case .failure(let error):
//                print("Failed to load seasons: \(error)")
//                completion(nil)
//            case .success(let realm):
//                let seasons = realm.objects(RealmSeason.self)
//                completion(seasons)
//            }
//        }
//    }
//}
//
//struct MongoDBWriter {
//
//    func save(objectsToSave objects: [RealmBase]) {
//        // Ensure a user is logged in
//        guard let currentUser = app?.currentUser else {
//            return
//        }
//        print("Saving...")
//        // Iterate through all of the objects to save
//            // Setup the configuration to the current object
//            var configuration = currentUser.configuration(partitionValue:
//                                                            MongoDBKeys.corePartitionKey)
////            configuration.objectTypes = [RealmMember.self, RealmSeason.self,
////                                         RealmSeasonTeam.self, RealmTeam.self,
////                                         RealmGame.self, RealmGameSnapshot.self,
////                                         RealmBasePathEventInfo.self,
////                                         RealmGameLineupMemberInfo.self, RealmSeasonTeamRosterMember.self]
//        configuration.objectTypes = [RealmTeam.self]
//            // Open the realm connection
//            print("Opening Realm")
//            Realm.asyncOpen(configuration: configuration) { (result) in
//                print("The result is in \(result)")
//                switch result {
//                case .failure(let error):
//                    // Report the failure to the console
//                    print("Failed to open realm: \(error)")
//                case .success(let realm):
//                    // Update the object information
//                    try! realm.write({
//                        for object in objects {
//                            realm.add(object, update: .all)
//                            print("Saved: \(object._id)")
//                        }
//                    })
//                }
//            }
//
//    }
//}
//
//
