//
//  Item.swift
//  Todoey
//
//  Created by ASJ on 2018. 1. 30..
//  Copyright © 2018년 ASJ. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Inverse realtionship of items in Category class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
