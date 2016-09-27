//
//  AppDelegate.swift
//  RealmSwiftDemo
//
//  Created by DatDV on 9/20/16.
//  Copyright © 2016 DatDV. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        print(documentsPath)


        //setDefaultRealmForUser("DBName1")
        
        //configMigrations()
        
        //copyDB("TestDB")

        //testInsertPersonV0()
        
        //testInsertPersonV1()
        
        //setValueForkeypath()
        
        //testAutoUpdate()
        
        
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Migrations
    func configMigrations()
    {
        //
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: {
                migration, oldSchemavarsion in
                if (oldSchemavarsion < 1) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    migration.enumerate(Person.className(), { (oldObject, newObject) in
                        // combine name fields into a single field
                        let firstName = oldObject!["firstName"] as! String
                        let lastName = oldObject!["lastName"] as! String
                        newObject!["fullName"] = "\(firstName) \(lastName)"
                        
                    })
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    //MARK: Setup DB Name
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL?.URLByDeletingLastPathComponent!.URLByAppendingPathComponent("\(username).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    func bundleURL(name: String) -> NSURL? {
        return NSBundle.mainBundle().URLForResource(name, withExtension: "realm")
    }
    

    //Copy DB to device
    func copyDB(dbName:String) -> Bool
    {
        let fileManager = NSFileManager.defaultManager()
        
//        var err : NSError?
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        var documentsDirectory: String = paths[0]
        
        documentsDirectory.appendContentsOf("/\(dbName).realm")

        do {
            if fileManager.fileExistsAtPath(documentsDirectory) == false
            {
                if let dbDirectory = NSBundle.mainBundle().pathForResource(dbName, ofType: "realm")
                {
                    try fileManager.copyItemAtPath(dbDirectory, toPath: documentsDirectory)
                    
                    return true
                }
                
            }
            else
            {
                print("file exists!")
            }
        }
        catch let err as NSError
        {
            print("err: \(err)")
        }
       
        return false
    }
    
    
    //MARK: Get Data from DB in Bundle (not copy to Device)
    func getDataFromDB()
    {
        let config = Realm.Configuration(
            // Get the URL to the bundled file
            //            fileURL: Bundle().main.url(forResource: "MyBundledData", withExtension: "realm"),
            fileURL: bundleURL("TestDB"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)
        
        // Open the Realm with the configuration
        let realm = try! Realm(configuration: config)
        
        // Read some data from the bundled Realm
        let results = realm.objects(Dog.self)
    }

    
    //MARK: Realm + ObjectMapple
    
    func testRealmMappable()
    {
        for _ in 0..<10 {
             let company = Company()
            company.name = "demo"

            company.id = NSUUID().UUIDString
         
             let realm = try! Realm()
         
             try! realm.write {
                 realm.add(company, update: true)
             }
             
         }
    }
    

    func testInsertPersonV0()
    {
        let myDog1 = Dog()
        myDog1.name = "Fido"
        myDog1.age = 1
        
        let myDog2 = Dog()
        myDog2.name = "Fido 2"
        myDog2.age = 2
        
        let person = Person(value: ["Doan","Dat", 20 , [myDog1, myDog2]])
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(person)
        }
        
    }
    
    func testInsertPersonV1()
    {
        let myDog1 = Dog()
        myDog1.name = "Fido"
        myDog1.age = 1
        
        let myDog2 = Dog()
        myDog2.name = "Fido 2"
        myDog2.age = 2
        
        let person = Person(value: ["Hoang Viet", 30 , []])
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(person)
        }
        
    }
    
    func setValueForkeypath()
    {
        let realm = try! Realm()
        
        let myDogs = realm.objects(Dog.self)
        
        try! realm.write {
            myDogs.first?.setValue(200, forKeyPath: "age")
            // set each dog's age property to "age"
            myDogs.setValue(200, forKeyPath: "age")
        }

    }
    
    func testFilter()
    {
        let realm = try! Realm()

        let tanDogs = realm.objects(Dog.self).filter("name BEGINSWITH 'F'")
        let dogsSorted = tanDogs.sorted("age", ascending: true)

    }
    
    func testDelete()
    {
        let dog = Dog()
        dog.name = "Fido"
        
        let realm = try! Realm()

        try! realm.write {
            realm.delete(dog)
        }
        
        //delete all
//        try! realm.write {
//            realm.deleteAll()
//        }
    }
    
    func testAutoUpdate()
    {
        let myDog = Dog()
        myDog.name = "Fido"
        myDog.age = 1
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(myDog)
        }
        
        let myPuppy1 = realm.objects(Dog.self).filter("name == Fido").first
        
        
        let myPuppy = realm.objects(Dog.self).filter("name == Fido").first
        
        try! realm.write {
            myPuppy!.age = myPuppy!.age + 1
        }

        
        print("age of my dog: \(myDog.age)") // => 2
        print("age of my dog: \(myPuppy1!.age)") // => 2
    }
    
}

