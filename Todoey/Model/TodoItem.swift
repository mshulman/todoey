//
//  TodoItem.swift
//  Todoey
//
//  Created by Michael on 11/10/19.
//  Copyright © 2019 Michael Shulman. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date? 
    var parentCategory = LinkingObjects(fromType: TodoCategory.self, property: "items")
}
