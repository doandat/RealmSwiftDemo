//
//  Dog.swift
//  RealmSwiftDemo
//
//  Created by DatDV on 9/20/16.
//  Copyright © 2016 DatDV. All rights reserved.
//

import Foundation
import RealmSwift

class Dog: Object {
    
    dynamic var name = ""
    dynamic var age = 0
    
    let owners = LinkingObjects(fromType: Person.self, property: "dogs")

//    dynamic var owner: Person? // Properties can be optional

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return ["name"]
//  }
    override static func primaryKey() -> String? {
        return "name"
    }
}
