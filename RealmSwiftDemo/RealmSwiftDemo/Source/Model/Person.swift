//
//  Person.swift
//  RealmSwiftDemo
//
//  Created by DatDV on 9/20/16.
//  Copyright © 2016 DatDV. All rights reserved.
//

import Foundation
import RealmSwift


class Person: Object {

//    dynamic var id = ""

    // V0
//       dynamic var firstName = ""
//       dynamic var lastName = ""
//       dynamic var age = 0

    // V1
       dynamic var fullName = "" // new property
       dynamic var age = 0

    
    // V2
//    dynamic var fullName = ""
//    dynamic var email = "" // new property
//    dynamic var age = 0
    
    //V3
//    dynamic var name        = ""
//    dynamic var birthdate   = NSDate(timeIntervalSince1970: 1)
    
    // Optional int property, defaulting to nil
    // RealmOptional properties should always be declared with `let`,
    // as assigning to them directly will not work as desired
//    let age = RealmOptional<Int>()
    
    let dogs = List<Dog>()

//    dynamic var age:String = nil
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
