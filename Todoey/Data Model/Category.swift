//
//  Category.swift
//  Todoey
//
//  Created by ASJ on 2018. 1. 30..
//  Copyright © 2018년 ASJ. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name:String = ""
    let items = List<Item>() // Forward Relationship - point to Item
}
