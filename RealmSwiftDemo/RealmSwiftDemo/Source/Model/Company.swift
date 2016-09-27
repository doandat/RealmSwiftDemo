//
//  Company.swift
//  RealmSwiftDemo
//
//  Created by DatDV on 9/23/16.
//  Copyright © 2016 DatDV. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Company: Object, Mappable {
    
    dynamic var name = ""
    dynamic var id = ""
    
    
    //Mappable
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]

    }
    
    //Realm 
    override static func primaryKey() -> String? {
        return "id"
    }

}
